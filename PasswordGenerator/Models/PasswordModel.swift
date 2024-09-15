import Foundation
import CryptoKit

class PasswordModel: ObservableObject {

    let pwdCap = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let pwdLow = "abcdefghijklmnopqrstuvwxyz"
    let pwdSym = "~!@#$%^&*()-_=+[]{}|;':\"\\,./<>?"
    let pwdNum = "1234567890"
    
    @Published var password: String = ""
    @Published var history: [SavedPassword] = [] {
        didSet {
            saveHistory()
        }
    }

    private let historyKey = "password_history"
    private let keychainKey = "encryption_key"

    private var encryptionKey: SymmetricKey {
        get {
            if let keyData = KeychainHelper.load(key: keychainKey) {
                return SymmetricKey(data: keyData)
            } else {
                let newKey = SymmetricKey(size: .bits256)
                let keyData = newKey.withUnsafeBytes { Data($0) }
                KeychainHelper.save(key: keychainKey, data: keyData)
                return newKey
            }
        }
    }

    private func encryptPassword(_ password: String) -> Data? {
        let passwordData = password.data(using: .utf8)!
        return encrypt(data: passwordData, using: encryptionKey)
    }
    
    private func decryptPassword(_ data: Data) -> String? {
        guard let decryptedData = decrypt(data: data, using: encryptionKey) else { return nil }
        return String(data: decryptedData, encoding: .utf8)
    }

    init() {
        loadHistory()
    }
    
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
        
        guard let encryptedPasswordData = encryptPassword(password) else { return password }
        let encryptedPassword = encryptedPasswordData.base64EncodedString()
        let newPassword = SavedPassword(name: name, password: encryptedPassword)
        history.append(newPassword)

        return password
    }
    
    func saveHistory() {
        do {
            let encodedData = try JSONEncoder().encode(history)
            UserDefaults.standard.set(encodedData, forKey: historyKey)
        } catch {
            print("Failed to encode history: \(error)")
        }
    }

    func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: historyKey) {
            do {
                let savedHistory = try JSONDecoder().decode([SavedPassword].self, from: data)
                history = savedHistory.map { savedPassword in
                    var decryptedPassword = ""
                    if let encryptedData = Data(base64Encoded: savedPassword.password) {
                        decryptedPassword = decryptPassword(encryptedData) ?? ""
                    }
                    return SavedPassword(name: savedPassword.name, password: decryptedPassword)
                }
            } catch {
                print("Failed to decode history: \(error)")
            }
        }
    }
    
    func clearHistory() {
        history.removeAll()
    }
}
