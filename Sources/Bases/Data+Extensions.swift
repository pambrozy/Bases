//
//  File.swift
//  
//
//  Created by Przemek Ambroży on 12/06/2022.
//

import Foundation

// MARK: Data encoding

extension Data {
    /// Returns a Base-16 encoded string
    /// - Parameter alphabet: The alphabet to use to encode the string.
    /// - Returns: The Base-16 encoded string.
    public func base16EncodedString(alphabet: Base16.Alphabet) -> String {
        Base16.Encoder(alphabet: alphabet).encode(self)
    }

    /// Returns a Base-32 encoded string
    /// - Parameter alphabet: The alphabet to use to encode the string.
    /// - Returns: The Base-32 encoded string.
    public func base32EncodedString(alphabet: Base32.Alphabet) -> String {
        Base32.Encoder(alphabet: alphabet).encode(self)
    }

    /// Returns a Base-85 encoded string
    /// - Parameter alphabet: The alphabet to use to encode the string.
    /// - Returns: The Base-85 encoded string.
    public func base85EncodedString(alphabet: Base85.Alphabet) -> String {
        Base85.Encoder(alphabet: alphabet).encode(self)
    }
}

// MARK: Data decoding

extension Data {
    /// Initializes a data object with the given Base16 encoded string.
    /// - Parameters:
    ///   - base16String: A Base-16 encoded string.
    ///   - alphabet: The alphabet to use to decode the string.
    public init?(
        base16Encoded base16String: String,
        alphabet: Base16.Alphabet
    ) {
        do {
            self = try Base16.Decoder(ignoreUnknownCharacters: true, alphabet: alphabet).decode(base16String)
        } catch {
            return nil
        }
    }

    /// Initializes a data object with the given Base16 encoded data.
    /// - Parameters:
    ///   - base16Data: A Base16, UTF-8 encoded data object.
    ///   - alphabet: The alphabet to use to decode the data.
    public init?(
        base16Encoded base16Data: Data,
        alphabet: Base16.Alphabet
    ) {
        guard let base16String = String(data: base16Data, encoding: .utf8),
              let data = try? Base16.Decoder(
                ignoreUnknownCharacters: true,
                alphabet: alphabet
              ).decode(base16String)
        else {
            return nil
        }

        self = data
    }

    /// Initializes a data object with the given Base32 encoded string.
    /// - Parameters:
    ///   - base32String: A Base-32 encoded string.
    ///   - alphabet: The alphabet to use to decode the string.
    public init?(
        base32Encoded base32String: String,
        alphabet: Base32.Alphabet
    ) {
        do {
            self = try Base32.Decoder(alphabet: alphabet).decode(base32String)
        } catch {
            return nil
        }
    }

    /// Initializes a data object with the given Base32 encoded data.
    /// - Parameters:
    ///   - base32Data: A Base32, UTF-8 encoded data object.
    ///   - alphabet: The alphabet to use to decode the data.
    public init?(
        base32Encoded base32Data: Data,
        alphabet: Base32.Alphabet
    ) {
        guard let base32String = String(data: base32Data, encoding: .utf8),
              let data = try? Base32.Decoder(alphabet: alphabet).decode(base32String)
        else {
            return nil
        }

        self = data
    }

    /// Initializes a data object with the given Base85 encoded string.
    /// - Parameters:
    ///   - base85String: A Base-85 encoded string.
    ///   - alphabet: The alphabet to use to decode the string.
    public init?(
        base85Encoded base85String: String,
        alphabet: Base85.Alphabet
    ) {
        do {
            self = try Base85.Decoder(alphabet: alphabet).decode(base85String)
        } catch {
            return nil
        }
    }

    /// Initializes a data object with the given Base85 encoded data.
    /// - Parameters:
    ///   - base85Data: A Base85, UTF-8 encoded data object.
    ///   - alphabet: The alphabet to use to decode the data.
    public init?(
        base85Encoded base85Data: Data,
        alphabet: Base85.Alphabet
    ) {
        guard let base85String = String(data: base85Data, encoding: .utf8),
              let data = try? Base85.Decoder(alphabet: alphabet).decode(base85String)
        else {
            return nil
        }

        self = data
    }
}
