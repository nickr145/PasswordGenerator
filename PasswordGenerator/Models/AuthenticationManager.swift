//
//  AuthenticationManager.swift
//  PasswordGenerator
//
//  Created by Nicholas Rebello on 2024-09-15.
//

import LocalAuthentication

class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    private init() {}
    
    func authenticateWithBiometrics(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        // Check if biometric authentication is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate to view your password history."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        completion(true)
                    } else {
                        // Handle specific authentication error
                        completion(false)
                    }
                }
            }
        } else {
            // Biometrics not available
            DispatchQueue.main.async {
                completion(false)
            }
        }
    }
}


