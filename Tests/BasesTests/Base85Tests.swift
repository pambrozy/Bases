import XCTest
@testable import Bases

final class Bases85Tests: XCTestCase {
    func testBuiltInAlphabets() throws {
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
}
