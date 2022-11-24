//
//  AmplifyAuth.swift
//  testAmplify_self
//
//  Created by JOi Chao on 2022/11/24.
//

import Amplify
import AWSCognitoAuthPlugin
import Foundation

enum AuthState {
    case signUp
    case login
    case confirmCode(username: String)
    case session(user: AuthUser)
    case test
}

final class AuthSessionManager: ObservableObject {
    
    @Published var authState: AuthState = .login
    
    // 用來檢查當前的登入狀態
    func getCurrentAuthUser() async {
        print("檢查Auth State開始...")
        do {
            print("我有近判斷歐")
            let session = try await Amplify.Auth.fetchAuthSession()
            // print("登出時的session \(session)")
            if session.isSignedIn {
                let user = try await Amplify.Auth.getCurrentUser()
                await MainActor.run {
                    print("當前登入user => \(user)")
                    DispatchQueue.main.async {
                        self.authState = .test
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.authState = .login
                }
            }
        } catch {
            print(error)
        }
    }
    
    func showSignUp() {
        authState = .signUp
    }
    
    func showLogin() {
        authState = .login
    }
    
    func signUp(email: String) async {
        print("有進來sign up")
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        do {
            print("有進來sign up do")
            let signUpResult = try await Amplify.Auth.signUp(
                username: email,
                password: UUID().uuidString,
                options: options
            )
            
            print("signUpResult => \(signUpResult)")
            
            if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
                print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId)))")
            } else {
                print("Signup Complete")
            }
        } catch let error as AuthError {
            print("An error occurred while registering a user \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func login(username: String) async {
        print("sign in1")
        do {
            print("sign in2")
            let options = AWSAuthSignInOptions(authFlowType: .customWithoutSRP)
            print("sign in3")
            let signInResult = try await Amplify.Auth.signIn(username: username,
                                                             options: .init(pluginOptions: options))
            print("signInResult => \(signInResult)")
            print("sign in4")

            if case .confirmSignInWithCustomChallenge(_) = signInResult.nextStep {
                // Ask the user to enter the custom challenge.
                print("Sign in next step")
                // Confirm the Auth State to confirm code passing in the username to confirm
                DispatchQueue.main.async {
                    print("進來login func")
                    self.authState = .confirmCode(username: username)
                }
            }
        } catch let error as AuthError {
            print("Sign in failed \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }

    func fetchCurrentAuthSession() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            print("Is user signed in - \(session.isSignedIn)")
        } catch let error as AuthError {
            print("Fetch session failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func confirm(response: String) async {
             print("進入confirm func")
             do {
                 let verifyResponse = try await Amplify.Auth.confirmSignIn(challengeResponse: response)
                 print("Confirm sign in succeeded")
//               let session = try await Amplify.Auth.fetchAuthSession()
                 print("verifyResponse : \(verifyResponse.nextStep)")
                 switch verifyResponse.nextStep {
                 case .done:
                     print("Signin complete")
                     DispatchQueue.main.async {
                         Task{
//                             await self.fetchCurrentAuthSession()
                             self.authState = .test
                         }
                     }
                 case .confirmSignInWithCustomChallenge(_):
                     print("confirmSignInWithCustomChallenge")
                     DispatchQueue.main.async {
                         Task{
//                             await self.fetchCurrentAuthSession()
                             print("進來confirmSignInWithCustomChallenge func")
                             self.authState = .login
                         }
                     }
                     print("confirmSignUp")
                 case .confirmSignInWithSMSMFACode(_, _):
                    print("confirmSignInWithSMSMFACode")
                 case .confirmSignInWithNewPassword(_):
                     print("confirmSignInWithNewPassword")
                 case .resetPassword(_):
                     print("resetPassword")
                 case .confirmSignUp(_):
                     print("confirmSignUp")
                 }
             } catch let error as AuthError {
                 print("Confirm sign in failed \(error)")
             } catch {
                 print("Unexpected error: \(error)")
             }
         }

    func signOut() async {
        let result = await Amplify.Auth.signOut()
        guard let signOutResult = result as? AWSCognitoSignOutResult

        else {
            print("Signout failed")
            return
        }
//        let session = try await Amplify.Auth.fetchAuthSession()
//        print("session : \(session)")

        print("Local signout successful: \(signOutResult.signedOutLocally)")
        switch signOutResult {
        case .complete:
            print("SignOut completed and go to Login頁")
            DispatchQueue.main.async {
                self.authState = .login
            }
        case .failed(let error):
            print("SignOut failed with \(error)")
        case let .partial(revokeTokenError, globalSignOutError, hostedUIError):
            print(
                    """
                    SignOut is partial.
                    RevokeTokenError: \(String(describing: revokeTokenError))
                    GlobalSignOutError: \(String(describing: globalSignOutError))
                    HostedUIError: \(String(describing: hostedUIError))
                    """
            )
        }
    }
}

