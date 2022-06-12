import XCTest
@testable import Bases

final class CollectionExtensionsTests: XCTestCase {
    func testChunks() {
        let array = [1, 2, 3, 4]
        let chunks = array.chunks(ofCount: 3)

        XCTAssertEqual(chunks.count, 2)
        XCTAssertEqual(chunks[0], [1, 2, 3])
        XCTAssertEqual(chunks[1], [4])
    }

    func testTrimmingSuffix() {
        let array1 = [1, 2, 2, 2]
        let trimmed1 = array1.trimmingSuffix { $0 == 2 }

        XCTAssertEqual(trimmed1.count, 1)
        XCTAssertEqual(trimmed1, [1])

        let trimmed2 = array1.trimmingSuffix { _ in true }
        XCTAssertTrue(trimmed2.isEmpty)
    }
}
