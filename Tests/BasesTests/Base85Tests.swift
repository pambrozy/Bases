import XCTest
@testable import Bases

final class Bases85Tests: XCTestCase {

    // MARK: Built-in alphabets

    func testBuiltInAsciiAlphabet() throws {
        let ascii = try Base85.Alphabet(
            characters: [
                "!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", "0",
                "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?", "@",
                "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
                "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "\\", "]", "^", "_", "`",
                "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p",
                "q", "r", "s", "t", "u"
            ],
            startDelimeter: nil,
            endDelimeter: nil,
            fourZeros: nil,
            fourSpaces: nil
        )
        XCTAssertEqual(ascii, Base85.Alphabet.ascii)
    }

    func testBuiltInBtoaLikeAlphabet() throws {
        let btoaLike = try Base85.Alphabet(
            characters: [
                "!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", "0",
                "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?", "@",
                "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
                "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "\\", "]", "^", "_", "`",
                "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p",
                "q", "r", "s", "t", "u"
            ],
            startDelimeter: nil,
            endDelimeter: nil,
            fourZeros: "z",
            fourSpaces: "y"
        )
        XCTAssertEqual(btoaLike, Base85.Alphabet.btoaLike)
    }

    func testBuiltInAdobeAscii85Alphabet() throws {
        let adobeAscii85 = try Base85.Alphabet(
            characters: [
                "!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", "0",
                "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?", "@",
                "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
                "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "\\", "]", "^", "_", "`",
                "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p",
                "q", "r", "s", "t", "u"
            ],
            startDelimeter: "<~",
            endDelimeter: "~>",
            fourZeros: "z",
            fourSpaces: nil
        )
        XCTAssertEqual(adobeAscii85, Base85.Alphabet.adobeAscii85)
    }

    func testBuiltInRfc1924Alphabet() throws {
        let rfc1924 = try Base85.Alphabet(
            characters: [
                "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F",
                "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V",
                "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l",
                "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "!", "#",
                "$", "%", "&", "(", ")", "*", "+", "-", ";", "<", "=", ">", "?", "@", "^", "_",
                "`", "{", "|", "}", "~"
            ],
            startDelimeter: nil,
            endDelimeter: nil,
            fourZeros: nil,
            fourSpaces: nil
        )
        XCTAssertEqual(rfc1924, Base85.Alphabet.rfc1924)
    }

    func testBuiltInZ85Alphabet() throws {
        let z85 = try Base85.Alphabet(
            characters: [
                "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f",
                "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
                "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
                "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", ".", "-",
                ":", "+", "=", "^", "!", "/", "*", "?", "&", "<", ">", "(", ")", "[", "]", "{",
                "}", "@", "%", "$", "#"
            ],
            startDelimeter: nil,
            endDelimeter: nil,
            fourZeros: nil,
            fourSpaces: nil
        )
        XCTAssertEqual(z85, Base85.Alphabet.z85)
    }

    // MARK: Examples

    // TODO: Test remaining examples

    func testBtoaLike() throws {
        let encoder = Base85.Encoder(alphabet: .btoaLike, pad: false)
        let decoder = Base85.Decoder(alphabet: .btoaLike)

        let testData = Data([
            0x41, 0x42, 0x43, 0x44, 0x20, 0x20, 0x20, 0x20,
            0x45, 0x46, 0x47, 0x48, 0x49, 0x4A
        ])

        XCTAssertEqual(encoder.encode(testData), "5sdq,y77Kd<8P/")
        XCTAssertEqual(try decoder.decode("5sdq,y77Kd<8P/"), testData)

        // TODO: Test zeros
    }

    func testZ85() throws {
        let encoder = Base85.Encoder(alphabet: .z85, pad: false)
        let decoder = Base85.Decoder(alphabet: .z85)

        let testData1 = Data([0x86, 0x4F, 0xD2, 0x6F, 0xB5, 0x59, 0xF7, 0x5B])
        XCTAssertEqual(encoder.encode(testData1), "HelloWorld")
        XCTAssertEqual(try decoder.decode("HelloWorld"), testData1)

        let testData2 = Data([
            0x8E, 0x0B, 0xDD, 0x69, 0x76, 0x28, 0xB9, 0x1D,
            0x8F, 0x24, 0x55, 0x87, 0xEE, 0x95, 0xC5, 0xB0,
            0x4D, 0x48, 0x96, 0x3F, 0x79, 0x25, 0x98, 0x77,
            0xB4, 0x9C, 0xD9, 0x06, 0x3A, 0xEA, 0xD3, 0xB7
        ])
        XCTAssertEqual(encoder.encode(testData2), "JTKVSB%%)wK0E.X)V>+}o?pNmC{O&4W4b!Ni{Lh6")
        XCTAssertEqual(try decoder.decode("JTKVSB%%)wK0E.X)V>+}o?pNmC{O&4W4b!Ni{Lh6"), testData2)
    }
}
