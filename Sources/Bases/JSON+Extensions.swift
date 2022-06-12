//
//  JSON+Extensions.swift
//  Bases
//
//  Created by Przemek Ambroży on 12.06.2022.
//  Copyright © 2022 Przemysław Ambroży
//

import Foundation

// MARK: DataDecodingStrategy

extension JSONDecoder.DataDecodingStrategy {
    /// Returns the strategy that decodes data using Base 16 decoding.
    /// - Parameter alphabet: The alphabet to use to decode the string.
    public static func base16(alphabet: Base16.Alphabet) -> Self {
        Self.custom { decoder in
            let container = try decoder.singleValueContainer()
            let text = try container.decode(String.self)

            do {
                return try Base16.Decoder(ignoreUnknownCharacters: true, alphabet: alphabet).decode(text)
            } catch {
                throw Swift.DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Cannot decode the Base-16 string"
                )
            }
        }
    }

    /// Returns the strategy that decodes data using Base 32 decoding.
    /// - Parameter alphabet: The alphabet to use to decode the string.
    public static func base32(alphabet: Base32.Alphabet) -> Self {
        Self.custom { decoder in
            let container = try decoder.singleValueContainer()
            let text = try container.decode(String.self)

            do {
                return try Base32.Decoder(alphabet: alphabet).decode(text)
            } catch {
                throw Swift.DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Cannot decode the Base-32 string"
                )
            }
        }
    }

    /// Returns the strategy that decodes data using Base 85 decoding.
    /// - Parameter alphabet: The alphabet to use to decode the string.
    public static func base85(alphabet: Base85.Alphabet) -> Self {
        Self.custom { decoder in
            let container = try decoder.singleValueContainer()
            let text = try container.decode(String.self)

            do {
                return try Base85.Decoder(alphabet: alphabet).decode(text)
            } catch {
                throw Swift.DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Cannot decode the Base-85 string"
                )
            }
        }
    }
}

// MARK: DataEncodingStrategy

extension JSONEncoder.DataEncodingStrategy {
    /// Returns the strategy that encodes data using Base 16 encoding.
    /// - Parameter alphabet: The alphabet to use to encode the data.
    public static func base16(alphabet: Base16.Alphabet) -> Self {
        Self.custom { data, encoder in
            let encoded = Base16.Encoder(alphabet: alphabet).encode(data)
            var container = encoder.singleValueContainer()
            try container.encode(encoded)
        }
    }

    /// Returns the strategy that encodes data using Base 32 encoding.
    /// - Parameter alphabet: The alphabet to use to encode the data.
    public static func base32(alphabet: Base32.Alphabet) -> Self {
        Self.custom { data, encoder in
            let encoded = Base32.Encoder(alphabet: alphabet).encode(data)
            var container = encoder.singleValueContainer()
            try container.encode(encoded)
        }
    }

    /// Returns the strategy that encodes data using Base 85 encoding.
    /// - Parameter alphabet: The alphabet to use to encode the data.
    public static func base85(alphabet: Base85.Alphabet) -> Self {
        Self.custom { data, encoder in
            let encoded = Base85.Encoder(alphabet: alphabet).encode(data)
            var container = encoder.singleValueContainer()
            try container.encode(encoded)
        }
    }
}
