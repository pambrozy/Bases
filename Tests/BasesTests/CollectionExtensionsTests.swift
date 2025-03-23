//
//  CollectionExtensionsTests.swift
//  Bases
//
//  Created by Przemek Ambroży on 12.06.2022.
//  Copyright © 2022 Przemysław Ambroży
//

@testable import Bases
import Testing

@Suite("Collection Extensions")
struct CollectionExtensionsTests {
    @Test
    func chunks() {
        let array = [1, 2, 3, 4]
        let chunks = array.chunks(ofCount: 3)

        #expect(chunks.count == 2)
        #expect(chunks[0] == [1, 2, 3])
        #expect(chunks[1] == [4])
    }

    @Test
    func trimmingSuffix() {
        let array1 = [1, 2, 2, 2]
        let trimmed1 = array1.trimmingSuffix { $0 == 2 }

        #expect(trimmed1.count == 1)
        #expect(trimmed1 == [1])

        let trimmed2 = array1.trimmingSuffix { _ in true }
        #expect(trimmed2.isEmpty)
    }
}
