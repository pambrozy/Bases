//
//  Base85.swift
//  Bases
//
//  Created by Przemek Ambroży on 08.05.2022.
//  Copyright © 2022 Przemysław Ambroży
//

import Foundation

/// The Base-85 encoding.
public enum Base85 {

    // MARK: - Alphabet

    /// An alphabet defining a set of characters used for the Base-85 encoding.
    public struct Alphabet: Equatable {
        /// The ordered array mapping the 85 values to ASCII character codes.
        public let characters: [Character]

        /// The ordered array mapping the 128 ASCII character codes to values.
        public let values: [UInt8?]

        /// The delimeter at the beginning of the encoded string.
        public let startDelimeter: String?

        /// The delimeter at the end of the encoded data.
        public let endDelimeter: String?

        /// An optional character representing data consisting of four `0` bytes.
        public let fourZeros: Character?

        /// An optional character representing data consisting of four spaces.
        public let fourSpaces: Character?

        init(
            uncheckedCharacters: [Character],
            uncheckedValues: [UInt8?],
            startDelimeter: String?,
            endDelimeter: String?,
            fourZeros: Character?,
            fourSpaces: Character?
        ) {
            self.characters = uncheckedCharacters
            self.values = uncheckedValues
            self.startDelimeter = startDelimeter
            self.endDelimeter = endDelimeter
            self.fourZeros = fourZeros
            self.fourSpaces = fourSpaces
        }

        /// Creates a new alphabet.
        /// - Parameters:
        ///   - characters: An array of 64 ASCII characters.
        ///   - startDelimeter: The delimeter at the beginning of the encoded string.
        ///   - endDelimeter: The delimeter at the end of the encoded data.
        ///   - fourZeros: An optional character representing data consisting of four `0` bytes.
        ///   - fourSpaces: An optional character representing data consisting of four spaces.
        public init(
            characters: [Character],
            startDelimeter: String?,
            endDelimeter: String?,
            fourZeros: Character?,
            fourSpaces: Character?
        ) throws {
            guard characters.count == 85 else {
                throw AlphabetError.wrongNumberOfCharacters
            }

            let asciiValues = try characters.map { character -> UInt8 in
                guard let asciiValue = character.asciiValue else {
                    throw AlphabetError.noAsciiValue
                }
                return asciiValue
            }

            var values = [UInt8?](repeating: nil, count: 128)
            for (index, asciiValue) in asciiValues.enumerated() {
                values[Int(asciiValue)] = UInt8(index)
            }

            self.characters = characters
            self.values = values
            self.startDelimeter = startDelimeter
            self.endDelimeter = endDelimeter
            self.fourZeros = fourZeros
            self.fourSpaces = fourSpaces
        }
    }

    // MARK: - Encoder

    /// The Base-85 Encoder.
    public struct Encoder {
        let alphabet: Alphabet

        /// Creates a new encoder.
        /// - Parameter alphabet: The alphabet to use when encoding data.
        public init(alphabet: Alphabet) {
            self.alphabet = alphabet
        }

        /// Encodes the given data.
        /// - Parameter data: The data to encode.
        /// - Returns: A string containing the Base-32 encoded data.
        public func encode<T: DataProtocol>(_ data: T) -> String {
            guard !data.isEmpty else {
                return ""
            }

            let padding = data.count.isMultiple(of: 4) ? 0 : 4 - (data.count % 4)
            let padCharacterCount = padding * 5 / 4

            let data = Array(data) + [UInt8](repeating: 0, count: padding)

            var output = data
                .chunks(ofCount: 4)
                .flatMap { chunk -> [Character] in
                    let number = UInt32(
                        bigEndian: ContiguousArray(chunk).withUnsafeBytes { $0.load(as: UInt32.self) }
                    )

                    return [
                        alphabet.characters[Int((number / 52_200_625) % 85)],
                        alphabet.characters[Int((number / 614_125) % 85)],
                        alphabet.characters[Int((number / 7_225) % 85)],
                        alphabet.characters[Int((number / 85) % 85)],
                        alphabet.characters[Int(number % 85)]
                    ]
                }
                .dropLast(padCharacterCount)
                .chunks(ofCount: 5)
                .flatMap(addZerosSpacesCharacters(in:))

            // Result cannot end with zeros
            if let zeroCharacter = alphabet.fourZeros, output.last == zeroCharacter {
                output.removeLast()
                output += Array(repeating: alphabet.characters[0], count: 5)
            }

            // Add delimeters
            if let startDelimeter = alphabet.startDelimeter {
                output = startDelimeter + output
            }
            if let endDelimeter = alphabet.endDelimeter {
                output += endDelimeter
            }

            return String(output)
        }

