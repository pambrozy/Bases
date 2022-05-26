import XCTest
@testable import Bases

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
            ("foobar", "666F6F626172"),
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
            ("foobar", "666f6f626172"),
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

    func testBuiltInAlphabets() throws {
        let uppercase = try Base16.Alphabet(characters: Base16.Alphabet.uppercase.characters)
        XCTAssertEqual(uppercase.characters, Base16.Alphabet.uppercase.characters)
        XCTAssertEqual(uppercase.values, Base16.Alphabet.uppercase.values)

        let lowercase = try Base16.Alphabet(characters: Base16.Alphabet.lowercase.characters)
        XCTAssertEqual(lowercase.characters, Base16.Alphabet.lowercase.characters)
        XCTAssertEqual(lowercase.values, Base16.Alphabet.lowercase.values)
    }

    func testAlphabets() {
        // TODO:
    }
}
