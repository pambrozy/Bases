//
//  File.swift
//  
//
//  Created by Przemek Ambroży on 06/05/2022.
//

import Foundation

extension Base16.Alphabet {
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
