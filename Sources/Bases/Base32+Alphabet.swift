//
//  File.swift
//  
//
//  Created by Przemek Ambroży on 07/05/2022.
//

import Foundation

extension Base32.Alphabet {
    public static let rfc4648 = Self(
        uncheckedCharacters: [
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
            "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "2", "3", "4", "5", "6", "7"
        ],
        uncheckedValues: [
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, 26, 27, 28, 29, 30, 31,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, 0, 1, 2, 3, 4, 5, 6,
            7, 8, 9, 10, 11, 12, 13, 14,
            15, 16, 17, 18, 19, 20, 21, 22,
            23, 24, 25, nil, nil, nil, nil, nil,
            nil, 0, 1, 2, 3, 4, 5, 6,
            7, 8, 9, 10, 11, 12, 13, 14,
            15, 16, 17, 18, 19, 20, 21, 22,
            23, 24, 25, nil, nil, nil, nil, nil
        ],
        padding: "="
    )

    public static let zBase32 = Self(
        uncheckedCharacters: [
            "y", "b", "n", "d", "r", "f", "g", "8", "e", "j", "k", "m", "c", "p", "q", "x",
            "o", "t", "1", "u", "w", "i", "s", "z", "a", "3", "4", "5", "h", "7", "6", "9"
        ],
        uncheckedValues: [
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, 18, nil, 25, 26, 27, 30, 29,
            7, 31, nil, nil, nil, nil, nil, nil,
            nil, 24, 1, 12, 3, 8, 5, 6,
            28, 21, 9, 10, nil, 11, 2, 16,
            13, 14, 4, 22, 17, 19, nil, 20,
            15, 0, 23, nil, nil, nil, nil, nil,
            nil, 24, 1, 12, 3, 8, 5, 6,
            28, 21, 9, 10, nil, 11, 2, 16,
            13, 14, 4, 22, 17, 19, nil, 20,
            15, 0, 23, nil, nil, nil, nil, nil
        ],
        padding: nil
    )

    public static let crockford = Self(
        uncheckedCharacters: [
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F",
            "G", "H", "J", "K", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Y", "Z"
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
            nil, 10, 11, 12, 13, 14, 15, 16,
            17, 1, 18, 19, 1, 20, 21, 0,
            22, 23, 24, 25, 26, nil, 27, 28,
            29, 30, 31, nil, nil, nil, nil, nil,
            nil, 10, 11, 12, 13, 14, 15, 16,
            17, 1, 18, 19, 1, 20, 21, 0,
            22, 23, 24, 25, 26, nil, 27, 28,
            29, 30, 31, nil, nil, nil, nil, nil
        ],
        padding: nil
    )

    public static let base32hex = Self(
        uncheckedCharacters: [
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F",
            "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V"
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
            nil, 10, 11, 12, 13, 14, 15, 16,
            17, 18, 19, 20, 21, 22, 23, 24,
            25, 26, 27, 28, 29, 30, 31, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, 10, 11, 12, 13, 14, 15, 16,
            17, 18, 19, 20, 21, 22, 23, 24,
            25, 26, 27, 28, 29, 30, 31, nil,
            nil, nil, nil, nil, nil, nil, nil, nil
        ],
        padding: "="
    )

    public static let geohash = Self(
        uncheckedCharacters: [
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "b", "c", "d", "e", "f", "g",
            "h", "j", "k", "m", "n", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
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
            nil, nil, 10, 11, 12, 13, 14, 15,
            16, nil, 17, 18, nil, 19, 20, nil,
            21, 22, 23, 24, 25, 26, 27, 28,
            29, 30, 31, nil, nil, nil, nil, nil,
            nil, nil, 10, 11, 12, 13, 14, 15,
            16, nil, 17, 18, nil, 19, 20, nil,
            21, 22, 23, 24, 25, 26, 27, 28,
            29, 30, 31, nil, nil, nil, nil, nil
        ],
        padding: nil
    )

    public static let wordSafe = Self(
        uncheckedCharacters: [
            "2", "3", "4", "5", "6", "7", "8", "9", "C", "F", "G", "H", "J", "M", "P", "Q",
            "R", "V", "W", "X", "c", "f", "g", "h", "j", "m", "p", "q", "r", "v", "w", "x"
        ],
        uncheckedValues: [
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, 0, 1, 2, 3, 4, 5,
            6, 7, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, 8, nil, nil, 9, 10,
            11, nil, 12, nil, nil, 13, nil, nil,
            14, 15, 16, nil, nil, nil, 17, 18,
            19, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, 20, nil, nil, 21, 22,
            23, nil, 24, nil, nil, 25, nil, nil,
            26, 27, 28, nil, nil, nil, 29, 30,
            31, nil, nil, nil, nil, nil, nil, nil
        ],
        padding: nil
    )
}
