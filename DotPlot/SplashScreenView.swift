//
//  SplashScreenView.swift
//  DotPlot
//
//  Created by Saajidah Mohamed on 25/07/2024.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0

    var body: some View {
        VStack {
            if isActive {
                LoginView()
                    .transition(.opacity)
            } else {
                Text("DotPlot")
                    .font(.custom("Cochin", fixedSize: 50))
                    .fontWeight(.bold)
                    .foregroundColor(.clear)
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                       startPoint: .leading,
                                       endPoint: .trailing)
                        .mask(
                            Text("DotPlot")
                                .font(.custom("Cochin", fixedSize: 50))
                                .fontWeight(.bold)
                        )
                    )
                    .frame(width: 200, height: 100)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.0)) {
                            self.scale = 1.5
                            self.opacity = 0.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                self.isActive = true
                            }
                        }
                    }
            }
        }
      //  .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    SplashScreenView()
}
