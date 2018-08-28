//
//  User.swift
//  MyrrhMyrrh
//
//  Created by Austin McCune on 8/16/18.
//  Copyright © 2018 Austin McCune. All rights reserved.
//

import Foundation
import FirebaseAuth

struct user {
    let uid:String
    let email:String
    
    // first time init with user data
    init(userData:user) {
        uid = userData.uid
        
        if let mail = Auth.auth().currentUser?.providerData.first?.email{
            email = mail
        }else{
            email = ""
        }
    }
    
    init(uid:String,email:String){
        self.uid = uid
        self.email = email
    }
    
}
