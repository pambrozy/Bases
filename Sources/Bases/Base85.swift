//
//  File.swift
//  
//
//  Created by Przemek Ambroży on 08/05/2022.
//

import Foundation

public enum Base85 {

    // MARK: - Alphabet

    public struct Alphabet: Equatable {
        public let characters: [Character]
        public let values: [UInt8?]
        public let startDelimeter: String?
        public let endDelimeter: String?
        public let fourZeros: Character?
        public let fourSpaces: Character?

        init(
            uncheckedCharacters: [Character],
            uncheckedValues: [UInt8?],
            startDelimeter: String?,
            endDelimeter: String?,
            fourZeros: Character?,
            fourSpaces: Character?
        ) {
            self.characters = uncheckedCharacters
            self.values = uncheckedValues
            self.startDelimeter = startDelimeter
            self.endDelimeter = endDelimeter
            self.fourZeros = fourZeros
            self.fourSpaces = fourSpaces
        }

        public init(
            characters: [Character],
            startDelimeter: String?,
            endDelimeter: String?,
            fourZeros: Character?,
            fourSpaces: Character?
        ) throws {
            guard characters.count == 85 else {
                throw AlphabetError.wrongNumberOfCharacters
            }

            let asciiValues = try characters.map { character -> UInt8 in
                guard let asciiValue = character.asciiValue else {
                    throw AlphabetError.noAsciiValue
                }
                return asciiValue
            }

            var values = [UInt8?](repeating: nil, count: 128)
            for (index, asciiValue) in asciiValues.enumerated() {
                values[Int(asciiValue)] = UInt8(index)
            }

            self.characters = characters
            self.values = values
            self.startDelimeter = startDelimeter
            self.endDelimeter = endDelimeter
            self.fourZeros = fourZeros
            self.fourSpaces = fourSpaces
        }
    }

    // MARK: - Encoder

    public struct Encoder {
        let alphabet: Alphabet
        let pad: Bool

        /// <#Description#>
        /// - Parameters:
        ///   - alphabet: <#alphabet description#>
        ///   - pad: Whether to pad the data if the alphabet includes the padding character.
        public init(alphabet: Alphabet, pad: Bool = true) {
            self.alphabet = alphabet
            self.pad = pad
        }

        public func encode<T: DataProtocol>(_ data: T) -> String {
            guard !data.isEmpty else {
                return ""
            }

            let padding = data.count.isMultiple(of: 4) ? 0 : 4 - (data.count % 4)
            let padCharacterCount = padding * 5 / 4

            let data = Array(data) + [UInt8](repeating: 0, count: padding)

            // TODO: Check if necessary
//            output.reserveCapacity(data.count * 5 / 4)

            var output = data
                .chunks(ofCount: 4)
                .flatMap { chunk -> [Character] in
                    let number = UInt32(
                        bigEndian: ContiguousArray(chunk).withUnsafeBytes { $0.load(as: UInt32.self) }
                    )

                    return [
                        alphabet.characters[Int((number / 52_200_625) % 85)],
                        alphabet.characters[Int((number / 614_125) % 85)],
                        alphabet.characters[Int((number / 7_225) % 85)],
                        alphabet.characters[Int((number / 85) % 85)],
                        alphabet.characters[Int(number % 85)],
                    ]
                }
                .dropLast(padCharacterCount)
                .chunks(ofCount: 5)
                .flatMap { chunk -> [Character] in
                    if chunk.count == 5 {
                        if chunk[chunk.startIndex] == alphabet.characters[0],
                           chunk[chunk.startIndex + 1] == alphabet.characters[0],
                           chunk[chunk.startIndex + 2] == alphabet.characters[0],
                           chunk[chunk.startIndex + 3] == alphabet.characters[0],
                           chunk[chunk.startIndex + 4] == alphabet.characters[0],
                           let zeroCharacter = alphabet.fourZeros {
                            // Replace zeros
                            return [zeroCharacter]
                        } else if chunk[chunk.startIndex] == alphabet.characters[10],
                                  chunk[chunk.startIndex + 1] == alphabet.characters[27],
                                  chunk[chunk.startIndex + 2] == alphabet.characters[53],
                                  chunk[chunk.startIndex + 3] == alphabet.characters[67],
                                  chunk[chunk.startIndex + 4] == alphabet.characters[43],
                                  let spaceCharacter = alphabet.fourSpaces {
                            // Replace spaces
                            return [spaceCharacter]
                        }
                    }
                    return Array(chunk)
                }

            // Result cannot end with zeros
            if let zeroCharacter = alphabet.fourZeros, output.last == zeroCharacter {
                output.removeLast()
                output += Array(repeating: alphabet.characters[0], count: 5)
            }

            // Add delimeters
            if let startDelimeter = alphabet.startDelimeter {
                output = startDelimeter + output
            }
            if let endDelimeter = alphabet.endDelimeter {
                output += endDelimeter
            }

            return String(output)
        }
    }

    // MARK: - Decoder

    public struct Decoder {
        public let alphabet: Alphabet

        public init(alphabet: Alphabet) {
            self.alphabet = alphabet
        }

