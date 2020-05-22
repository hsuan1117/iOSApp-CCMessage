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
    var auth : AuthDataResult?
    
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
    init(completion: @escaping ()->()){
        Auth.auth().addStateDidChangeListener { (auth, user) in
            completion()
        }
    }
}