        private func addZerosSpacesCharacters(in chunk: ArraySlice<Character>) -> [Character] {
            if chunk.count == 5 {
                if chunk[chunk.startIndex] == alphabet.characters[0],
                   chunk[chunk.startIndex + 1] == alphabet.characters[0],
                   chunk[chunk.startIndex + 2] == alphabet.characters[0],
                   chunk[chunk.startIndex + 3] == alphabet.characters[0],
                   chunk[chunk.startIndex + 4] == alphabet.characters[0],
                   let zeroCharacter = alphabet.fourZeros {
                    // Replace zeros
                    return [zeroCharacter]
                } else if chunk[chunk.startIndex] == alphabet.characters[10],
                          chunk[chunk.startIndex + 1] == alphabet.characters[27],
                          chunk[chunk.startIndex + 2] == alphabet.characters[53],
                          chunk[chunk.startIndex + 3] == alphabet.characters[67],
                          chunk[chunk.startIndex + 4] == alphabet.characters[43],
                          let spaceCharacter = alphabet.fourSpaces {
                    // Replace spaces
                    return [spaceCharacter]
                }
            }
            return Array(chunk)
        }
    }

    // MARK: - Decoder

    /// The Base-32 Decoder.
    public struct Decoder {
        /// The alphabet used to decode data.
        public let alphabet: Alphabet

        /// Creates a new decoder.
        /// - Parameter alphabet: The alphabet to use when decoding data.
        public init(alphabet: Alphabet) {
            self.alphabet = alphabet
        }

        /// Decodes a given string.
        /// - Parameter text: The string containing the Base-85 encoded data.
        /// - Returns: The decoded data.
        public func decode(_ text: String) throws -> Data {
            guard !text.isEmpty else {
                return Data()
            }
            var text = text

            // Remove delimeters
            if let startDelimeter = alphabet.startDelimeter, text.hasPrefix(startDelimeter) {
                text.removeFirst(startDelimeter.count)
            }
            if let endDelimeter = alphabet.endDelimeter, text.hasSuffix(endDelimeter) {
                text.removeLast(endDelimeter.count)
            }

            // Replace four zeros
            replaceFourZeros(in: &text)

            // Replace four spaces
            replaceFourSpaces(in: &text)

            // Calculate pad characters
            let padCharacterCount = text.count.isMultiple(of: 5) ? 0 : 5 - (text.count % 5)

            text += String(repeating: alphabet.characters[84], count: padCharacterCount)

            var data = try text
                .map { character -> UInt8 in
                    guard let asciiValue = character.asciiValue else {
                        throw BaseDecodingError.nonAsciiCharacters
                    }
                    guard let value = alphabet.values[Int(asciiValue)] else {
                        throw BaseDecodingError.valuesNotInAlphabet
                    }
                    return value
                }
                .chunks(ofCount: 5)
                .flatMap { chunk -> [UInt8] in
                    let number: UInt32 =
                        (UInt32(chunk[chunk.startIndex]) * 52_200_625) +
                        (UInt32(chunk[chunk.startIndex + 1]) * 614_125) +
                        (UInt32(chunk[chunk.startIndex + 2]) * 7_225) +
                        (UInt32(chunk[chunk.startIndex + 3]) * 85) +
                        (UInt32(chunk[chunk.startIndex + 4]))

                    return [
                        UInt8((number >> 24) & 0xFF),
                        UInt8((number >> 16) & 0xFF),
                        UInt8((number >> 8) & 0xFF),
                        UInt8(number & 0xFF)
                    ]
                }

            if padCharacterCount > 0 {
                data.removeLast((padCharacterCount + 1) * 3 / 4)
            }

            return Data(data)
        }

        private func replaceFourZeros(in text: inout String) {
            guard let zerosCharacter = alphabet.fourZeros else {
                return
            }
            text = text.replacingOccurrences(
                of: String(zerosCharacter),
                with: String(
                    [
                        alphabet.characters[0],
                        alphabet.characters[0],
                        alphabet.characters[0],
                        alphabet.characters[0],
                        alphabet.characters[0]
                    ]
                )
            )
        }

        private func replaceFourSpaces(in text: inout String) {
            guard let spaceCharacter = alphabet.fourSpaces else {
                return
            }
            text = text.replacingOccurrences(
                of: String(spaceCharacter),
                with: String(
                    [
                        alphabet.characters[10],
                        alphabet.characters[27],
                        alphabet.characters[53],
                        alphabet.characters[67],
                        alphabet.characters[43]
                    ]
                )
            )
        }
    }
}
