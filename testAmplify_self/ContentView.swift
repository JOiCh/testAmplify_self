import SwiftUI

struct ContentView: View {

    @EnvironmentObject var authSessionManager: AuthSessionManager

    var body: some View {

        switch authSessionManager.authState {
        case .login:
            LoginView()
                .environmentObject(authSessionManager)
            
        case .confirmCode(let username):
            VerifyCodeView(username: username)
                .environmentObject(authSessionManager)
            
        case .test:
            IndexView()
                .environmentObject(authSessionManager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


