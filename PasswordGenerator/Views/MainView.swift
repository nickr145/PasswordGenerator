//
//  MainView.swift
//  PasswordGenerator
//
//  Created by Nicholas Rebello on 2024-08-29.
//

import SwiftUI

struct MainView: View {
    @State var passwordLength: Double = 8.0
    @State var complexity: Int = 1
    @State var generatedPassword: String = ""
    @State var showPassword: Bool = false
    @State var passwordStrength: Double = 0.0
    @State var isGenerating: Bool = false
    @State var isTitleReduced: Bool = false
    @State private var showCopyAlert = false
    @State private var showSaveAlert = false
    @State private var showSaveSheet = false
    @State private var passwordName = ""

    @EnvironmentObject var passwordModel: PasswordModel

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.8)]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all) // Background gradient
            
            VStack(spacing: 20) {
                // Title
                Text("Secure Password Generator")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 30)
                    .scaleEffect(isTitleReduced ? 0.9 : 1.0) // Reduce title size if needed
                
                VStack(alignment: .leading, spacing: 20) {
                    // Password Length Slider
                    HStack {
                        Text("Password Length: \(Int(passwordLength))")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Slider(value: $passwordLength, in: 4...20, step: 1)
                        .accentColor(.blue)
                    
                    // Password Complexity Segmented Control
                    HStack {
                        Image(systemName: "shield")
                            .foregroundColor(.white)
                        Text("Password Complexity")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Picker("Complexity", selection: $complexity) {
                        Text("Low").tag(1)
                        Text("Medium").tag(2)
                        Text("High").tag(3)
                        Text("Very High").tag(4)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    
                }
                .padding()
                .background(BlurView(style: .systemThinMaterial)) // Apply blur to card
                .cornerRadius(15)
                .shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
                
                // Generate Button
                Button(action: {
                    withAnimation(.easeInOut) {
                        generatedPassword = passwordModel.generatePassword(len: Int(passwordLength), complexity: complexity, name: passwordName)
                        passwordStrength = passwordModel.testStrength(pwd: generatedPassword)
                        isTitleReduced = true
                    }
                }) {
                    Text("🔐 Generate Password")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(25)
                        .shadow(color: .blue.opacity(0.6), radius: 5, x: 0, y: 5)
                }
                .padding(.horizontal)
                .scaleEffect(isGenerating ? 1.05 : 1.0)
                .onAppear {
                    isGenerating = false
                }
                
                // Generated Password Display
                if !generatedPassword.isEmpty {
                    VStack(alignment: .center, spacing: 20) {
                        Text("Generated Password")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        if showPassword {
                            Text(generatedPassword)
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                        } else {
                            Text(String(repeating: "*", count: generatedPassword.count))
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                        }
                        
                        // Password Strength Progress Bar
                        VStack {
                            Text("Password Strength")
                                .font(.headline)
                                .foregroundColor(.white)
                            ProgressView(value: passwordStrength)
                                .progressViewStyle(LinearProgressViewStyle(tint: passwordStrength >= 0.75 ? .green : passwordStrength >= 0.5 ? .orange : .red))
                                .scaleEffect(x: 1, y: 4, anchor: .center)
                                .padding(.horizontal)
                        }
                        
                        // Show/Hide Password Toggle
                        Toggle("Show Password", isOn: $showPassword)
                            .foregroundColor(.white)
                        
                        // Save Button
                        Button(action: {
                            showSaveSheet = true
                        }) {
                            Text("💾 Save Password")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.yellow]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(25)
                                .shadow(color: .orange.opacity(0.6), radius: 5, x: 0, y: 5)
                        }
                        .padding(.horizontal)
                        .sheet(isPresented: $showSaveSheet) {
                            ZStack {
                                LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.8)]),
                                               startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .edgesIgnoringSafeArea(.all)
                                VStack {
                                    Text("Save Password")
                                        .font(.headline)
                                        .padding()
                                    
                                    TextField("Enter password name", text: $passwordName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                    
                                    Button("Save") {
                                        let newPassword = SavedPassword(name: passwordName, password: generatedPassword)
                                        passwordModel.history.append(newPassword)
                                        passwordName = ""  // Clear the input field
                                        showSaveSheet = false
                                    }
                                    .padding()
                                    .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.teal]), startPoint: .leading, endPoint: .trailing))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(color: .green.opacity(0.6), radius: 5, x: 0, y: 5)
                                }
                                .padding()
                            }
                        }
                        
                    }
                    .padding()
                    .background(BlurView(style: .systemThinMaterial)) // Apply blur effect
                    .cornerRadius(15)
                    .shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                    .transition(.slide) // Add a transition when password is generated
                }
                
                // Copy to Clipboard Button (only visible when password is generated)
                if !generatedPassword.isEmpty {
                    Button(action: {
                        UIPasteboard.general.string = generatedPassword
                        showCopyAlert = true // Show the alert
                    }) {
                        Text("📋 Copy to Clipboard")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.teal]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(25)
                            .shadow(color: .green.opacity(0.6), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    .alert(isPresented: $showCopyAlert) {
                        Alert(
                            title: Text("Copied!"),
                            message: Text("The password has been copied to your clipboard."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }
            .padding(.bottom, 50)
        }
    }
}






