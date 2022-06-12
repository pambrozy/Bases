//
//  Base64.swift
//  Bases
//
//  Created by Przemek Ambroży on 08.05.2022.
//  Copyright © 2022 Przemysław Ambroży
//

import Foundation

/// The Base-64 encoding.
public enum Base64 {

    // MARK: - Alphabet

    /// An alphabet definig a set of characters used for the Base-64 encoding.
    public struct Alphabet: Equatable {
        /// The ordered array mapping the 64 values to ASCII character codes.
        public let characters: [Character]

        /// The ordered array mapping the 128 ASCII character codes to values.
        public let values: [UInt8?]

        /// The optional padding character used to pad the data.
        public let padding: Character?

        /// The optional line separator used when the encoded text exceeds a given length.
        public let lineSeparator: LineSeparator?

        init(
            uncheckedCharacters: [Character],
            uncheckedValues: [UInt8?],
            padding: Character?,
            lineSeparator: LineSeparator?
        ) {
            self.characters = uncheckedCharacters
            self.values = uncheckedValues
            self.padding = padding
            self.lineSeparator = lineSeparator
        }

        /// Creates a new alphabet.

        /// - Parameters:
        ///   - characters: An array of 64 ASCII characters.
        ///   - padding: The optional padding character used to pad the data.
        ///   - lineSeparator: The optional line separator used when the encoded text exceeds a given length.
        public init(characters: [Character], padding: Character?, lineSeparator: LineSeparator?) throws {
            guard characters.count == 64 else {
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
            self.padding = padding
            self.lineSeparator = lineSeparator
        }
    }

    // MARK: - Encoder

    /// The Base-64 Encoder.
    public struct Encoder {
        /// The alphabet used to encode data.
        public let alphabet: Alphabet

        /// Whether to pad the data if the alphabet includes the padding character.
        public let pad: Bool

        /// Creates a new encoder.
        /// - Parameters:
        ///   - alphabet: The alphabet to use when encoding data.
        ///   - pad: Whether to pad the data if the alphabet includes the padding character.
        public init(alphabet: Alphabet, pad: Bool = true) {
            self.alphabet = alphabet
            self.pad = pad
        }

        /// Encodes the given data.
        /// - Parameter data: The data to encode.
        /// - Returns: A string containing the Base-64 encoded data.
        public func encode<T: DataProtocol>(_ data: T) -> String {
            guard !data.isEmpty else {
                return ""
            }

            let padding = data.count.isMultiple(of: 3) ? 0 : 3 - (data.count % 3)
            let padCharacterCount = padding * 4 / 3

            let data = Array(data) + [UInt8](repeating: 0, count: padding)

            var output = ""
            output.reserveCapacity(data.count * 4 / 3)

            for chunk in data.chunks(ofCount: 3) {
                output += [
                    // [0](11111100)
                    alphabet.characters[Int(
                        chunk[chunk.startIndex] >> 2
                    )],
                    // [0](00000011) + [1](11110000)
                    alphabet.characters[Int(
                        ((chunk[chunk.startIndex] & 0b11) << 4) | (chunk[chunk.startIndex + 1] >> 4)
                    )],
                    // [1](00001111) + [2](11000000)
                    alphabet.characters[Int(
                        ((chunk[chunk.startIndex + 1] & 0b1111) << 2) | (chunk[chunk.startIndex + 2] >> 6)
                    )],
                    // [3](00111111)
                    alphabet.characters[Int(
                        (chunk[chunk.startIndex + 2] & 0b111111)
                    )]
                ]
            }

            output.removeLast(padCharacterCount)
            if pad, let paddingCharacter = alphabet.padding {
                output += String(repeating: paddingCharacter, count: padCharacterCount)
            }

            if let lineSeparator = alphabet.lineSeparator {
                output = output
                    .chunks(ofCount: lineSeparator.length)
                    .joined(separator: lineSeparator.separator)
            }

            return output
        }
    }

    // MARK: - Decoder

    /// The Base-64 Decoder.
    public struct Decoder {
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
            var text = text

            // Remove line separators
            if let lineSeparator = alphabet.lineSeparator {
                text = text.replacingOccurrences(of: lineSeparator.separator, with: "")
            }

            // Remove suffix
            if let paddincCharacter = alphabet.padding {
                text = String(text.trimmingSuffix { $0 == paddincCharacter })
            }

            // Calculate pad characters
            let padCharacterCount = text.count.isMultiple(of: 4) ? 0 : 4 - (text.count % 4)

            text += String(repeating: alphabet.characters[0], count: padCharacterCount)

            var data = Data(capacity: text.count * 3 / 4)

            for chunk in text.chunks(ofCount: 4) {
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
                    // [0](__111111) + [1](__110000)
                    (characters[0] << 2) | (characters[1] >> 4),
                    // [1](__001111) + [2](__111100)
                    ((characters[1] & 0b1111) << 4) | (characters[2] >> 2),
                    // [2](__000011) + [3](__111111)
                    ((characters[2] & 0b11) << 6) | characters[3]
                ]
            }

            if padCharacterCount > 0 {
                data.removeLast((padCharacterCount + 1) * 3 / 4)
            }

            return data
        }
    }
}
