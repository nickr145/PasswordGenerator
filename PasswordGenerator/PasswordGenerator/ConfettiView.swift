//
//  ConfettiView.swift
//  PasswordGenerator
//
//  Created by Nicholas Rebello on 2024-08-29.
//

import SwiftUI

struct ConfettiView: View {
    @State private var particles: [Particle] = []
    let duration: Double
    @State private var startTime: Date = Date()
    
    struct Particle {
        var id: UUID = UUID()
        var position: CGPoint
        var velocity: CGPoint
        var lifetime: Double
        var size: CGFloat
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles, id: \.id) { particle in
                    Circle()
                        .fill(Color.random)
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.position)
                        .animation(.linear(duration: particle.lifetime).repeatForever(autoreverses: false), value: particle.position)
                        .onAppear {
                            let targetPosition = CGPoint(x: geometry.size.width * CGFloat.random(in: 0...1), y: geometry.size.height)
                            let velocity = CGPoint(x: targetPosition.x - particle.position.x, y: targetPosition.y - particle.position.y)
                            DispatchQueue.main.asyncAfter(deadline: .now() + particle.lifetime) {
                                if let index = particles.firstIndex(where: { $0.id == particle.id }) {
                                    particles.remove(at: index)
                                }
                            }
                            particles = particles.map {
                                var updated = $0
                                updated.position = CGPoint(x: updated.position.x + velocity.x * CGFloat(duration), y: updated.position.y + velocity.y * CGFloat(duration))
                                return updated
                            }
                        }
                }
            }
            .onAppear {
                generateParticles(geometry: geometry)
            }
        }
    }

    private func generateParticles(geometry: GeometryProxy) {
        particles = (0..<100).map { _ in
            Particle(
                position: CGPoint(x: geometry.size.width * CGFloat.random(in: 0...1), y: -10),
                velocity: CGPoint(x: CGFloat.random(in: -1...1), y: CGFloat.random(in: 1...3)),
                lifetime: Double.random(in: 2...4),
                size: CGFloat.random(in: 5...10)
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            particles.removeAll()
        }
    }
}

extension Color {
    static var random: Color {
        return Color(hue: Double.random(in: 0...1), saturation: 0.8, brightness: 0.8)
    }
}


#Preview {
    ConfettiView(duration: 5.0)
}
