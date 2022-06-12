//
//  Base16+Alphabet.swift
//  Bases
//
//  Created by Przemek Ambroży on 06.05.2022.
//  Copyright © 2022 Przemysław Ambroży
//

import Foundation

extension Base16.Alphabet {
    /// The Base-16 uppercase alphabet, consisting of digits 0-9 and uppercase letters A-F.
    public static let uppercase = Self(
        uncheckedCharacters: [
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"
        ],
        uncheckedValues: [
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            0, 1, 2, 3, 4, 5, 6, 7,
            8, 9, nil, nil, nil, nil, nil, nil,
            nil, 10, 11, 12, 13, 14, 15, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil
        ]
    )

    /// The Base-16 lowercase alphabet, consisting of digits 0-9 and lowercase letters a-f.
    public static let lowercase = Self(
        uncheckedCharacters: [
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"
        ],
        uncheckedValues: [
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            0, 1, 2, 3, 4, 5, 6, 7,
            8, 9, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, 10, 11, 12, 13, 14, 15, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil
        ]
    )
}
