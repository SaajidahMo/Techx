//
//  LoginView.swift
//  DotPlot
//
//  Created by Saajidah Mohamed on 25/07/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @AppStorage("log_status") private var logStatus: Bool = false
    
    var body: some View {
       // if isLoggedIn {
         //   ContentView()
      //  } else {
            VStack {
                Text("DotPlot")
                //.font(.largeTitle)
                //https://www.swiftyplace.com/blog/swiftui-font-and-texts
                    .font(.custom("Cochin", fixedSize: 48))
                    .fontWeight(.bold)
                    .foregroundColor(.clear)
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                       startPoint: .leading,
                                       endPoint: .trailing)
                        .mask(
                            Text("DotPlot")
                                .font(.custom("Cochin", fixedSize: 48))
                            //.font(.largeTitle)
                                .fontWeight(.bold)
                        ))
                
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12.0)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12.0)
                    .disableAutocorrection(true)
                
                Button(action: {
                    loginUser()
                    //isLoggedIn = true
                }) {
                    Text("SIGN IN")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(email.isEmpty || password.isEmpty ? Color.purple.opacity(0.5) : Color.purple)
                       // .background(Color.purple)
                        .cornerRadius(15.0)
                }
                .padding(.top, 20)
                .disabled(email.isEmpty || password.isEmpty)
                .alert(isPresented: $showAlert) {
                                    Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                                }
            }
            .padding()
      //  }
    }
    
    func loginUser(){
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
                return
            }
            
            if authResult != nil {
                isLoggedIn = true
                logStatus = true
            } else {
                alertMessage = "Account not found"
                showAlert = true
            }
        }
    }
}

#Preview {
    LoginView()
}
