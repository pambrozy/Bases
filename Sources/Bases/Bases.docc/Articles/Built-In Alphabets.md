# Built-In Alphabets

See the list of alphabets provided with this package.

## Base16

| Alphabet                      | Characters    |
| -                             | -             |
| ``Base16/Alphabet/lowercase`` | `0` - `f`     |
| ``Base16/Alphabet/uppercase`` | `0` - `F`     |

## Base32

| Alphabet                      | Characters    | Padding   |
| -                             | -             | -         |
| ``Base32/Alphabet/rfc4648``   | `A` - `7`     | `=`       |
| ``Base32/Alphabet/zBase32``   | `y` - `9`     | none      |
| ``Base32/Alphabet/crockford`` | `0` - `Z`     | none      |
| ``Base32/Alphabet/base32hex`` | `0` - `V`     | `=`       |
| ``Base32/Alphabet/geohash``   | `0` - `z`     | none      |
| ``Base32/Alphabet/wordSafe``  | `2` - `x`     | none      |

## Base64
| Alphabet                              | Characters    | Padding   | Line spacing                  |
| -                                     | -             | -         | -                             |
| ``Base64/Alphabet/standard``          | `A` -  `/`    | `=`       | none                          |
| ``Base64/Alphabet/base64url``         | `A` - `_`     | `=`       | none                          |
| ``Base64/Alphabet/utf7``              | `A` - `/`     | none      | none                          |
| ``Base64/Alphabet/imapMailboxNames``  | `A` - `,`     | none      | none                          |
| ``Base64/Alphabet/mime``              | `A` - `/`     | `=`       | `\r\n` every 76 characters    |

## Base85
| Alphabet                          | Characters    | Start delimeter   | End delimeter | Four zeros    | Four spaces   |
| -                                 | -             | -                 | -             | -             | -             |
| ``Base85/Alphabet/ascii``         | `!` - `u`     | none              | none          | none          | none          |
| ``Base85/Alphabet/btoaLike``      | `!` - `u`     | none              | none          | `z`           | `y`           |
| ``Base85/Alphabet/adobeAscii85``  | `!` - `u`     | `<~`              | `~>`          | `z`           | none          |
| ``Base85/Alphabet/rfc1924Like``   | `0` - `~`     | none              | none          | none          | none          |
| ``Base85/Alphabet/z85``           | `0` - `#`     | none              | none          | none          | none          |

### More info

To see how every alphabet is defined, check the tests.
For example, the ``Base32/Alphabet/crockford`` alphabet is defined
in the `testBuiltInCrockfordAlphabet` method in the `Bases32Tests` class:
```swift
let crockford = try Base32.Alphabet(
    characters: [
        ["0", "o", "O"],
        ["1", "i", "I", "l", "L"],
        ["2", "2"],
        ["3", "3"],
        ["4", "4"],
        ["5", "5"],
        ["6", "6"],
        ["7", "7"],
        ["8", "8"], ["9", "9"], ["A", "a"], ["B", "b"],
        ["C", "c"], ["D", "d"], ["E", "e"], ["F", "f"],
        ["G", "g"], ["H", "h"], ["J", "j"], ["K", "k"],
        ["M", "m"], ["N", "n"], ["P", "p"], ["Q", "q"],
        ["R", "r"], ["S", "s"], ["T", "t"], ["V", "v"],
        ["W", "w"], ["X", "x"], ["Y", "y"], ["Z", "z"]
    ],
    padding: nil
)
```
It is able to decode any of the `0`, `o`, `O` characters as a value of zero.
