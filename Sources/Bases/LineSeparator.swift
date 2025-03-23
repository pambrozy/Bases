//
//  LineSeparator.swift
//  Bases
//
//  Created by Przemek Ambroży on 08.05.2022.
//  Copyright © 2022 Przemysław Ambroży
//

import Foundation

/// A struct representing the line separator.
public struct LineSeparator: Hashable, Sendable {
    /// The string to insert when the length of the encoded string exceeds the ``length``.
    public let separator: String
    /// The maximum length of the encoded string, after which the ``separator`` will be inserted.
    public let length: Int

    init(separator: String, uncheckedLength: Int) {
        self.separator = separator
        self.length = uncheckedLength
    }

    /// Creates a new line separator.
    /// - Parameters:
    ///   - separator: The string to insert when the length of the encoded string exceeds the ``length``.
    ///   - length: The maximum length of the encoded string, after which the ``separator`` will be inserted.
    public init(separator: String, length: Int) throws {
        guard length > 0 else {
            throw LineSeparatorError.nonPositiveLength
        }
        self.separator = separator
        self.length = length
    }
}
