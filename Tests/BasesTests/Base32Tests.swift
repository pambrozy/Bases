//
//  Base32Tests.swift
//  Bases
//
//  Created by Przemek Ambroży on 12.06.2022.
//  Copyright © 2022 Przemysław Ambroży
//

@testable import Bases
import Testing

@Suite("Base32")
struct Bases32Tests {
    @Test(arguments: [
        ("", ""),
        ("f", "MY======"),
        ("fo", "MZXQ===="),
        ("foo", "MZXW6==="),
        ("foob", "MZXW6YQ="),
        ("fooba", "MZXW6YTB"),
        ("foobar", "MZXW6YTBOI======")
    ])
    func rfc(decodedString: String, encoded: String) throws {
        let encoder = Base32.Encoder(alphabet: .rfc4648)
        let decoder = Base32.Decoder(alphabet: .rfc4648)

        let decoded = try #require(decodedString.data(using: .utf8))
        #expect(encoder.encode(decoded) == encoded)
        #expect(try decoder.decode(encoded) == decoded)
    }

    @Test(arguments: [
        ("", ""),
        ("f", "CO======"),
        ("fo", "CPNG===="),
        ("foo", "CPNMU==="),
        ("foob", "CPNMUOG="),
        ("fooba", "CPNMUOJ1"),
        ("foobar", "CPNMUOJ1E8======")
    ])
    func hex(decodedString: String, encoded: String) throws {
        let encoder = Base32.Encoder(alphabet: .base32hex)
        let decoder = Base32.Decoder(alphabet: .base32hex)

        let decoded = try #require(decodedString.data(using: .utf8))
        #expect(encoder.encode(decoded) == encoded)
        #expect(try decoder.decode(encoded) == decoded)
    }

