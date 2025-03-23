//
//  Base64Tests.swift
//  Bases
//
//  Created by Przemek Ambroży on 12.06.2022.
//  Copyright © 2022 Przemysław Ambroży
//

@testable import Bases
import Foundation
import Testing

@Suite("Base64")
struct Bases64Tests {
    @Test(arguments: [
        ("", ""),
        ("f", "Zg=="),
        ("fo", "Zm8="),
        ("foo", "Zm9v"),
        ("foob", "Zm9vYg=="),
        ("fooba", "Zm9vYmE="),
        ("foobar", "Zm9vYmFy")
    ])
    func standard(decodedString: String, encoded: String) throws {
        let encoder = Base64.Encoder(alphabet: .standard, pad: true)
        let decoder = Base64.Decoder(alphabet: .standard)

        let decoded = try #require(decodedString.data(using: .utf8))
        #expect(encoder.encode(decoded) == encoded)
        #expect(try decoder.decode(encoded) == decoded)
    }

    @Test
    func mime() throws {
        let encoder = Base64.Encoder(alphabet: .mime, pad: true)
        let decoder = Base64.Decoder(alphabet: .mime)

        let decoded = Data("01234567890123456789012345678901234567890123456789012345678901234567890123456789".utf8)

        let encoded = """
        MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2\r\n\
        Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODk=
        """

        #expect(encoder.encode(decoded) == encoded)
        #expect(try decoder.decode(encoded) == decoded)
    }

    @Test
    func decoding() {
        let decoder = Base64.Decoder(alphabet: .standard)
        #expect(throws: BaseDecodingError.nonAsciiCharacters) {
            try decoder.decode("¡")
        }
        #expect(throws: BaseDecodingError.valuesNotInAlphabet) {
            try decoder.decode("_")
        }
    }

    @Test
    func builtInStandardAlphabet() throws {
        let standard = try Base64.Alphabet(
            characters: [
                "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
                "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f",
                "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
                "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "/"
            ],
            padding: "=",
            lineSeparator: nil
        )
        #expect(standard == Base64.Alphabet.standard)
    }

    @Test
    func builtInBase64urlAlphabet() throws {
        let base64url = try Base64.Alphabet(
            characters: [
                "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
                "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f",
                "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
                "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-", "_"
            ],
            padding: "=",
            lineSeparator: nil
        )
        #expect(base64url == Base64.Alphabet.base64url)
    }

    @Test
    func builtInUtf7Alphabet() throws {
        let utf7 = try Base64.Alphabet(
            characters: [
                "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
                "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f",
                "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
                "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "/"
            ],
            padding: nil,
            lineSeparator: nil
        )
        #expect(utf7 == Base64.Alphabet.utf7)
    }

    @Test
    func builtInImapMailboxNamesAlphabet() throws {
        let imapMailboxNames = try Base64.Alphabet(
            characters: [
                "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
                "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f",
                "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
                "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", ","
            ],
            padding: nil,
            lineSeparator: nil
        )
        #expect(imapMailboxNames == Base64.Alphabet.imapMailboxNames)
    }

    @Test
    func builtInMimeAlphabet() throws {
        let mime = try Base64.Alphabet(
            characters: [
                "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
                "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f",
                "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
                "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "/"
            ],
            padding: "=",
            lineSeparator: try LineSeparator(separator: "\r\n", length: 76)
        )
        #expect(mime == Base64.Alphabet.mime)

        let mimeFunction = try Base64.Alphabet.mime(lineLength: 76)
        #expect(mimeFunction == Base64.Alphabet.mime)
    }

    @Test
    func alphabet() {
        #expect(throws: AlphabetError.wrongNumberOfCharacters) {
            try Base64.Alphabet(characters: [], padding: nil, lineSeparator: nil)
        }

        let notEmpty = [Character](repeating: "¡", count: 64)
        #expect(throws: AlphabetError.noAsciiValue) {
            try Base64.Alphabet(characters: notEmpty, padding: "¡", lineSeparator: nil)
        }
        #expect(throws: AlphabetError.noAsciiValue) {
            try Base64.Alphabet(characters: notEmpty, padding: nil, lineSeparator: nil)
        }
    }
}
