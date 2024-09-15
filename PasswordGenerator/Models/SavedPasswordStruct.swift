//
//  SavedPasswordStruct.swift
//  PasswordGenerator
//
//  Created by Nicholas Rebello on 2024-08-29.
//

import Foundation

struct SavedPassword: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let password: String
    
    static func == (lhs: SavedPassword, rhs: SavedPassword) -> Bool {
        return lhs.id == rhs.id
    }
}
