import XCTest
@testable import Bases

final class Bases64Tests: XCTestCase {
    func testStandard() throws {
        let encoder = Base64.Encoder(alphabet: .standard, pad: true)
        let decoder = Base64.Decoder(alphabet: .standard)

        let data = [
            ("", ""),
            ("f", "Zg=="),
            ("fo", "Zm8="),
            ("foo", "Zm9v"),
            ("foob", "Zm9vYg=="),
            ("fooba", "Zm9vYmE="),
            ("foobar", "Zm9vYmFy"),
        ]

        for (decodedString, encoded) in data {
            guard let decoded = decodedString.data(using: .utf8) else {
                throw StringEncodingError()
            }
            XCTAssertEqual(encoder.encode(decoded), encoded)
            XCTAssertEqual(try decoder.decode(encoded), decoded)
        }
    }

    func testMime() throws {
        let encoder = Base64.Encoder(alphabet: .mime, pad: true)
        let decoder = Base64.Decoder(alphabet: .mime)

        guard let decoded = "01234567890123456789012345678901234567890123456789012345678901234567890123456789"
            .data(using: .utf8)
        else {
            throw StringEncodingError()
        }

        let encoded = """
        MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2\r\n\
        Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODk=
        """

        XCTAssertEqual(encoder.encode(decoded), encoded)
        XCTAssertEqual(try decoder.decode(encoded), decoded)
    }

    func testDecoding() {
        let decoder = Base64.Decoder(alphabet: .standard)
        XCTAssertThrowsError(try decoder.decode("¡")) { error in
            XCTAssertEqual(error as? DecodingError, DecodingError.nonAsciiCharacters)
        }
        XCTAssertThrowsError(try decoder.decode("_")) { error in
            XCTAssertEqual(error as? DecodingError, DecodingError.valuesNotInAlphabet)
        }

    }

    func testBuiltInAlphabets() throws {
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
        XCTAssertEqual(standard, Base64.Alphabet.standard)

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
        XCTAssertEqual(base64url, Base64.Alphabet.base64url)

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
        XCTAssertEqual(utf7, Base64.Alphabet.utf7)

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
        XCTAssertEqual(imapMailboxNames, Base64.Alphabet.imapMailboxNames)

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
        XCTAssertEqual(mime, Base64.Alphabet.mime)

        let mimeFunction = try Base64.Alphabet.mime(lineLength: 76)
        XCTAssertEqual(mimeFunction, Base64.Alphabet.mime)
    }

    func testAlphabet() {
        XCTAssertThrowsError(
            try Base64.Alphabet(characters: [], padding: nil, lineSeparator: nil)
        ) { error in
            XCTAssertEqual(error as? AlphabetError, AlphabetError.wrongNumberOfCharacters)
        }

        let notEmpty = [Character](repeating: "¡", count: 64)
        XCTAssertThrowsError(
            try Base64.Alphabet(characters: notEmpty, padding: "¡", lineSeparator: nil)
        ) { error in
            XCTAssertEqual(error as? AlphabetError, AlphabetError.noAsciiValue)
        }
        XCTAssertThrowsError(
            try Base64.Alphabet(characters: notEmpty, padding: nil, lineSeparator: nil)
        ) { error in
            XCTAssertEqual(error as? AlphabetError, AlphabetError.noAsciiValue)
        }
    }
}
