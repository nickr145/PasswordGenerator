//
//  HapticManager.swift
//  PasswordGenerator
//
//  Created by Nicholas Rebello on 2024-09-15.
//

import Foundation
import UIKit

class HapticManager {
    static let shared = HapticManager()

    private init() {}

    func triggerLightImpact() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }

    func triggerMediumImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }

    func triggerHeavyImpact() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
}

