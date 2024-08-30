//
//  PasswordGeneratorApp.swift
//  PasswordGenerator
//
//  Created by Nicholas Rebello on 2024-04-23.
//

import SwiftUI

@main
struct PasswordGeneratorApp: App {
    @StateObject var passwordModel = PasswordModel() // Initialize the PasswordModel

    var body: some Scene {
        WindowGroup {
            StartingView()
                .environmentObject(passwordModel) // Pass it to the environment
        }
    }
}



