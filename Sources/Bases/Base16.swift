//
//  Base16.swift
//  Bases
//
//  Created by Przemek Ambroży on 06.05.2022.
//  Copyright © 2022 Przemysław Ambroży
//

import Foundation

/// The Base-16 encoding.
public enum Base16 {

    // MARK: - Alphabet

    /// An alphabet defining a set of characters used for the Base-16 encoding.
    public struct Alphabet: Hashable, Sendable {
        /// The ordered array mapping the 16 values to ASCII character codes.
        public let characters: [Character]

        /// The ordered array mapping the 128 ASCII character codes to values.
        public let values: [UInt8?]

        init(uncheckedCharacters: [Character], uncheckedValues: [UInt8?]) {
            self.characters = uncheckedCharacters
            self.values = uncheckedValues
        }

        /// Creates a new alphabet.
        /// - Parameter characters: An array of 16 ASCII characters.
        public init(characters: [Character]) throws {
            guard characters.count == 16 else {
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
        }
    }

    // MARK: - Encoder

    /// The Base-16 Encoder.
    public struct Encoder: Hashable, Sendable {
        /// The alphabet used to encode data.
        public let alphabet: Alphabet

        /// Creates a new encoder.
        /// - Parameter alphabet: The alphabet to use when encoding data.
        public init(alphabet: Alphabet = .uppercase) {
            self.alphabet = alphabet
        }

        /// Encodes the given data.
        /// - Parameter data: The data to encode.
        /// - Returns: A string containing the Base-16 encoded data.
        public func encode<T: DataProtocol>(_ data: T) -> String {
            var output = ""
            output.reserveCapacity(data.count * 2)

            for datum in data {
                output.append(alphabet.characters[Int((datum >> 4) & 0xF)])
                output.append(alphabet.characters[Int(datum & 0xF)])
            }

            return output
        }
    }

    // MARK: - Decoder

    /// The Base-16 Decoder.
    public struct Decoder: Hashable, Sendable {
        /// Whether to ignore characters not found in the alphabet.
        public let ignoreUnknownCharacters: Bool

        /// The alphabet used to decode data.
        public let alphabet: Alphabet

        /// Creates a new decoder.
        /// - Parameters:
        ///   - ignoreUnknownCharacters: Whether to ignore characters not found in the alphabet.
        ///   - alphabet: The alphabet to use when decoding data.
        public init(ignoreUnknownCharacters: Bool, alphabet: Alphabet) {
            self.ignoreUnknownCharacters = ignoreUnknownCharacters
            self.alphabet = alphabet
        }

        /// Decodes a given string.
        /// - Parameter text: The string containing the Base-16 encoded data.
        /// - Returns: The decoded data.
        public func decode(_ text: String) throws -> Data {
            var text = text
            if ignoreUnknownCharacters {
                text = text.filter { alphabet.characters.contains($0) }
            } else if text.contains(where: { !alphabet.characters.contains($0) }) {
                throw BaseDecodingError.valuesNotInAlphabet
            }

            guard text.count % 2 == 0 else {
                throw BaseDecodingError.wrongNumberOfBytes
            }

            let data = try text
                .chunks(ofCount: 2)
                .map { chunk -> UInt8 in
                    guard let upperAscii = chunk.first?.asciiValue,
                          let lowerAscii = chunk.last?.asciiValue else {
                        throw BaseDecodingError.nonAsciiCharacters
                    }
                    guard let upper = alphabet.values[Int(upperAscii)],
                          let lower = alphabet.values[Int(lowerAscii)] else {
                        throw BaseDecodingError.valuesNotInAlphabet
                    }
                    return upper << 4 | (lower & 0xF)
                }

            return Data(data)
        }
    }
}
