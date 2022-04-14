//
//  AuthManager.swift
//  RealTalk
//
//  Created by 이건준 on 2022/04/12.
//

import FirebaseAuth

enum AuthError: Error {
    case registerFail
    case logInFail
    
    var errorMessage: String {
        switch self {
        case .registerFail:
            return "회원가입에 실패하였습니다"
        case .logInFail:
            return "로그인에 실패하였습니다"
        }
    }
}

public class AuthManager {
    static let shared = AuthManager()
    
    private let auth = FirebaseAuth.Auth.auth()
    
    public func createUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if result == nil, error != nil {
                print("Error Occured = \(AuthError.registerFail.errorMessage)")
                completion(false)
            }
            else {
                completion(true)
            }
        }
    }
    
    public func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            guard error == nil, result != nil else {
                print("Error Occured = \(AuthError.logInFail.errorMessage)")
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    public func checkCurrentUser(completion: @escaping (Bool) -> Void) {
        if auth.currentUser == nil {
            completion(false)
        }
        else {
            completion(true)
        }
    }
    
    public func logOutUser(completion: @escaping ((Bool) -> Void)) {
        do {
            try auth.signOut()
            print("AuthManager called - Success logOut")
            completion(true)
        }
        catch {
            print("AuthManager called - Fail logOut")
            completion(false)
        }
    }
    
    public func signInWithFacebook(authCredential: AuthCredential, completion: @escaping ((Bool) -> Void)) {
        auth.signIn(with: authCredential) { authResult, error in
            guard authResult != nil, error == nil else {
                if let error = error {
                    print("Facebook credential login failed, MFA may be needed - \(error)")
                }
                completion(false)
                return
            }
            
            print("Successfully logged user in")
            completion(true)
        }
    }
}

