//
//  DataExtensionsTests.swift
//  Bases
//
//  Created by Przemek Ambroży on 12.06.2022.
//  Copyright © 2022 Przemysław Ambroży
//

@testable import Bases
import Foundation
import Testing

@Suite("Data Extensions")
struct DataExtensionsTests {
    private let testData = Data([0x41, 0x42, 0x43])

    @Test
    func base16() throws {
        let encodedString = testData.base16EncodedString(alphabet: .lowercase)
        let encodedData = try #require(encodedString.data(using: .utf8))
        #expect(encodedString == "414243")

        let decodedFromString = Data(base16Encoded: encodedString, alphabet: .lowercase)
        #expect(decodedFromString == testData)

        let notDecodedFromString = Data(base16Encoded: "a", alphabet: .lowercase)
        #expect(notDecodedFromString == nil)

        let decodedFromData = Data(base16Encoded: encodedData, alphabet: .lowercase)
        #expect(decodedFromData == testData)

        let notDecodedFromData = Data(base16Encoded: Data([0x61]), alphabet: .lowercase)
        #expect(notDecodedFromData == nil)
    }

    @Test
    func base32() throws {
        let encodedString = testData.base32EncodedString(alphabet: .rfc4648)
        let encodedData = try #require(encodedString.data(using: .utf8))
        #expect(encodedString == "IFBEG===")

        let decodedFromString = Data(base32Encoded: encodedString, alphabet: .rfc4648)
        #expect(decodedFromString == testData)

        let notDecodedFromString = Data(base32Encoded: "¡", alphabet: .rfc4648)
        #expect(notDecodedFromString == nil)

        let decodedFromData = Data(base32Encoded: encodedData, alphabet: .rfc4648)
        #expect(decodedFromData == testData)

        let notDecodedFromData = Data(base32Encoded: Data([0x00, 0xA1]), alphabet: .rfc4648)
        #expect(notDecodedFromData == nil)
    }

    @Test
    func base85() throws {
        let encodedString = testData.base85EncodedString(alphabet: .ascii)
        let encodedData = try #require(encodedString.data(using: .utf8))
        #expect(encodedString == "5sdp")

        let decodedFromString = Data(base85Encoded: encodedString, alphabet: .ascii)
        #expect(decodedFromString == testData)

        let notDecodedFromString = Data(base85Encoded: "¡", alphabet: .ascii)
        #expect(notDecodedFromString == nil)

        let decodedFromData = Data(base85Encoded: encodedData, alphabet: .ascii)
        #expect(decodedFromData == testData)

        let notDecodedFromData = Data(base85Encoded: Data([0x00, 0xA1]), alphabet: .ascii)
        #expect(notDecodedFromData == nil)
    }
}
