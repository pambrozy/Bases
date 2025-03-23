//
//  Base85Tests.swift
//  Bases
//
//  Created by Przemek Ambroży on 12.06.2022.
//  Copyright © 2022 Przemysław Ambroży
//

@testable import Bases
import Foundation
import Testing

@Suite("Base85")
struct Bases85Tests {

    // MARK: Built-in alphabets

    @Test
    func builtInAsciiAlphabet() throws {
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
        #expect(ascii == Base85.Alphabet.ascii)
    }

    @Test
    func builtInBtoaLikeAlphabet() throws {
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
        #expect(btoaLike == Base85.Alphabet.btoaLike)
    }

    @Test
    func builtInAdobeAscii85Alphabet() throws {
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
        #expect(adobeAscii85 == Base85.Alphabet.adobeAscii85)
    }

    @Test
    func builtInRfc1924LikeAlphabet() throws {
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
        #expect(rfc1924 == Base85.Alphabet.rfc1924Like)
    }

    @Test
    func builtInZ85Alphabet() throws {
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
        #expect(z85 == Base85.Alphabet.z85)
    }

    @Test
    func alphabet() {
        #expect(throws: AlphabetError.wrongNumberOfCharacters) {
            try Base85.Alphabet(
                characters: [],
                startDelimeter: nil,
                endDelimeter: nil,
                fourZeros: nil,
                fourSpaces: nil
            )
        }

