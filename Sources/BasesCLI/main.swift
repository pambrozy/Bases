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
let data = "ABCDEFGHIJ".data(using: .utf8)!
print("DATA IS", Array(data))

let encoded = Base85.Encoder(alphabet: .ascii).encode(data)
let decoded = try Base85.Decoder(alphabet: .ascii).decode(encoded)

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

printChars(Base85.Alphabet.ascii.characters)
printValues(Base85.Alphabet.ascii.values)

