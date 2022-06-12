//
//  DataExtensionsTests.swift
//  Bases
//
//  Created by Przemek Ambroży on 12.06.2022.
//  Copyright © 2022 Przemysław Ambroży
//

@testable import Bases
import XCTest

private struct DataCreatingError: Error { }

final class DataExtensionsTests: XCTestCase {
    private let testData = Data([0x41, 0x42, 0x43])

    func testBase16() throws {
        let encodedString = testData.base16EncodedString(alphabet: .lowercase)
        guard let encodedData = encodedString.data(using: .utf8) else {
            throw DataCreatingError()
        }
        XCTAssertEqual(encodedString, "414243")

        let decodedFromString = Data(base16Encoded: encodedString, alphabet: .lowercase)
        XCTAssertNotNil(decodedFromString)
        XCTAssertEqual(decodedFromString, testData)

        let notDecodedFromString = Data(base16Encoded: "a", alphabet: .lowercase)
        XCTAssertNil(notDecodedFromString)

        let decodedFromData = Data(base16Encoded: encodedData, alphabet: .lowercase)
        XCTAssertNotNil(decodedFromData)
        XCTAssertEqual(decodedFromData, testData)

        let notDecodedFromData = Data(base16Encoded: Data([0x61]), alphabet: .lowercase)
        XCTAssertNil(notDecodedFromData)
    }

    func testBase32() throws {
        let encodedString = testData.base32EncodedString(alphabet: .rfc4648)
        guard let encodedData = encodedString.data(using: .utf8) else {
            throw DataCreatingError()
        }
        XCTAssertEqual(encodedString, "IFBEG===")

        let decodedFromString = Data(base32Encoded: encodedString, alphabet: .rfc4648)
        XCTAssertNotNil(decodedFromString)
        XCTAssertEqual(decodedFromString, testData)

        let notDecodedFromString = Data(base32Encoded: "¡", alphabet: .rfc4648)
        XCTAssertNil(notDecodedFromString)

        let decodedFromData = Data(base32Encoded: encodedData, alphabet: .rfc4648)
        XCTAssertNotNil(decodedFromData)
        XCTAssertEqual(decodedFromData, testData)

        let notDecodedFromData = Data(base32Encoded: Data([0x00, 0xA1]), alphabet: .rfc4648)
        XCTAssertNil(notDecodedFromData)
    }

    func testBase85() throws {
        let encodedString = testData.base85EncodedString(alphabet: .ascii)
        guard let encodedData = encodedString.data(using: .utf8) else {
            throw DataCreatingError()
        }
        XCTAssertEqual(encodedString, "5sdp")

        let decodedFromString = Data(base85Encoded: encodedString, alphabet: .ascii)
        XCTAssertNotNil(decodedFromString)
        XCTAssertEqual(decodedFromString, testData)

        let notDecodedFromString = Data(base85Encoded: "¡", alphabet: .ascii)
        XCTAssertNil(notDecodedFromString)

        let decodedFromData = Data(base85Encoded: encodedData, alphabet: .ascii)
        XCTAssertNotNil(decodedFromData)
        XCTAssertEqual(decodedFromData, testData)

        let notDecodedFromData = Data(base85Encoded: Data([0x00, 0xA1]), alphabet: .ascii)
        XCTAssertNil(notDecodedFromData)
    }
}
