//
//  LineSeparatorTests.swift
//  Bases
//
//  Created by Przemek Ambroży on 12.06.2022.
//  Copyright © 2022 Przemysław Ambroży
//

@testable import Bases
import Foundation
import Testing

@Suite("LineSeparator")
struct LineSeparatorTests {
    @Test
    func uncheckedInit() {
        let lineSeparator = LineSeparator(separator: "a", uncheckedLength: 3)

        #expect(lineSeparator.separator == "a")
        #expect(lineSeparator.length == 3)
    }

    @Test
    func initalization() throws {
        #expect(throws: LineSeparatorError.nonPositiveLength) {
            try LineSeparator(separator: "a", length: 0)
        }

        let lineSeparator = try LineSeparator(separator: "a", length: 3)

        #expect(lineSeparator.separator == "a")
        #expect(lineSeparator.length == 3)
    }

    @Test
    func base64() throws {
        let lineSeparator = try LineSeparator(separator: "_", length: 3)
        let alphabet = try Base64.Alphabet(
            characters: Base64.Alphabet.standard.characters,
            padding: Base64.Alphabet.standard.padding,
            lineSeparator: lineSeparator
        )
        let encoder = Base64.Encoder(alphabet: alphabet, pad: true)

        let data = Data(repeating: 0x41, count: 10)
        let encoded = encoder.encode(data)

        #expect(encoded == "QUF_BQU_FBQ_UFB_QQ=_=")
    }
}
