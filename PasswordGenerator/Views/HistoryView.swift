//
//  HistoryView.swift
//  PasswordGenerator
//
//  Created by Nicholas Rebello on 2024-08-29.
//

//
//  HistoryView.swift
//  PasswordGenerator
//
//  Created by Nicholas Rebello on 2024-08-29.
//

import SwiftUI

struct HistoryView: View {
    
    @EnvironmentObject var passwordModel: PasswordModel
    @State private var showingClearHistoryAlert = false
    @State private var isAuthenticated = false
    @State private var showingAuthenticationErrorAlert = false
    
    private func delete(at offsets: IndexSet) {
        withAnimation {
            passwordModel.history.remove(atOffsets: offsets)
            HapticManager.shared.triggerMediumImpact()  // Add haptic feedback when deleting
        }
    }
    
    private func clearHistory() {
        withAnimation {
            passwordModel.clearHistory()
            HapticManager.shared.triggerHeavyImpact()  // Add haptic feedback for clear history
        }
    }
    
    private func checkAuthentication() {
        AuthenticationManager.shared.authenticateWithBiometrics { success in
            if success {
                isAuthenticated = true
                HapticManager.shared.triggerLightImpact()  // Add haptic feedback on successful authentication
            } else {
                showingAuthenticationErrorAlert = true
                HapticManager.shared.triggerHeavyImpact()  // Haptic feedback on authentication failure
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.8)]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            
            if isAuthenticated {
                VStack {
                    // Title
                    Text("Password History")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 30)
                    
                    if !passwordModel.history.isEmpty {
                        // List of Saved Passwords
                        List {
                            ForEach(passwordModel.history) { savedPassword in
                                VStack(alignment: .leading) {
                                    Text(savedPassword.name)
                                        .font(.headline)
                                    Text(savedPassword.password)
                                        .font(.body)
                                }
                                .transition(.opacity)
                            }
                            .onDelete(perform: delete)  // Apply haptic on delete
                        }
                        .animation(.default, value: passwordModel.history)
                        
                        Button(action: {
                            showingClearHistoryAlert = true
                        }) {
                            Text("Clear History")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(10)
                                .shadow(color: .red.opacity(0.6), radius: 5, x: 0, y: 5)
                        }
                        .padding()
                        .alert(isPresented: $showingClearHistoryAlert) {
                            Alert(
                                title: Text("Clear History"),
                                message: Text("Are you sure you want to clear all saved passwords? This action cannot be undone."),
                                primaryButton: .destructive(Text("Clear")) {
                                    clearHistory()  // Apply haptic when clearing history
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    } else {
                        GeometryReader { geometry in
                            VStack {
                                Text("Time to Start Creating Some Secure Passwords!")
                                    .fontWeight(.semibold)
                                    .padding()
                                    .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
                                    .cornerRadius(10)
                                    .shadow(color: .red.opacity(0.6), radius: 5, x: 0, y: 5)
                                    .frame(width: geometry.size.width * 0.8) // Centered with some margin
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure it's centered in the available space
                        }
                        .padding(.horizontal, 20) // Additional padding around the GeometryReader
                    }
                }
                .padding(.bottom, 50)
            } else {
                VStack {
                    Text("Authentication Required")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                    
                    Text("Please authenticate to view the history.")
                        .foregroundColor(.white)
                        .padding()
                    
                    Button(action: checkAuthentication) {
                        Text("Authenticate")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.teal]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(25)
                            .shadow(color: .green.opacity(0.6), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            checkAuthentication()
        }
        .alert(isPresented: $showingAuthenticationErrorAlert) {
            Alert(
                title: Text("Authentication Failed"),
                message: Text("Authentication failed. Please check your biometric settings or try again."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    let model = PasswordModel()
    model.history = [
        SavedPassword(name: "Password1!", password: "123SecurePass"),
        SavedPassword(name: "Password2", password: "My$trongPass#1")
    ]
    
    return HistoryView()
        .environmentObject(model)
}


