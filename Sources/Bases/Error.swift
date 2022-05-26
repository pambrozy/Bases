//
//  File.swift
//  
//
//  Created by Przemek Ambroży on 06/05/2022.
//

public enum LineSeparatorError: Error {
    case nonPositiveLength
}

public enum AlphabetError: Error {
    case wrongNumberOfCharacters
    case noAsciiValue
}

public enum DecodingError: Error {
    case containsUnknownCharacters
    case wrongNumberOfBytes
    case nonAsciiCharacters
    case valuesNotInAlphabet
}
