# Usage

Learn how to use the encoders and decoders included in this package.

## Encoding data
To encode data, firstly create an encoder, providing an alphabet
to the initializer ``Base32/Encoder/init(alphabet:)``:
```swift
let encoder = Base32.Encoder(alphabet: .rfc4648)
```

Then use the ``Base32/Encoder/encode(_:)`` method:
```swift
let encodedString = encoder.encode(dataToEncode)
```

Alternatively, you can use the `base32EncodedString(alphabet:)` method:
```swift
let encodedString = dataToEncode.base32EncodedString(alphabet: .rfc4648)
```

## Decoding data
To decode data, start by creating a decoder, providing an alphabet
to the initializer ``Base32/Decoder/init(alphabet:)``:
```swift
let decoder = Base32.Decoder(alphabet: .rfc4648)
```

The use the ``Base32/Decoder/decode(_:)`` method:
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

## Using with JSONEncoder and JSONDecoder
You can use the encoders and decoders from this package in `JSONEncoder` and `JSONDecoder`.

In the next few examples we will use the example `Codable` struct:
```swift
struct Example: Codable {
    let data: Data
}
```

Let's create an instance of this struct:
```swift
let example = Example(data: Data([65, 66, 67]))
```

### Encoding
To encode the struct, create an instance of JSONEncoder and
set its `dataEncodingStrategy` to an appropriate encoder:
```swift
let encoder = JSONEncoder()
encoder.dataEncodingStrategy = .base32(alphabet: .rfc4648)
```

Then encode the data:
```swift
do {
    let encoded = try encoder.encode(decoded)
    print(String(decoding: encoded, as: UTF8.self))
    // Prints: {"data":"IFBEG==="}
} catch {
    print("Cannot encode: \(error.localizedDescription)")
}
```

### Decoding
To decode a JSON string, create an instance of JSONDecoder and
set its `dataDecodingStrategy` to an appropriate decoder:
```swift
let decoder = JSONDecoder()
decoder.dataDecodingStrategy = .base32(alphabet: .rfc4648)
```

Then decode the data:
```swift
do {
    let decoded = try decoder.decode(Example.self, from: validData)
    print(Array(decoded.data))
    // Prints: [65, 66, 67]
} catch {
    print("Cannot decode: \(error.localizedDescription)")
}
```
