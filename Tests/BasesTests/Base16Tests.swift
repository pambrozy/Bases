//
//  Base16Tests.swift
//  Bases
//
//  Created by Przemek Ambroży on 12.06.2022.
//  Copyright © 2022 Przemysław Ambroży
//

@testable import Bases
import XCTest

struct StringEncodingError: Error { }

final class Bases16Tests: XCTestCase {
    func testUppercase() throws {
        let encoder = Base16.Encoder(alphabet: .uppercase)
        let decoder = Base16.Decoder(ignoreUnknownCharacters: false, alphabet: .uppercase)
        let ignoringDecoder = Base16.Decoder(ignoreUnknownCharacters: true, alphabet: .uppercase)

        let data = [
            ("", ""),
            ("f", "66"),
            ("fo", "666F"),
            ("foo", "666F6F"),
            ("foob", "666F6F62"),
            ("fooba", "666F6F6261"),
            ("foobar", "666F6F626172")
        ]

        for (decodedString, encoded) in data {
            guard let decoded = decodedString.data(using: .utf8) else {
                throw StringEncodingError()
            }
            XCTAssertEqual(encoder.encode(decoded), encoded)
            XCTAssertEqual(try decoder.decode(encoded), decoded)
            XCTAssertEqual(try ignoringDecoder.decode("_" + encoded + "_"), decoded)
        }
    }

    func testLowercase() throws {
        let encoder = Base16.Encoder(alphabet: .lowercase)
        let decoder = Base16.Decoder(ignoreUnknownCharacters: false, alphabet: .lowercase)
        let ignoringDecoder = Base16.Decoder(ignoreUnknownCharacters: true, alphabet: .lowercase)

        let data = [
            ("", ""),
            ("f", "66"),
            ("fo", "666f"),
            ("foo", "666f6f"),
            ("foob", "666f6f62"),
            ("fooba", "666f6f6261"),
            ("foobar", "666f6f626172")
        ]

        for (decodedString, encoded) in data {
            guard let decoded = decodedString.data(using: .utf8) else {
                throw StringEncodingError()
            }
            XCTAssertEqual(encoder.encode(decoded), encoded)
            XCTAssertEqual(try decoder.decode(encoded), decoded)
            XCTAssertEqual(try ignoringDecoder.decode("_" + encoded + "_"), decoded)
        }
    }

    func testDecoding() {
        var decoder = Base16.Decoder(ignoreUnknownCharacters: false, alphabet: .lowercase)
        XCTAssertThrowsError(try decoder.decode("000z")) { error in
            XCTAssertEqual(error as? DecodingError, DecodingError.containsUnknownCharacters)
        }
        XCTAssertThrowsError(try decoder.decode("000")) { error in
            XCTAssertEqual(error as? DecodingError, DecodingError.wrongNumberOfBytes)
        }
        XCTAssertThrowsError(try decoder.decode("000")) { error in
            XCTAssertEqual(error as? DecodingError, DecodingError.wrongNumberOfBytes)
        }

        let invalidAlphabet = Base16.Alphabet(
            uncheckedCharacters: ["0", "1", "¡"],
            uncheckedValues: [UInt8?](repeating: nil, count: 128)
        )
        decoder = Base16.Decoder(ignoreUnknownCharacters: false, alphabet: invalidAlphabet)

        XCTAssertThrowsError(try decoder.decode("0¡")) { error in
            XCTAssertEqual(error as? DecodingError, DecodingError.nonAsciiCharacters)
        }
        XCTAssertThrowsError(try decoder.decode("00")) { error in
            XCTAssertEqual(error as? DecodingError, DecodingError.valuesNotInAlphabet)
        }
    }

    func testBuiltInAlphabets() throws {
        let uppercase = try Base16.Alphabet(characters: Base16.Alphabet.uppercase.characters)
        XCTAssertEqual(uppercase.characters, Base16.Alphabet.uppercase.characters)
        XCTAssertEqual(uppercase.values, Base16.Alphabet.uppercase.values)

        let lowercase = try Base16.Alphabet(characters: Base16.Alphabet.lowercase.characters)
        XCTAssertEqual(lowercase.characters, Base16.Alphabet.lowercase.characters)
        XCTAssertEqual(lowercase.values, Base16.Alphabet.lowercase.values)
    }

    func testAlphabet() {
        XCTAssertThrowsError(try Base16.Alphabet(characters: [])) { error in
            XCTAssertEqual(error as? AlphabetError, AlphabetError.wrongNumberOfCharacters)
        }
        let nonAscii: [Character] = [
            "¡", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"
        ]
        XCTAssertThrowsError(try Base16.Alphabet(characters: nonAscii)) { error in
            XCTAssertEqual(error as? AlphabetError, AlphabetError.noAsciiValue)
        }
    }
}
