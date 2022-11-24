//
//  VerifyCodeView.swift
//  testAmplify_self
//
//  Created by JOi Chao on 2022/11/24.
//

import SwiftUI

struct VerifyCodeView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var verifyCodeText:String = ""
    let username: String
    
    var body: some View {
        VStack{
            TextField("Enter veryfy code", text: $verifyCodeText)
                .font(.title3)
                .padding(.horizontal)
                .frame(height:55)
                .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            
            Button {
//                Task {
//                    await customChallenge(response: verifyCodeText)}
            } label: {
                Text("確認驗證碼")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .font(.title2).bold()
                    .background(.pink)
                    .cornerRadius(10)
            }
            
            Button {
                // 清空驗證碼與email
                // 導回上一頁
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("上一頁")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .font(.title2).bold()
                    .background(.green)
                    .cornerRadius(10)
            }
            
            
        }
    }
}

struct VerifyCodeView_Previews: PreviewProvider {
    static var previews: some View {
        VerifyCodeView()
    }
}
