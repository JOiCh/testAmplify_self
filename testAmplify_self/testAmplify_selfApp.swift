//
//  testAmplify_selfApp.swift
//  testAmplify_self
//
//  Created by JOi Chao on 2022/11/14.
//
import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import SwiftUI

@main
struct testAmplify_selfApp: App {
    @ObservedObject var authSessionManager = AuthSessionManager() //class實例
//    @StateObject var listViewModel: ListViewModel = ListViewModel()
    
    init() {
        configureAmplify()
           do {
               try Amplify.add(plugin: AWSCognitoAuthPlugin())
               try Amplify.add(plugin: AWSAPIPlugin())
               try Amplify.configure()
               print("Amplify configured with API and Auth plugin")
           } catch {
               print("Failed to initialize Amplify with \(error)")
           }
       }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .navigationViewStyle(StackNavigationViewStyle()) // 適應ipad
//                .environmentObject(listViewModel)
                .environmentObject(authSessionManager)
        }
    }
    
    private func configureAmplify() {
        do {
            print("=>進configureAmplify了。")
            // Amplify.Logging.logLevel = .verbose
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.configure()
            print("Amplify configured with auth plugin")
            Task {
                await authSessionManager.getCurrentAuthUser()
            }
            
        } catch {
            print("Failed to initialize Amplify with \(error)")
        }
    }
}
