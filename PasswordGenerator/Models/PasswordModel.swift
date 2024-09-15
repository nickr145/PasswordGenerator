//
//  PasswordModel.swift
//  PasswordGenerator
//
//  Created by Nicholas Rebello on 2024-08-29.
//

import Foundation

class PasswordModel: ObservableObject {
    
    let pwdCap = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let pwdLow = "abcdefghijklmnopqrstuvwxyz"
    let pwdSym = "`~!@#$%^&*()-_=+[]{}|;':\"\\,./<>?"
    let pwdNum = "1234567890"
    
    @Published var password: String = ""
    @Published var history: [SavedPassword] = [] {
        didSet {
            saveHistory()
        }
    }

    let historyKey = "password_history"

    init() {
        loadHistory()
    }
    
    // Test the strength of the generated password
    func testStrength(pwd: String) -> Double {
        let lengthFactor = Double(pwd.count) / 20.0
        
        let hasUppercase = pwd.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil
        let hasLowercase = pwd.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil
        let hasNumbers = pwd.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
        let hasSymbols = pwd.rangeOfCharacter(from: CharacterSet.symbols.union(.punctuationCharacters)) != nil
        
        let varietyFactor = (hasUppercase ? 0.25 : 0.0) +
                            (hasLowercase ? 0.25 : 0.0) +
                            (hasNumbers ? 0.25 : 0.0) +
                            (hasSymbols ? 0.25 : 0.0)
        
        return lengthFactor * varietyFactor
    }
    
    // Generate password and add it to history
    func generatePassword(len: Int, complexity: Int, name: String) -> String {
        var characterSet = pwdLow

        if complexity >= 2 {
            characterSet += pwdCap
        }
        if complexity >= 3 {
            characterSet += pwdNum
        }
        if complexity >= 4 {
            characterSet += pwdSym
        }

        var password = ""
        for _ in 0..<len {
            let randomIndex = Int(arc4random_uniform(UInt32(characterSet.count)))
            let randomCharacter = characterSet[characterSet.index(characterSet.startIndex, offsetBy: randomIndex)]
            password.append(randomCharacter)
        }

        return password
    }


    
    // MARK: - History Management
    
    // Save the history array to UserDefaults
    func saveHistory() {
        if let encodedData = try? JSONEncoder().encode(history) {  // Use SavedPassword instead of String
            UserDefaults.standard.set(encodedData, forKey: historyKey)
        }
    }

    // Load the history array from UserDefaults
    func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: historyKey),
           let savedHistory = try? JSONDecoder().decode([SavedPassword].self, from: data) {
            history = savedHistory  // SavedPassword array
        }
    }
    
    // Clear history
    func clearHistory() {
        history.removeAll()
    }
}
