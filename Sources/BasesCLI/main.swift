//
//  File.swift
//  
//
//  Created by Przemek Ambroży on 06/05/2022.
//

import Foundation
import Bases

func printChars(_ chars: [Character]) {
    print("CHARS")
    let s = chars
        .map { "\"\($0)\"" }
        .chunks(ofCount: 16)
        .map { $0.joined(separator: ", ") + "," }
        .joined(separator: "\n")
    print(s)
}

func printValues(_ values: [UInt8?]) {
    print("VALUES")
    let s = values
        .map { value -> String in
            if let value = value {
                return "\(value)"
            } else {
                return "nil"
            }
        }
        .chunks(ofCount: 8)
        .map { $0.joined(separator: ", ") + "," }
        .joined(separator: "\n")
    print(s)
}
let datax = "ABCD    EFGHIJ".data(using: .utf8)!

let data = Data([0x10, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x08, 0x00, 0x20, 0x0C, 0x41, 0x7A])
print("DATA IS", Array(data))

let encoded = Base85.Encoder(alphabet: .rfc1924).encode(data)
let decoded = try Base85.Decoder(alphabet: .rfc1924).decode(encoded)

print("encoded as", encoded, "and decoded as", String(data: decoded, encoding: .utf8))
//print("Encoded as", encoded)

//let down = Array("23456789CFGHJMPQRVWXcfghjmpqrvwx")
//let up =   Array("23456789CFGHJMPQRVWXcfghjmpqrvwx")
//
//for chars in zip(down, up) {
////    print("[\"\(chars.0)\", \"\(chars.1)\"],")
//    print("[\"\(chars.0)\"],")
//}



//printChars(Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"))

let enc = Base85.Encoder(alphabet: .adobeAscii85).encode(Data())

let adoebAscii = try? Base85.Alphabet(
    characters: [
        "!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", "0",
        "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?", "@",
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
        "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "\\", "]", "^", "_", "`",
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p",
        "q", "r", "s", "t", "u",
    ], startDelimeter: "<~", endDelimeter: "~>", fourZeros: "z", fourSpaces: nil)
print("AA", adoebAscii)

printChars(Base85.Alphabet.rfc1924.characters)
printValues(Base85.Alphabet.rfc1924.values)



