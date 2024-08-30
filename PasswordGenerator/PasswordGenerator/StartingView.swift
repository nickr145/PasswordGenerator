//
//  StartingView.swift
//  PasswordGenerator
//
//  Created by Nicholas Rebello on 2024-08-29.
//

import SwiftUI

struct StartingView: View {
    @State private var navigateToMainView = false
    @State private var navigateToHistoryView = false
    @State private var scale: CGFloat = 1.0
    @State private var animationActive = true
    
    @EnvironmentObject var passwordModel: PasswordModel
    
    private func startPulsingAnimation() {
        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            scale = 1.2
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.8)]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Animated Cat GIF
                    GIFImageView(gifName: "pusheenCat")
                        .frame(width: 200, height: 200)
                        .scaleEffect(scale)
                        .padding()
                        .onAppear {
                            startPulsingAnimation()
                        }
                    
                    // Title
                    Text("Welcome to the Password Generator")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom, 50)
                        .frame(alignment: .center)
                    
                    // Start Button
                    Button(action: {
                        withAnimation {
                            navigateToMainView = true
                        }
                    }) {
                        Text("Start")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.teal]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(25)
                            .shadow(color: .green.opacity(0.6), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    .background(
                        NavigationLink(destination: MainView(), isActive: $navigateToMainView) {
                            EmptyView()
                        }
                    )
                    // History Button
                    Button(action: {
                        withAnimation {
                            navigateToHistoryView = true
                        }
                    }) {
                        Text("Show History")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.teal]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(25)
                            .shadow(color: .green.opacity(0.6), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    .background(
                        NavigationLink(destination: HistoryView(), isActive: $navigateToHistoryView) {
                            EmptyView()
                        }
                        
                    )
                }
                .padding()
            }
        }
    }
}



struct StartingView_Previews: PreviewProvider {
    static var previews: some View {
        StartingView()
    }
}

