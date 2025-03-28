//
//  Base32.swift
//  Bases
//
//  Created by Przemek Ambroży on 06.05.2022.
//  Copyright © 2022 Przemysław Ambroży
//

import Foundation

/// The Base-32 encoding.
public enum Base32 {

    // MARK: - Alphabet

    /// An alphabet defining a set of characters used for the Base-32 encoding.
    public struct Alphabet: Hashable, Sendable {
        /// The ordered array mapping the 32 values to ASCII character codes.
        public let characters: [Character]

        /// The ordered array mapping the 128 ASCII character codes to values.
        public let values: [UInt8?]

        /// The optional padding character used to pad the data.
        public let padding: Character?

        init(uncheckedCharacters: [Character], uncheckedValues: [UInt8?], padding: Character?) {
            self.characters = uncheckedCharacters
            self.values = uncheckedValues
            self.padding = padding
        }

        /// Creates a new alphabet.
        /// - Parameters:
        ///   - characters: An array of 32 arrays of ASCII characters.
        ///   Each of the 32 arrays should consist of at least one character.
        ///   The first character in the array will be used for encoding data.
        ///   - padding: The optional padding character used to pad the data.
        public init(characters: [[Character]], padding: Character?) throws {
            guard characters.count == 32 else {
                throw AlphabetError.wrongNumberOfCharacters
            }

            let firstCharacters = try characters.map { characterVariants -> Character in
                guard let firstCharacter = characterVariants.first else {
                    throw AlphabetError.wrongNumberOfCharacters
                }
                return firstCharacter
            }

            if let padding = padding, !padding.isASCII {
                throw AlphabetError.noAsciiValue
            }

            let asciiValues = try characters.map { characterArray -> [UInt8] in
                try characterArray.map { character -> UInt8 in
                    guard let asciiValue = character.asciiValue else {
                        throw AlphabetError.noAsciiValue
                    }
                    return asciiValue
                }
            }

            var values = [UInt8?](repeating: nil, count: 128)
            for (index, asciiValueArray) in asciiValues.enumerated() {
                for asciiValue in asciiValueArray {
                    values[Int(asciiValue)] = UInt8(index)
                }
            }

            self.characters = firstCharacters
            self.values = values
            self.padding = padding
        }
    }

    // MARK: - Encoder

    /// The Base-32 Encoder.
    public struct Encoder: Hashable, Sendable {
        /// The alphabet used to encode data.
        public let alphabet: Alphabet

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

            let padding = data.count.isMultiple(of: 5) ? 0 : 5 - (data.count % 5)
            let padCharacterCount = padding * 8 / 5

            let data = Array(data) + [UInt8](repeating: 0, count: padding)

            var output = ""
            output.reserveCapacity(data.count * 8 / 5)

            for chunk in data.chunks(ofCount: 5) {
                output += [
                    // [0](11111000)
                    // 11111___ ________ ________ ________ ________
                    alphabet.characters[Int(
                        chunk[chunk.startIndex] >> 3
                    )],
                    // [0](00000111) + [1](11000000)
                    // _____111 11______ ________ ________ ________
                    alphabet.characters[Int(
                        ((chunk[chunk.startIndex] & 0b111) << 2) | (chunk[chunk.startIndex + 1] >> 6)
                    )],
                    // [1](00111110)
                    // ________ __11111_ ________ ________ ________
                    alphabet.characters[Int(
                        (chunk[chunk.startIndex + 1] >> 1) & 0b11111
                    )],
                    // [1](00000001) + [2](11110000)
                    // ________ _______1 1111____ ________ ________
                    alphabet.characters[Int(
                        ((chunk[chunk.startIndex + 1] & 0b1) << 4) | (chunk[chunk.startIndex + 2] >> 4)
                    )],
                    // [2](00001111) + [3](10000000)
                    // ________ ________ ____1111 1_______ ________
                    alphabet.characters[Int(
                        (chunk[chunk.startIndex + 2] & 0b1111) << 1 | (chunk[chunk.startIndex + 3] >> 7)
                    )],
                    // [3](01111100)
                    // ________ ________ ________ _11111__ ________
                    alphabet.characters[Int(
                        (chunk[chunk.startIndex + 3] >> 2) & 0b11111
                    )],
                    // [3](00000011) + [4](11100000)
                    // ________ ________ ________ ______11 111_____
                    alphabet.characters[Int(
                        (chunk[chunk.startIndex + 3] & 0b11) << 3 | (chunk[chunk.startIndex + 4] >> 5)
                    )],
                    // [4](00011111)
                    // ________ ________ ________ ________ ___11111
                    alphabet.characters[Int(
                        (chunk[chunk.startIndex + 4] & 0b11111)
                    )]
                ]
            }

            output.removeLast(padCharacterCount)
            if let paddingCharacter = alphabet.padding {
                output += String(repeating: paddingCharacter, count: padCharacterCount)
            }

            return output
        }
    }

    // MARK: - Decoder

    /// The Base-32 Decoder.
    public struct Decoder: Hashable, Sendable {
        /// The alphabet used to decode data.
        public let alphabet: Alphabet

        /// Creates a new decoder.
        /// - Parameter alphabet: The alphabet to use when decoding data.
        public init(alphabet: Alphabet) {
            self.alphabet = alphabet
        }

        /// Decodes a given string.
        /// - Parameter text: The string containing the Base-32 encoded data.
        /// - Returns: The decoded data.
        public func decode(_ text: String) throws -> Data {
            guard !text.isEmpty else {
                return Data()
            }

            // Remove suffix
            var text = text
            if let paddincCharacter = alphabet.padding {
                text = String(text.trimmingSuffix { $0 == paddincCharacter })
            }

            // Calculate pad characters
            let padCharacterCount = text.count.isMultiple(of: 8) ? 0 : 8 - (text.count % 8)

            text += String(repeating: alphabet.characters[0], count: padCharacterCount)

            var data = Data(capacity: text.count * 5 / 8)

            for chunk in text.chunks(ofCount: 8) {
                let characters = try chunk
                    .map { character -> UInt8 in
                        guard let asciiValue = character.asciiValue else {
                            throw BaseDecodingError.nonAsciiCharacters
                        }
                        guard let value = alphabet.values[Int(asciiValue)] else {
                            throw BaseDecodingError.valuesNotInAlphabet
                        }
                        return value
                    }

                data += [
                    // [0](___11111) + [1](___11100)
                    (characters[0] << 3) | (characters[1] >> 2),
                    // [1](___00011) + [2](___11111) + [3](___10000)
                    ((characters[1] & 0b11) << 6) | (characters[2] << 1) | (characters[3] >> 4),
                    // [3](___01111) + [4](___11110)
                    ((characters[3] & 0b1111) << 4) | (characters[4] >> 1),
                    // [4](___00001) + [5](___11111) + [6](___11000)
                    (characters[4] << 7) | (characters[5] << 2) | (characters[6] >> 3),
                    // [6](___00111) + [7](___11111)
                    (characters[6] << 5) | characters[7]
                ]
            }

            if padCharacterCount > 0 {
                data.removeLast((padCharacterCount + 1) * 5 / 8)
            }

            return data
        }
    }
}
