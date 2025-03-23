//
//  Base16Tests.swift
//  Bases
//
//  Created by Przemek Ambroży on 12.06.2022.
//  Copyright © 2022 Przemysław Ambroży
//

@testable import Bases
import Testing

@Suite("Base16")
struct Bases16Tests {
    @Test(arguments: [
        ("", ""),
        ("f", "66"),
        ("fo", "666F"),
        ("foo", "666F6F"),
        ("foob", "666F6F62"),
        ("fooba", "666F6F6261"),
        ("foobar", "666F6F626172")
    ])
    func uppercase(decodedString: String, encoded: String) throws {
        let encoder = Base16.Encoder(alphabet: .uppercase)
        let decoder = Base16.Decoder(ignoreUnknownCharacters: false, alphabet: .uppercase)
        let ignoringDecoder = Base16.Decoder(ignoreUnknownCharacters: true, alphabet: .uppercase)

        let decoded = try #require(decodedString.data(using: .utf8))
        #expect(encoder.encode(decoded) == encoded)
        #expect(try decoder.decode(encoded) == decoded)
        #expect(try ignoringDecoder.decode("_" + encoded + "_") == decoded)
    }

    @Test(arguments: [
        ("", ""),
        ("f", "66"),
        ("fo", "666f"),
        ("foo", "666f6f"),
        ("foob", "666f6f62"),
        ("fooba", "666f6f6261"),
        ("foobar", "666f6f626172")
    ])
    func lowercase(decodedString: String, encoded: String) throws {
        let encoder = Base16.Encoder(alphabet: .lowercase)
        let decoder = Base16.Decoder(ignoreUnknownCharacters: false, alphabet: .lowercase)
        let ignoringDecoder = Base16.Decoder(ignoreUnknownCharacters: true, alphabet: .lowercase)

        let decoded = try #require(decodedString.data(using: .utf8))
        #expect(encoder.encode(decoded) == encoded)
        #expect(try decoder.decode(encoded) == decoded)
        #expect(try ignoringDecoder.decode("_" + encoded + "_") == decoded)
    }

    @Test
    func decoding() {
        var decoder = Base16.Decoder(ignoreUnknownCharacters: false, alphabet: .lowercase)
        #expect(throws: BaseDecodingError.valuesNotInAlphabet) {
            try decoder.decode("000z")
        }
        #expect(throws: BaseDecodingError.wrongNumberOfBytes) {
            try decoder.decode("000")
        }

        let invalidAlphabet = Base16.Alphabet(
            uncheckedCharacters: ["0", "1", "¡"],
            uncheckedValues: [UInt8?](repeating: nil, count: 128)
        )
        decoder = Base16.Decoder(ignoreUnknownCharacters: false, alphabet: invalidAlphabet)

        #expect(throws: BaseDecodingError.nonAsciiCharacters) {
            try decoder.decode("0¡")
        }
        #expect(throws: BaseDecodingError.valuesNotInAlphabet) {
            try decoder.decode("00")
        }
    }

    @Test
    func builtInAlphabets() throws {
        let uppercase = try Base16.Alphabet(characters: Base16.Alphabet.uppercase.characters)
        #expect(uppercase.characters == Base16.Alphabet.uppercase.characters)
        #expect(uppercase.values == Base16.Alphabet.uppercase.values)

        let lowercase = try Base16.Alphabet(characters: Base16.Alphabet.lowercase.characters)
        #expect(lowercase.characters == Base16.Alphabet.lowercase.characters)
        #expect(lowercase.values == Base16.Alphabet.lowercase.values)
    }

    @Test
    func alphabet() {
        #expect(throws: AlphabetError.wrongNumberOfCharacters) {
            try Base16.Alphabet(characters: [])
        }
        let nonAscii: [Character] = [
            "¡", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"
        ]
        #expect(throws: AlphabetError.noAsciiValue) {
            try Base16.Alphabet(characters: nonAscii)
        }
    }
}
