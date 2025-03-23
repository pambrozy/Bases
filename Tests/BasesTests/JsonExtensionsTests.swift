//
//  JsonExtensionsTests.swift
//  Bases
//
//  Created by Przemek Ambroży on 12.06.2022.
//  Copyright © 2022 Przemysław Ambroży
//

@testable import Bases
import Foundation
import Testing

struct Example: Codable {
    let data: Data
}

@Suite("JSON Extensions")
struct JsonExtensionsTests {
    @Test
    func base16() throws {
        let validData = Data(#"{"data":"414243"}"#.utf8)
        let invalidData = Data(#"{"data":"4"}"#.utf8)

        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .base16(alphabet: .lowercase)

        let decoded = try decoder.decode(Example.self, from: validData)
        #expect(decoded.data == Data([0x41, 0x42, 0x43]))
        #expect(throws: DecodingError.self) {
            try decoder.decode(Example.self, from: invalidData)
        }

        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .base16(alphabet: .lowercase)

        let encoded = try encoder.encode(decoded)
        #expect(encoded == validData)
    }

    @Test
    func base32() throws {
        let validData = Data(#"{"data":"IFBEG==="}"#.utf8)
        let invalidData = Data(#"{"data":"¡"}"#.utf8)

        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .base32(alphabet: .rfc4648)

        let decoded = try decoder.decode(Example.self, from: validData)
        #expect(decoded.data == Data([0x41, 0x42, 0x43]))
        #expect(throws: DecodingError.self) {
            try decoder.decode(Example.self, from: invalidData)
        }

        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .base32(alphabet: .rfc4648)

        let encoded = try encoder.encode(decoded)
        #expect(encoded == validData)
    }

    @Test
    func base85() throws {
        let validData = Data(#"{"data":"5sdp"}"#.utf8)
        let invalidData = Data(#"{"data":"¡"}"#.utf8)

        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .base85(alphabet: .ascii)

        let decoded = try decoder.decode(Example.self, from: validData)
        #expect(decoded.data == Data([0x41, 0x42, 0x43]))
        #expect(throws: DecodingError.self) {
            try decoder.decode(Example.self, from: invalidData)
        }

        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .base85(alphabet: .ascii)

        let encoded = try encoder.encode(decoded)
        #expect(encoded == validData)
    }
}
