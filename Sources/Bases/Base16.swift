//
//  Base16.swift
//  Bases
//
//  Created by Przemek Ambroży on 06.05.2022.
//  Copyright © 2022 Przemysław Ambroży
//

import Foundation

public enum Base16 {

    // MARK: - Alphabet

    public struct Alphabet {
        public let characters: [Character]
        public let values: [UInt8?]

        init(uncheckedCharacters: [Character], uncheckedValues: [UInt8?]) {
            self.characters = uncheckedCharacters
            self.values = uncheckedValues
        }

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

    public struct Encoder {
        public let alphabet: Alphabet

        public init(alphabet: Alphabet = .uppercase) {
            self.alphabet = alphabet
        }

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

    public struct Decoder {
        public let ignoreUnknownCharacters: Bool
        public let alphabet: Alphabet

        public init(ignoreUnknownCharacters: Bool, alphabet: Alphabet) {
            self.ignoreUnknownCharacters = ignoreUnknownCharacters
            self.alphabet = alphabet
        }

        public func decode(_ text: String) throws -> Data {
            var text = text
            if ignoreUnknownCharacters {
                text = text.filter { alphabet.characters.contains($0) }
            } else if text.contains(where: { !alphabet.characters.contains($0) }) {
                throw DecodingError.containsUnknownCharacters
            }

            guard text.count % 2 == 0 else {
                throw DecodingError.wrongNumberOfBytes
            }

            let data = try text
                .chunks(ofCount: 2)
                .map { chunk -> UInt8 in
                    guard let upperAscii = chunk.first?.asciiValue,
                          let lowerAscii = chunk.last?.asciiValue else {
                        throw DecodingError.nonAsciiCharacters
                    }
                    guard let upper = alphabet.values[Int(upperAscii)],
                          let lower = alphabet.values[Int(lowerAscii)] else {
                        throw DecodingError.valuesNotInAlphabet
                    }
                    return upper << 4 | (lower & 0xF)
                }

            return Data(data)
        }
    }
}
