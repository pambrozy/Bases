import XCTest
@testable import Bases

final class Bases32Tests: XCTestCase {

    func testBuiltInAlphabets() throws {
        let rfc4648 = try Base32.Alphabet(
            characters: [
                ["A", "a"], ["B", "b"], ["C", "c"], ["D", "d"], ["E", "e"], ["F", "f"], ["G", "g"], ["H", "h"],
                ["I", "i"], ["J", "j"], ["K", "k"], ["L", "l"], ["M", "m"], ["N", "n"], ["O", "o"], ["P", "p"],
                ["Q", "q"], ["R", "r"], ["S", "s"], ["T", "t"], ["U", "u"], ["V", "v"], ["W", "w"], ["X", "x"],
                ["Y", "y"], ["Z", "z"], ["2", "2"], ["3", "3"], ["4", "4"], ["5", "5"], ["6", "6"], ["7", "7"]
            ],
            padding: "="
        )
        XCTAssertEqual(rfc4648, Base32.Alphabet.rfc4648)

        let zBase32 = try Base32.Alphabet(
            characters: [
                ["y", "Y"], ["b", "B"], ["n", "N"], ["d", "D"], ["r", "R"], ["f", "F"], ["g", "G"], ["8", "8"],
                ["e", "E"], ["j", "J"], ["k", "K"], ["m", "M"], ["c", "C"], ["p", "P"], ["q", "Q"], ["x", "X"],
                ["o", "O"], ["t", "T"], ["1", "1"], ["u", "U"], ["w", "W"], ["i", "I"], ["s", "S"], ["z", "Z"],
                ["a", "A"], ["3", "3"], ["4", "4"], ["5", "5"], ["h", "H"], ["7", "7"], ["6", "6"], ["9", "9"]
            ],
            padding: nil
        )
        XCTAssertEqual(zBase32, Base32.Alphabet.zBase32)

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
        XCTAssertEqual(crockford, Base32.Alphabet.crockford)

        let base32hex = try Base32.Alphabet(
            characters: [
                ["0", "0"], ["1", "1"], ["2", "2"], ["3", "3"], ["4", "4"], ["5", "5"], ["6", "6"], ["7", "7"],
                ["8", "8"], ["9", "9"], ["A", "a"], ["B", "b"], ["C", "c"], ["D", "d"], ["E", "e"], ["F", "f"],
                ["G", "g"], ["H", "h"], ["I", "i"], ["J", "j"], ["K", "k"], ["L", "l"], ["M", "m"], ["N", "n"],
                ["O", "o"], ["P", "p"], ["Q", "q"], ["R", "r"], ["S", "s"], ["T", "t"], ["U", "u"], ["V", "v"]
            ],
            padding: "="
        )
        XCTAssertEqual(base32hex, Base32.Alphabet.base32hex)

        let geohash = try Base32.Alphabet(
            characters: [
                ["0", "0"], ["1", "1"], ["2", "2"], ["3", "3"], ["4", "4"], ["5", "5"], ["6", "6"], ["7", "7"],
                ["8", "8"], ["9", "9"], ["b", "B"], ["c", "C"], ["d", "D"], ["e", "E"], ["f", "F"], ["g", "G"],
                ["h", "H"], ["j", "J"], ["k", "K"], ["m", "M"], ["n", "N"], ["p", "P"], ["q", "Q"], ["r", "R"],
                ["s", "S"], ["t", "T"], ["u", "U"], ["v", "V"], ["w", "W"], ["x", "X"], ["y", "Y"], ["z", "Z"],
            ],
            padding: nil
        )
        XCTAssertEqual(geohash, Base32.Alphabet.geohash)

        let wordSafe = try Base32.Alphabet(
            characters: [
                ["2"], ["3"], ["4"], ["5"], ["6"], ["7"], ["8"], ["9"],
                ["C"], ["F"], ["G"], ["H"], ["J"], ["M"], ["P"], ["Q"],
                ["R"], ["V"], ["W"], ["X"], ["c"], ["f"], ["g"], ["h"],
                ["j"], ["m"], ["p"], ["q"], ["r"], ["v"], ["w"], ["x"]
            ],
            padding: nil
        )
        XCTAssertEqual(wordSafe, Base32.Alphabet.wordSafe)
    }
}
