//
//  ContentView.swift
//  testAmplify_self
//
//  Created by JOi Chao on 2022/11/14.
//

import SwiftUI
import Amplify
import LogModuleLibrary
import AWSCognitoAuthPlugin

struct LoginView: View {
    @State var emailText:String = ""
    
    var body: some View {
        VStack {
            Text("AWS").bold()
            
            TextField("Enter email", text: $emailText)
                .font(.title3)
                .padding(.horizontal)
                .frame(height:55)
                .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            
            Button {
                Task {
//                    lg.debug("我有發請求")
//                    await signUp(username: emailText, email: emailText)
//                    await confirmSignUp(for: emailText, with: "11111111")
//                    await signIn(username: "r87713@gmail.com")
                }
            } label: {
                Text("登入(Sign Up)")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .font(.title2).bold()
                    .background(.orange)
                    .cornerRadius(10)
            }
            
            
            
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
