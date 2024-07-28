//
//  ContentView.swift
//  DotPlot
//
//  Created by Saajidah Mohamed on 25/07/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @StateObject var patientsViewModel = PatientsViewModel()
    @State private var isLoggedIn: Bool = false
    @AppStorage("log_status") private var logStatus: Bool = false
    
    
    var body: some View {
        if logStatus == true {
      //  Group {
      //  if isLoggedIn {
            TabView {
               HomeView()
                     .environmentObject(patientsViewModel)
                    .tabItem { Label("Home", systemImage:"globe.europe.africa")}
                
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gear")}
            }
            .accentColor(.purple)
        } else {
            // User not logged in, directs user to the logo
            SplashScreenView()
        }
        
          /**  VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding() */
        }
       /** .onAppear {
                   checkLoginStatus()
               }
//    }

    func checkLoginStatus() {
            if let _ = Auth.auth().currentUser {
                isLoggedIn = true
            } else {
                isLoggedIn = false
            }
        } */
    }

#Preview {
    ContentView()
}
