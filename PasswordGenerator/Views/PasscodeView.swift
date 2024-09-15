//
//  PasscodeView.swift
//  PasswordGenerator
//
//  Created by Nicholas Rebello on 2024-09-15.
//

import SwiftUI

struct PasscodeView: View {
    @State private var enteredPasscode = ""
    private let correctPasscode = "1234" // Replace with actual passcode or verification mechanism
    @State private var isAuthenticated = false
    @State private var showError = false

    let columns = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
    ]

    let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", "⌫"]

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Passcode")
                .font(.title)
                .fontWeight(.semibold)

            // Display the entered passcode as dots
            HStack {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(index < enteredPasscode.count ? Color.black : Color.gray.opacity(0.3))
                        .frame(width: 15, height: 15)
                }
            }
            .padding(.vertical, 20)

            // Dial pad for entering the passcode
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(numbers, id: \.self) { number in
                    Button(action: {
                        handleButtonPress(number)
                    }) {
                        Text(number)
                            .font(.title)
                            .foregroundColor(number == "⌫" ? .red : .black)
                            .frame(width: 75, height: 75)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                    .disabled(number.isEmpty) // Disable the empty button spot
                }
            }
            .padding()

            if showError {
                Text("Incorrect Passcode")
                    .foregroundColor(.red)
                    .fontWeight(.bold)
                    .padding(.top, 10)
            }

            Spacer()

            if isAuthenticated {
                Text("Authenticated!")
                    .font(.title)
                    .foregroundColor(.green)
            }
        }
        .padding()
    }

    private func handleButtonPress(_ number: String) {
        if number == "⌫" {
            if !enteredPasscode.isEmpty {
                enteredPasscode.removeLast()
            }
        } else if enteredPasscode.count < 4 {
            enteredPasscode.append(number)

            if enteredPasscode.count == 4 {
                // Check if the passcode is correct
                if enteredPasscode == correctPasscode {
                    isAuthenticated = true
                } else {
                    showError = true
                    enteredPasscode = ""
                }
            }
        }
    }
}

#Preview {
    PasscodeView()
}
