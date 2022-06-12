//
//  Base64.swift
//  Bases
//
//  Created by Przemek Ambroży on 08.05.2022.
//  Copyright © 2022 Przemysław Ambroży
//

import Foundation

public enum Base64 {

    // MARK: - Alphabet

    public struct Alphabet: Equatable {
        public let characters: [Character]
        public let values: [UInt8?]
        public let padding: Character?
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

    public struct Encoder {
        let alphabet: Alphabet
        let pad: Bool

        /// <#Description#>
        /// - Parameters:
        ///   - alphabet: <#alphabet description#>
        ///   - pad: Whether to pad the data if the alphabet includes the padding character.
        public init(alphabet: Alphabet, pad: Bool = true) {
            self.alphabet = alphabet
            self.pad = pad
        }

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

    public struct Decoder {
        public let alphabet: Alphabet

        public init(alphabet: Alphabet) {
            self.alphabet = alphabet
        }

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
                            throw DecodingError.nonAsciiCharacters
                        }
                        guard let value = alphabet.values[Int(asciiValue)] else {
                            throw DecodingError.valuesNotInAlphabet
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
