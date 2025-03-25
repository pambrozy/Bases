# Bases

![build on macos](https://github.com/pambrozy/Bases/actions/workflows/macos.yaml/badge.svg)
![build on linux](https://github.com/pambrozy/Bases/actions/workflows/linux.yaml/badge.svg)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpambrozy%2FBases%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/pambrozy/Bases)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpambrozy%2FBases%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/pambrozy/Bases)

A package for encoding and decoding data using Base16, Base32, Base64 and Base85 encodings.

See the [documentation](https://pambrozy.github.io/Bases/documentation/bases/).

## Usage

### Encoding data
To encode data, firstly create an encoder, providing an alphabet
to the initializer `init(alphabet:)`:
```swift
let encoder = Base32.Encoder(alphabet: .rfc4648)
```

Then use the `encode(_:)` method:
```swift
let encodedString = encoder.encode(dataToEncode)
```

Alternatively, you can use the `base32EncodedString(alphabet:)` method of `Data`:
```swift
let encodedString = dataToEncode.base32EncodedString(alphabet: .rfc4648)
```

### Decoding data
To decode data, start by creating a decoder, providing an alphabet
to the initializer `init(alphabet:)`:
```swift
let decoder = Base32.Decoder(alphabet: .rfc4648)
```

Then use the `decode(_:)` method:
```swift
do {
    let decodedData = try decoder.decode(stringToDecode)
} catch {
    print("Cannot decode: \(error.localizedDescription)")
}
```

Alternatively, use one of the `Data` initializers:
```swift
let decodedFromString = Data(base32Encoded: stringToDecode, alphabet: .rfc4648)

let decodedFromData = Data(base32Encoded: dataToDecode, alphabet: .rfc4648)
```

### Using with JSONEncoder and JSONDecoder
You can use the encoders and decoders from this package in `JSONEncoder` and `JSONDecoder`.

In the next few examples we will use the `Example` struct:
```swift
struct Example: Codable {
    let data: Data
}
```

Let's create an instance of it:
```swift
let example = Example(data: Data([65, 66, 67]))
```

#### Encoding
To encode the struct, create an instance of `JSONEncoder` and
set its `dataEncodingStrategy` to an appropriate encoder:
```swift
let encoder = JSONEncoder()
encoder.dataEncodingStrategy = .base32(alphabet: .rfc4648)
```

Then encode the data:
```swift
do {
    let encodedExample = try encoder.encode(example)
    print(String(decoding: encodedExample, as: UTF8.self))
    // Prints: {"data":"IFBEG==="}
} catch {
    print("Cannot encode: \(error.localizedDescription)")
}
```

#### Decoding
To decode a JSON string, create an instance of `JSONDecoder` and
set its `dataDecodingStrategy` to an appropriate decoder:
```swift
let decoder = JSONDecoder()
decoder.dataDecodingStrategy = .base32(alphabet: .rfc4648)
```

Then decode the data:
```swift
do {
    let decodedExample = try decoder.decode(Example.self, from: encodedExample)
    print(Array(decodedExample.data))
    // Prints: [65, 66, 67]
} catch {
    print("Cannot decode: \(error.localizedDescription)")
}
```

## License
Bases is released under the 2-Clause BSD License. See [LICENSE](LICENSE) for details.
