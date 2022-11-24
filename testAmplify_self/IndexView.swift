//
//  Index.swift
//  testAmplify_self
//
//  Created by JOi Chao on 2022/11/24.
//

import SwiftUI
import Amplify
import LogModuleLibrary
import AWSCognitoAuthPlugin


struct IndexView: View {
    var body: some View {
        
        VStack {
            Text("Hello, World!\n登入終於成功完成拉！")
                .font(.title)
            .bold()
            
            Button {
//                Task {
//                    await signOutLocally()}
            } label: {
                Text("登出")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .font(.title2).bold()
                    .background(.blue)
                    .cornerRadius(10)
            }
        }
    }
}

struct IndexView_Previews: PreviewProvider {
    static var previews: some View {
        IndexView()
    }
}