        public func decode(_ text: String) throws -> Data {
            guard !text.isEmpty else {
                return Data()
            }
            var text = text

            // Remove delimeters
            if let startDelimeter = alphabet.startDelimeter, text.hasPrefix(startDelimeter) {
                text.removeFirst(startDelimeter.count)
            }
            if let endDelimeter = alphabet.endDelimeter, text.hasSuffix(endDelimeter) {
                text.removeLast(endDelimeter.count)
            }

            // TODO: Remove whitespace

            // Replace four zeros
            if let zerosCharacter = alphabet.fourZeros {
                text = text.replacingOccurrences(
                    of: String(zerosCharacter),
                    with: String(
                        [
                            alphabet.characters[0],
                            alphabet.characters[0],
                            alphabet.characters[0],
                            alphabet.characters[0],
                            alphabet.characters[0]
                        ]
                    )
                )
            }

            // Replace four spaces
            if let spaceCharacter = alphabet.fourSpaces {
                text = text.replacingOccurrences(
                    of: String(spaceCharacter),
                    with: String(
                        [
                            alphabet.characters[10],
                            alphabet.characters[27],
                            alphabet.characters[53],
                            alphabet.characters[67],
                            alphabet.characters[43]
                        ]
                    )
                )
            }

            // Calculate pad characters
            let padCharacterCount = text.count.isMultiple(of: 5) ? 0 : 5 - (text.count % 5)

            text += String(repeating: alphabet.characters[84], count: padCharacterCount)

            var data = try text
                .map { character -> UInt8 in
                    guard let asciiValue = character.asciiValue else {
                        throw DecodingError.nonAsciiCharacters
                    }
                    guard let value = alphabet.values[Int(asciiValue)] else {
                        throw DecodingError.valuesNotInAlphabet
                    }
                    return value
                }
                .chunks(ofCount: 5)
                .flatMap { chunk -> [UInt8] in
                    print("CHUNK IS", chunk)
                    let number: UInt32 =
                        (UInt32(chunk[chunk.startIndex]) * 52_200_625) +
                        (UInt32(chunk[chunk.startIndex + 1]) * 614_125) +
                        (UInt32(chunk[chunk.startIndex + 2]) * 7_225) +
                        (UInt32(chunk[chunk.startIndex + 3]) * 85) +
                        (UInt32(chunk[chunk.startIndex + 4]))

                    return [
                        UInt8((number >> 24) & 0xFF),
                        UInt8((number >> 16) & 0xFF),
                        UInt8((number >> 8) & 0xFF),
                        UInt8(number & 0xFF)
                    ]
                }

            if padCharacterCount > 0 {
                data.removeLast((padCharacterCount + 1) * 3 / 4)
            }

            return Data(data)
        }
    }
}


extension Base85.Alphabet {
    public static let zeromq = try! Self(
        characters: [
            "0",
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "a",
            "b",
            "c",
            "d",
            "e",
            "f",
            "g",
            "h",
            "i",
            "j",
            "k",
            "l",
            "m",
            "n",
            "o",
            "p",
            "q",
            "r",
            "s",
            "t",
            "u",
            "v",
            "w",
            "x",
            "y",
            "z",
            "A",
            "B",
            "C",
            "D",
            "E",
            "F",
            "G",
            "H",
            "I",
            "J",
            "K",
            "L",
            "M",
            "N",
            "O",
            "P",
            "Q",
            "R",
            "S",
            "T",
            "U",
            "V",
            "W",
            "X",
            "Y",
            "Z",
            ".",
            "-",
            ":",
            "+",
            "=",
            "^",
            "!",
            "/",
            "*",
            "?",
            "&",
            "<",
            ">",
            "(",
            ")",
            "[",
            "]",
            "{",
            "}",
            "@",
            "%",
            "$",
            "#"
        ],
        startDelimeter: nil,
        endDelimeter: nil,
        fourZeros: nil,
        fourSpaces: nil
    )
}


/*
"!",
""",
"#",
"$",
"%",
"&",
"'",
"(",
")",
"*",
"+",
",",
"-",
".",
"/",
"0",
"1",
"2",
"3",
"4",
"5",
"6",
"7",
"8",
"9",
":",
";",
"<",
"=",
">",
"?",
"@",
"A",
"B",
"C",
"D",
"E",
"F",
"G",
"H",
"I",
"J",
"K",
"L",
"M",
"N",
"O",
"P",
"Q",
"R",
"S",
"T",
"U",
"V",
"W",
"X",
"Y",
"Z",
"[",
"\",
"]",
"^",
"_",
"`",
"a",
"b",
"c",
"d",
"e",
"f",
"g",
"h",
"i",
"j",
"k",
"l",
"m",
"n",
"o",
"p",
"q",
"r",
"s",
"t",
"u",
"v",
"w",
"x",
"y",
"z",
"{",
"|",
"}",
"~",


ZeroMQ
"0",
"1",
"2",
"3",
"4",
"5",
"6",
"7",
"8",
"9",
"a",
"b",
"c",
"d",
"e",
"f",
"g",
"h",
"i",
"j",
"k",
"l",
"m",
"n",
"o",
"p",
"q",
"r",
"s",
"t",
"u",
"v",
"w",
"x",
"y",
"z",
"A",
"B",
"C",
"D",
"E",
"F",
"G",
"H",
"I",
"J",
"K",
"L",
"M",
"N",
"O",
"P",
"Q",
"R",
"S",
"T",
"U",
"V",
"W",
"X",
"Y",
"Z",
".",
"-",
":",
"+",
"=",
"^",
"!",
"/",
"*",
"?",
"&",
"<",
">",
"(",
")",
"[",
"]",
"{",
"}",
"@",
"%",
"$",
"#"










 */
