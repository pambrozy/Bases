//
//  Error.swift
//  Bases
//
//  Created by Przemysław Ambroży on 06.05.2022.
//  Copyright © 2022 Przemysław Ambroży
//

/// An error that may occur when creating a line separator.
public enum LineSeparatorError: Error {
    /// The length of the string is less than of equal to zero.
    case nonPositiveLength
}

/// An error that might occur when creating an alphabet.
public enum AlphabetError: Error {
    /// The number of characters does not match the number of characters
    /// required to create the alphabet for a given encoding.
    case wrongNumberOfCharacters
    /// The array with characters contains a non-ASCII character.
    case noAsciiValue
}

/// An error that may occur when decoding the string.
public enum BaseDecodingError: Error {
    /// The length of the provided string is invalid.
    case wrongNumberOfBytes
    /// The string to decode contains non-ASCII values.
    case nonAsciiCharacters
    /// The given string contains characters not found in the alphabet.
    case valuesNotInAlphabet
}
