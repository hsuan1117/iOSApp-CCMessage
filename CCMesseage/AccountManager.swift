//
//  AccountManager.swift
//  CCMesseage
//
//  Created by student on 2020/4/17.
//  Copyright © 2020 hsuan. All rights reserved.
//

import Foundation
import Firebase
import SwifterSwift

struct AuthResult {
    var auth  : AuthDataResult?
    var user  : User?
    var error : Error?
}

class AccountManager {
    func registerWithPassword(
        account: String,
        password: String,
        completion: @escaping (AuthResult)->()
    ){
        Auth.auth().createUser(withEmail: account, password: password) {
            authResult, error in
            completion(AuthResult(auth: authResult,error: error))
            
        }
    }
    func loginWithPassword(
        account: String,
        password: String,
        completion: @escaping (AuthResult)->()){
            Auth.auth().signIn(withEmail: account, password: password) {
                [weak self] authResult, error in
                guard let strongSelf = self else { return }
                completion(AuthResult(auth: authResult, error: error))
        }
    }
    func logout(completion: @escaping ()->()){
        try! Auth.auth().signOut()
        completion()
    }
    
    // Define
    func onAuthInit(completion: @escaping (AuthResult)->()){
        Auth.auth().addStateDidChangeListener { (auth, user) in
            completion(AuthResult(auth: nil, user: user, error: nil))
        }
    }
    init(){
        
    }
}
