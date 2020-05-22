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

class Account {
    func registerWithPassword(account:String,password:String,completion:(AuthResult)->()){
        Auth.auth().createUser(withEmail: account, password: password) { authResult, error in
            completion(AuthResult(auth: authResult,error: error))
        }
    }
    func loginWithPassword(account:String,password:String,completion:(AuthResult)->()){
        Auth.auth().signIn(withEmail: account, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            completion(AuthResult(auth: authResult, error: error))
        }
    }
    init(){
        
    }
}
