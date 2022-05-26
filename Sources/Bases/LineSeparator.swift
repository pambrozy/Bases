//
//  File.swift
//  
//
//  Created by Przemek Ambroży on 08/05/2022.
//

import Foundation

public struct LineSeparator: Equatable {
    public let separator: String
    public let length: Int

    init(separator: String, uncheckedLength: Int) {
        self.separator = separator
        self.length = uncheckedLength
    }

    public init(separator: String, length: Int) throws {
        guard length > 0 else {
            throw LineSeparatorError.nonPositiveLength
        }
        self.separator = separator
        self.length = length
    }
}
