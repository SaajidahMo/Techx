//
//  SettingsView.swift
//  DotPlot
//
//  Created by Saajidah Mohamed on 26/07/2024.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @AppStorage("log_status") private var logStatus: Bool = false
    @State private var navigateToLogin = false

    var body: some View {
        NavigationView {
            VStack {
                if navigateToLogin {
                    LoginView()
                        .transition(.opacity)
                } else {
                    VStack {
                        Spacer()
                        
                        Button(action: logout) {
                            Text("Logout")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 220, height: 60)
                                .background(Color.red)
                                .cornerRadius(15.0)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    }
                    .animation(.easeInOut, value: navigateToLogin)
                }
                
            } .navigationTitle("Settings")
        }
    }

    func logout() {
        logStatus = false
        try? Auth.auth().signOut()
        navigateToLogin = true
    }
}

#Preview {
    SettingsView()
}
