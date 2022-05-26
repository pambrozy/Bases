//
//  File.swift
//  
//
//  Created by Przemek Ambroży on 26/05/2022.
//

import Foundation

extension Collection {
    // TODO: Make `internal`
    public func chunks(ofCount count: Int) -> [SubSequence] {
        var startIndex = self.startIndex
        var result = [SubSequence]()
        result.reserveCapacity(self.count / count)

        while startIndex < self.endIndex {
            let endIndex = index(startIndex, offsetBy: count, limitedBy: self.endIndex) ?? self.endIndex
            result.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return result
    }
}

extension BidirectionalCollection {
    func trimmingSuffix(
        while predicate: (Element) throws -> Bool
    ) rethrows -> SubSequence {
        var end = endIndex
        while end != startIndex {
            let after = end
            formIndex(before: &end)
            if try !predicate(self[end]) {
                return self[..<after]
            }
        }
        return self[..<end]
    }
}