    @Test
    func decoding() {
        let decoder = Base32.Decoder(alphabet: .rfc4648)
        #expect(throws: BaseDecodingError.nonAsciiCharacters) {
            try decoder.decode("¡")
        }
        #expect(throws: BaseDecodingError.valuesNotInAlphabet) {
            try decoder.decode("_")
        }
    }

    @Test
    func builtInRfc4648Alphabet() throws {
        let rfc4648 = try Base32.Alphabet(
            characters: [
                ["A", "a"], ["B", "b"], ["C", "c"], ["D", "d"], ["E", "e"], ["F", "f"], ["G", "g"], ["H", "h"],
                ["I", "i"], ["J", "j"], ["K", "k"], ["L", "l"], ["M", "m"], ["N", "n"], ["O", "o"], ["P", "p"],
                ["Q", "q"], ["R", "r"], ["S", "s"], ["T", "t"], ["U", "u"], ["V", "v"], ["W", "w"], ["X", "x"],
                ["Y", "y"], ["Z", "z"], ["2", "2"], ["3", "3"], ["4", "4"], ["5", "5"], ["6", "6"], ["7", "7"]
            ],
            padding: "="
        )
        #expect(rfc4648 == Base32.Alphabet.rfc4648)
    }

    @Test
    func builtInZBase32Alphabet() throws {
        let zBase32 = try Base32.Alphabet(
            characters: [
                ["y", "Y"], ["b", "B"], ["n", "N"], ["d", "D"], ["r", "R"], ["f", "F"], ["g", "G"], ["8", "8"],
                ["e", "E"], ["j", "J"], ["k", "K"], ["m", "M"], ["c", "C"], ["p", "P"], ["q", "Q"], ["x", "X"],
                ["o", "O"], ["t", "T"], ["1", "1"], ["u", "U"], ["w", "W"], ["i", "I"], ["s", "S"], ["z", "Z"],
                ["a", "A"], ["3", "3"], ["4", "4"], ["5", "5"], ["h", "H"], ["7", "7"], ["6", "6"], ["9", "9"]
            ],
            padding: nil
        )
        #expect(zBase32 == Base32.Alphabet.zBase32)
    }

    @Test
    func builtInCrockfordAlphabet() throws {
        let crockford = try Base32.Alphabet(
            characters: [
                ["0", "o", "O"],
                ["1", "i", "I", "l", "L"],
                ["2", "2"],
                ["3", "3"],
                ["4", "4"],
                ["5", "5"],
                ["6", "6"],
                ["7", "7"],
                ["8", "8"], ["9", "9"], ["A", "a"], ["B", "b"], ["C", "c"], ["D", "d"], ["E", "e"], ["F", "f"],
                ["G", "g"], ["H", "h"], ["J", "j"], ["K", "k"], ["M", "m"], ["N", "n"], ["P", "p"], ["Q", "q"],
                ["R", "r"], ["S", "s"], ["T", "t"], ["V", "v"], ["W", "w"], ["X", "x"], ["Y", "y"], ["Z", "z"]
            ],
            padding: nil
        )
        #expect(crockford == Base32.Alphabet.crockford)
    }

    @Test
    func builtInBase32HexAlphabet() throws {
        let base32hex = try Base32.Alphabet(
            characters: [
                ["0", "0"], ["1", "1"], ["2", "2"], ["3", "3"], ["4", "4"], ["5", "5"], ["6", "6"], ["7", "7"],
                ["8", "8"], ["9", "9"], ["A", "a"], ["B", "b"], ["C", "c"], ["D", "d"], ["E", "e"], ["F", "f"],
                ["G", "g"], ["H", "h"], ["I", "i"], ["J", "j"], ["K", "k"], ["L", "l"], ["M", "m"], ["N", "n"],
                ["O", "o"], ["P", "p"], ["Q", "q"], ["R", "r"], ["S", "s"], ["T", "t"], ["U", "u"], ["V", "v"]
            ],
            padding: "="
        )
        #expect(base32hex == Base32.Alphabet.base32hex)
    }

    @Test
    func builtInGeohashAlphabet() throws {
        let geohash = try Base32.Alphabet(
            characters: [
                ["0", "0"], ["1", "1"], ["2", "2"], ["3", "3"], ["4", "4"], ["5", "5"], ["6", "6"], ["7", "7"],
                ["8", "8"], ["9", "9"], ["b", "B"], ["c", "C"], ["d", "D"], ["e", "E"], ["f", "F"], ["g", "G"],
                ["h", "H"], ["j", "J"], ["k", "K"], ["m", "M"], ["n", "N"], ["p", "P"], ["q", "Q"], ["r", "R"],
                ["s", "S"], ["t", "T"], ["u", "U"], ["v", "V"], ["w", "W"], ["x", "X"], ["y", "Y"], ["z", "Z"]
            ],
            padding: nil
        )
        #expect(geohash == Base32.Alphabet.geohash)
    }

    @Test
    func builtInWordSafeAlphabet() throws {
        let wordSafe = try Base32.Alphabet(
            characters: [
                ["2"], ["3"], ["4"], ["5"], ["6"], ["7"], ["8"], ["9"],
                ["C"], ["F"], ["G"], ["H"], ["J"], ["M"], ["P"], ["Q"],
                ["R"], ["V"], ["W"], ["X"], ["c"], ["f"], ["g"], ["h"],
                ["j"], ["m"], ["p"], ["q"], ["r"], ["v"], ["w"], ["x"]
            ],
            padding: nil
        )
        #expect(wordSafe == Base32.Alphabet.wordSafe)
    }

    @Test
    func alphabet() {
        #expect(throws: AlphabetError.wrongNumberOfCharacters) {
            try Base32.Alphabet(characters: [], padding: nil)
        }

        let empty = [[Character]](repeating: [], count: 32)
        #expect(throws: AlphabetError.wrongNumberOfCharacters) {
            try Base32.Alphabet(characters: empty, padding: nil)
        }

        let notEmpty = [[Character]](repeating: ["¡"], count: 32)
        #expect(throws: AlphabetError.noAsciiValue) {
            try Base32.Alphabet(characters: notEmpty, padding: "¡")
        }
        #expect(throws: AlphabetError.noAsciiValue) {
            try Base32.Alphabet(characters: notEmpty, padding: nil)
        }
    }
}
