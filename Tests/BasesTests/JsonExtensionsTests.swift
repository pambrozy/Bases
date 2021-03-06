//
//  JsonExtensionsTests.swift
//  Bases
//
//  Created by Przemek Ambroży on 12.06.2022.
//  Copyright © 2022 Przemysław Ambroży
//

@testable import Bases
import XCTest

struct Example: Codable {
    let data: Data
}

private struct DataCreatingError: Error { }

final class JsonExtensionsTests: XCTestCase {
    func testBase16() throws {
        guard let validData = #"{"data":"414243"}"#.data(using: .utf8) else {
            throw DataCreatingError()
        }
        guard let invalidData = #"{"data":"4"}"#.data(using: .utf8) else {
            throw DataCreatingError()
        }

        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .base16(alphabet: .lowercase)

        let decoded = try decoder.decode(Example.self, from: validData)
        XCTAssertEqual(decoded.data, Data([0x41, 0x42, 0x43]))
        XCTAssertThrowsError(try decoder.decode(Example.self, from: invalidData)) { error in
            XCTAssertTrue(error is DecodingError)
        }

        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .base16(alphabet: .lowercase)

        let encoded = try encoder.encode(decoded)
        XCTAssertEqual(encoded, validData)
    }

    func testBase32() throws {
        guard let validData = #"{"data":"IFBEG==="}"#.data(using: .utf8) else {
            throw DataCreatingError()
        }
        guard let invalidData = #"{"data":"¡"}"#.data(using: .utf8) else {
            throw DataCreatingError()
        }

        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .base32(alphabet: .rfc4648)

        let decoded = try decoder.decode(Example.self, from: validData)
        XCTAssertEqual(decoded.data, Data([0x41, 0x42, 0x43]))
        XCTAssertThrowsError(try decoder.decode(Example.self, from: invalidData)) { error in
            XCTAssertTrue(error is DecodingError)
        }

        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .base32(alphabet: .rfc4648)

        let encoded = try encoder.encode(decoded)
        XCTAssertEqual(encoded, validData)
    }

    func testBase85() throws {
        guard let validData = #"{"data":"5sdp"}"#.data(using: .utf8) else {
            throw DataCreatingError()
        }
        guard let invalidData = #"{"data":"¡"}"#.data(using: .utf8) else {
            throw DataCreatingError()
        }

        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .base85(alphabet: .ascii)

        let decoded = try decoder.decode(Example.self, from: validData)
        XCTAssertEqual(decoded.data, Data([0x41, 0x42, 0x43]))
        XCTAssertThrowsError(try decoder.decode(Example.self, from: invalidData)) { error in
            XCTAssertTrue(error is DecodingError)
        }

        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .base85(alphabet: .ascii)

        let encoded = try encoder.encode(decoded)
        XCTAssertEqual(encoded, validData)
    }
}
