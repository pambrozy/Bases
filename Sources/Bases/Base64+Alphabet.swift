//
//  Base64+Alphabet.swift
//  Bases
//
//  Created by Przemek Ambroży on 08.05.2022.
//  Copyright © 2022 Przemysław Ambroży
//

import Foundation

extension Base64.Alphabet {
    /// The standard alphabet defined in [RFC 4648](https://www.rfc-editor.org/rfc/rfc4648.html).
    public static let standard = Self(
        uncheckedCharacters: [
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
            "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f",
            "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
            "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "/"
        ],
        uncheckedValues: [
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, 62, nil, nil, nil, 63,
            52, 53, 54, 55, 56, 57, 58, 59,
            60, 61, nil, nil, nil, nil, nil, nil,
            nil, 0, 1, 2, 3, 4, 5, 6,
            7, 8, 9, 10, 11, 12, 13, 14,
            15, 16, 17, 18, 19, 20, 21, 22,
            23, 24, 25, nil, nil, nil, nil, nil,
            nil, 26, 27, 28, 29, 30, 31, 32,
            33, 34, 35, 36, 37, 38, 39, 40,
            41, 42, 43, 44, 45, 46, 47, 48,
            49, 50, 51, nil, nil, nil, nil, nil
        ],
        padding: "=",
        lineSeparator: nil
    )

    /// The base64url alphabet defined in [RFC 4648](https://www.rfc-editor.org/rfc/rfc4648.html).
    public static let base64url = Self(
        uncheckedCharacters: [
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
            "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f",
            "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
            "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-", "_"
        ],
        uncheckedValues: [
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, 62, nil, nil,
            52, 53, 54, 55, 56, 57, 58, 59,
            60, 61, nil, nil, nil, nil, nil, nil,
            nil, 0, 1, 2, 3, 4, 5, 6,
            7, 8, 9, 10, 11, 12, 13, 14,
            15, 16, 17, 18, 19, 20, 21, 22,
            23, 24, 25, nil, nil, nil, nil, 63,
            nil, 26, 27, 28, 29, 30, 31, 32,
            33, 34, 35, 36, 37, 38, 39, 40,
            41, 42, 43, 44, 45, 46, 47, 48,
            49, 50, 51, nil, nil, nil, nil, nil
        ],
        padding: "=",
        lineSeparator: nil
    )

    /// The Base64 for UTF-7 alphabet defined in [RFC 2152](https://datatracker.ietf.org/doc/html/rfc2152).
    public static let utf7 = Self(
        uncheckedCharacters: [
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
            "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f",
            "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
            "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "/"
        ],
        uncheckedValues: [
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, 62, nil, nil, nil, 63,
            52, 53, 54, 55, 56, 57, 58, 59,
            60, 61, nil, nil, nil, nil, nil, nil,
            nil, 0, 1, 2, 3, 4, 5, 6,
            7, 8, 9, 10, 11, 12, 13, 14,
            15, 16, 17, 18, 19, 20, 21, 22,
            23, 24, 25, nil, nil, nil, nil, nil,
            nil, 26, 27, 28, 29, 30, 31, 32,
            33, 34, 35, 36, 37, 38, 39, 40,
            41, 42, 43, 44, 45, 46, 47, 48,
            49, 50, 51, nil, nil, nil, nil, nil
        ],
        padding: nil,
        lineSeparator: nil
    )

    /// The Base64 for IMAP mailbox names alphabet defined in
    /// [RFC 3501](https://datatracker.ietf.org/doc/html/rfc3501).
    public static let imapMailboxNames = Self(
        uncheckedCharacters: [
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
            "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f",
            "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
            "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", ","
        ],
        uncheckedValues: [
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, 62, 63, nil, nil, nil,
            52, 53, 54, 55, 56, 57, 58, 59,
            60, 61, nil, nil, nil, nil, nil, nil,
            nil, 0, 1, 2, 3, 4, 5, 6,
            7, 8, 9, 10, 11, 12, 13, 14,
            15, 16, 17, 18, 19, 20, 21, 22,
            23, 24, 25, nil, nil, nil, nil, nil,
            nil, 26, 27, 28, 29, 30, 31, 32,
            33, 34, 35, 36, 37, 38, 39, 40,
            41, 42, 43, 44, 45, 46, 47, 48,
            49, 50, 51, nil, nil, nil, nil, nil
        ],
        padding: nil,
        lineSeparator: nil
    )

    /// The Base64 transfer encoding for MIME alphabet found in
    /// [RFC 2045](https://datatracker.ietf.org/doc/html/rfc2045) with the maximum line length of 76.
    ///
    /// If you want a custom line length, use the ``mime(lineLength:)`` method.
    public static let mime = Self(
        uncheckedCharacters: [
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
            "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f",
            "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
            "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "/"
        ],
        uncheckedValues: [
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, 62, nil, nil, nil, 63,
            52, 53, 54, 55, 56, 57, 58, 59,
            60, 61, nil, nil, nil, nil, nil, nil,
            nil, 0, 1, 2, 3, 4, 5, 6,
            7, 8, 9, 10, 11, 12, 13, 14,
            15, 16, 17, 18, 19, 20, 21, 22,
            23, 24, 25, nil, nil, nil, nil, nil,
            nil, 26, 27, 28, 29, 30, 31, 32,
            33, 34, 35, 36, 37, 38, 39, 40,
            41, 42, 43, 44, 45, 46, 47, 48,
            49, 50, 51, nil, nil, nil, nil, nil
        ],
        padding: "=",
        lineSeparator: LineSeparator(separator: "\r\n", uncheckedLength: 76)
    )

    /// Returns the Base64 transfer encoding for MIME alphabet with a specified maximum line length.
    /// - Parameter lineLength: The maximum line length (must be positive).
    /// - Returns: The Base64 transfer encoding for MIME alphabet found in
    /// [RFC 2045](https://datatracker.ietf.org/doc/html/rfc2045).
    /// - Throws: `LineSeparatorError` when the line length is not positive.
    public static func mime(lineLength: Int) throws -> Self {
        Self(
            uncheckedCharacters: [
                "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
                "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f",
                "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
                "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "/"
            ],
            uncheckedValues: [
                nil, nil, nil, nil, nil, nil, nil, nil,
                nil, nil, nil, nil, nil, nil, nil, nil,
                nil, nil, nil, nil, nil, nil, nil, nil,
                nil, nil, nil, nil, nil, nil, nil, nil,
                nil, nil, nil, nil, nil, nil, nil, nil,
                nil, nil, nil, 62, nil, nil, nil, 63,
                52, 53, 54, 55, 56, 57, 58, 59,
                60, 61, nil, nil, nil, nil, nil, nil,
                nil, 0, 1, 2, 3, 4, 5, 6,
                7, 8, 9, 10, 11, 12, 13, 14,
                15, 16, 17, 18, 19, 20, 21, 22,
                23, 24, 25, nil, nil, nil, nil, nil,
                nil, 26, 27, 28, 29, 30, 31, 32,
                33, 34, 35, 36, 37, 38, 39, 40,
                41, 42, 43, 44, 45, 46, 47, 48,
                49, 50, 51, nil, nil, nil, nil, nil
            ],
            padding: "=",
            lineSeparator: try LineSeparator(separator: "\r\n", length: lineLength)
        )
    }
}
