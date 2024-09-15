//
//  EncryptionUtils.swift
//  PasswordGenerator
//
//  Created by Nicholas Rebello on 2024-09-14.
//

import Foundation
import CryptoKit

// Utility functions for encryption and decryption
func encrypt(data: Data, using key: SymmetricKey) -> Data? {
    let sealedBox = try? AES.GCM.seal(data, using: key)
    return sealedBox?.combined
}

func decrypt(data: Data, using key: SymmetricKey) -> Data? {
    guard let sealedBox = try? AES.GCM.SealedBox(combined: data) else { return nil }
    return try? AES.GCM.open(sealedBox, using: key)
}

