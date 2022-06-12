//
//  LineSeparatorTests.swift
//  Bases
//
//  Created by Przemek Ambroży on 12.06.2022.
//  Copyright © 2022 Przemysław Ambroży
//

@testable import Bases
import XCTest

final class LineSeparatorTests: XCTestCase {
    func testUncheckedInit() {
        let lineSeparator = LineSeparator(separator: "a", uncheckedLength: 3)

        XCTAssertEqual(lineSeparator.separator, "a")
        XCTAssertEqual(lineSeparator.length, 3)
    }

    func testInit() throws {
        XCTAssertThrowsError(try LineSeparator(separator: "a", length: 0)) { error in
            XCTAssertEqual(error as? LineSeparatorError, LineSeparatorError.nonPositiveLength)
        }

        let lineSeparator = try LineSeparator(separator: "a", length: 3)

        XCTAssertEqual(lineSeparator.separator, "a")
        XCTAssertEqual(lineSeparator.length, 3)
    }

    func testBase64() throws {
        let lineSeparator = try LineSeparator(separator: "_", length: 3)
        let alphabet = try Base64.Alphabet(
            characters: Base64.Alphabet.standard.characters,
            padding: Base64.Alphabet.standard.padding,
            lineSeparator: lineSeparator
        )
        let encoder = Base64.Encoder(alphabet: alphabet, pad: true)

        let data = Data(repeating: 0x41, count: 10)
        let encoded = encoder.encode(data)

        XCTAssertEqual(encoded, "QUF_BQU_FBQ_UFB_QQ=_=")
    }
}