        let notEmpty = [Character](repeating: "¡", count: 85)
        #expect(throws: AlphabetError.noAsciiValue) {
            try Base85.Alphabet(
                characters: notEmpty,
                startDelimeter: nil,
                endDelimeter: nil,
                fourZeros: nil,
                fourSpaces: nil
            )
        }
    }

    @Test
    func decoding() {
        let decoder = Base85.Decoder(alphabet: .ascii)
        #expect(throws: BaseDecodingError.nonAsciiCharacters) {
            try decoder.decode("¡")
        }
        #expect(throws: BaseDecodingError.valuesNotInAlphabet) {
            try decoder.decode("w")
        }
    }

    // MARK: Examples

    @Test
    func ascii() throws {
        let encoder = Base85.Encoder(alphabet: .ascii)
        let decoder = Base85.Decoder(alphabet: .ascii)

        let testData = Data([0x41, 0x42, 0x43, 0x44])

        #expect(encoder.encode(testData) == "5sdq,")
        #expect(try decoder.decode("5sdq,") == testData)

    }

    @Test
    func btoaLike() throws {
        let encoder = Base85.Encoder(alphabet: .btoaLike)
        let decoder = Base85.Decoder(alphabet: .btoaLike)

        let testData1 = Data([
            0x41, 0x42, 0x43, 0x44, 0x20, 0x20, 0x20, 0x20,
            0x45, 0x46, 0x47, 0x48, 0x49, 0x4A
        ])

        #expect(encoder.encode(testData1) == "5sdq,y77Kd<8P/")
        #expect(try decoder.decode("5sdq,y77Kd<8P/") == testData1)

        let testData2 = Data([0, 0, 0, 0, 1])
        #expect(encoder.encode(testData2) == "z!<")
        #expect(try decoder.decode("z!<") == testData2)

        let testData3 = Data([0, 0, 0, 0, 0, 0, 0, 0])
        #expect(encoder.encode(testData3) == "z!!!!!")
        #expect(try decoder.decode("z!!!!!") == testData3)

        #expect(encoder.encode(Data()).isEmpty)
        #expect(try decoder.decode("") == Data())
    }

    @Test
    func adobeAscii85() throws {
        let encoder = Base85.Encoder(alphabet: .adobeAscii85)
        let decoder = Base85.Decoder(alphabet: .adobeAscii85)

        let decodedData = Data([
            0x4d, 0x61, 0x6e, 0x20, 0x69, 0x73, 0x20, 0x64, 0x69, 0x73, 0x74, 0x69, 0x6e, 0x67, 0x75, 0x69,
            0x73, 0x68, 0x65, 0x64, 0x2c, 0x20, 0x6e, 0x6f, 0x74, 0x20, 0x6f, 0x6e, 0x6c, 0x79, 0x20, 0x62,
            0x79, 0x20, 0x68, 0x69, 0x73, 0x20, 0x72, 0x65, 0x61, 0x73, 0x6f, 0x6e, 0x2c, 0x20, 0x62, 0x75,
            0x74, 0x20, 0x62, 0x79, 0x20, 0x74, 0x68, 0x69, 0x73, 0x20, 0x73, 0x69, 0x6e, 0x67, 0x75, 0x6c,
            0x61, 0x72, 0x20, 0x70, 0x61, 0x73, 0x73, 0x69, 0x6f, 0x6e, 0x20, 0x66, 0x72, 0x6f, 0x6d, 0x20,
            0x6f, 0x74, 0x68, 0x65, 0x72, 0x20, 0x61, 0x6e, 0x69, 0x6d, 0x61, 0x6c, 0x73, 0x2c, 0x20, 0x77,
            0x68, 0x69, 0x63, 0x68, 0x20, 0x69, 0x73, 0x20, 0x61, 0x20, 0x6c, 0x75, 0x73, 0x74, 0x20, 0x6f,
            0x66, 0x20, 0x74, 0x68, 0x65, 0x20, 0x6d, 0x69, 0x6e, 0x64, 0x2c, 0x20, 0x74, 0x68, 0x61, 0x74,
            0x20, 0x62, 0x79, 0x20, 0x61, 0x20, 0x70, 0x65, 0x72, 0x73, 0x65, 0x76, 0x65, 0x72, 0x61, 0x6e,
            0x63, 0x65, 0x20, 0x6f, 0x66, 0x20, 0x64, 0x65, 0x6c, 0x69, 0x67, 0x68, 0x74, 0x20, 0x69, 0x6e,
            0x20, 0x74, 0x68, 0x65, 0x20, 0x63, 0x6f, 0x6e, 0x74, 0x69, 0x6e, 0x75, 0x65, 0x64, 0x20, 0x61,
            0x6e, 0x64, 0x20, 0x69, 0x6e, 0x64, 0x65, 0x66, 0x61, 0x74, 0x69, 0x67, 0x61, 0x62, 0x6c, 0x65,
            0x20, 0x67, 0x65, 0x6e, 0x65, 0x72, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x6f, 0x66, 0x20, 0x6b,
            0x6e, 0x6f, 0x77, 0x6c, 0x65, 0x64, 0x67, 0x65, 0x2c, 0x20, 0x65, 0x78, 0x63, 0x65, 0x65, 0x64,
            0x73, 0x20, 0x74, 0x68, 0x65, 0x20, 0x73, 0x68, 0x6f, 0x72, 0x74, 0x20, 0x76, 0x65, 0x68, 0x65,
            0x6d, 0x65, 0x6e, 0x63, 0x65, 0x20, 0x6f, 0x66, 0x20, 0x61, 0x6e, 0x79, 0x20, 0x63, 0x61, 0x72,
            0x6e, 0x61, 0x6c, 0x20, 0x70, 0x6c, 0x65, 0x61, 0x73, 0x75, 0x72, 0x65, 0x2e
        ])

        let encodedData =
            #"<~"# +
            #"9jqo^BlbD-BleB1DJ+*+F(f,q/0JhKF<GL>Cj@.4Gp$d7F!,L7@<6@)/0JDEF<G%<+EV:2F!,O<"# +
            #"DJ+*.@<*K0@<6L(Df-\0Ec5e;DffZ(EZee.Bl.9pF"AGXBPCsi+DGm>@3BB/F*&OCAfu2/AKYi("# +
            #"DIb:@FD,*)+C]U=@3BN#EcYf8ATD3s@q?d$AftVqCh[NqF<G:8+EV:.+Cf>-FD5W8ARlolDIal("# +
            #"DId<j@<?3r@:F%a+D58'ATD4$Bl@l3De:,-DJs`8ARoFb/0JMK@qB4^F!,R<AKZ&-DfTqBG%G>u"# +
            #"D.RTpAKYo'+CT/5+Cei#DII?(E,9)oF*2M7/c"# +
            #"~>"#

        #expect(encoder.encode(decodedData) == encodedData)
        #expect(try decoder.decode(encodedData) == decodedData)
    }

    @Test
    func rfc1924Like() throws {
        let encoder = Base85.Encoder(alphabet: .rfc1924Like)
        let decoder = Base85.Decoder(alphabet: .rfc1924Like)

        let decodedData = Data([
            0x10, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x08, 0x08, 0x00, 0x20, 0x0C, 0x41, 0x7A
        ])

        let encodedData = "5P$#x0000000;;GAPhlz"

        #expect(encoder.encode(decodedData) == encodedData)
        #expect(try decoder.decode(encodedData) == decodedData)
    }

    @Test
    func z85() throws {
        let encoder = Base85.Encoder(alphabet: .z85)
        let decoder = Base85.Decoder(alphabet: .z85)

        let testData1 = Data([0x86, 0x4F, 0xD2, 0x6F, 0xB5, 0x59, 0xF7, 0x5B])
        #expect(encoder.encode(testData1) == "HelloWorld")
        #expect(try decoder.decode("HelloWorld") == testData1)

        let testData2 = Data([
            0x8E, 0x0B, 0xDD, 0x69, 0x76, 0x28, 0xB9, 0x1D,
            0x8F, 0x24, 0x55, 0x87, 0xEE, 0x95, 0xC5, 0xB0,
            0x4D, 0x48, 0x96, 0x3F, 0x79, 0x25, 0x98, 0x77,
            0xB4, 0x9C, 0xD9, 0x06, 0x3A, 0xEA, 0xD3, 0xB7
        ])
        #expect(encoder.encode(testData2) == "JTKVSB%%)wK0E.X)V>+}o?pNmC{O&4W4b!Ni{Lh6")
        #expect(try decoder.decode("JTKVSB%%)wK0E.X)V>+}o?pNmC{O&4W4b!Ni{Lh6") == testData2)
    }
}
