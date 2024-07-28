//
//  DotPlotApp.swift
//  DotPlot
//
//  Created by Saajidah Mohamed on 25/07/2024.
// https://console.firebase.google.com/u/0/project/dotplot-75882/overview

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct DotPlotApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
               // SplashScreenView()
                  ContentView()
            }
        }
    }
}
