//
//  Prayer.swift
//  MyrrhMyrrh
//
//  Created by Austin McCune on 8/16/18.
//  Copyright © 2018 Austin McCune. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Prayer{
    let key:String!
    let content:String!
    let addedByUser:String!
    let itemRef:DatabaseReference?
    
    
    // if we do not get contact with firebasedatabase
    init(content:String, addedByUser:String, key:String = ""){
        self.key = key
        self.content = content
        self.addedByUser = addedByUser
        self.itemRef = nil
    }
    
    // init to work with snapshot of firebase data
    init(snapshot:DataSnapshot){
        let value = snapshot.value as? NSDictionary
        
        key = snapshot.key
        itemRef = snapshot.ref
        
        
        
        
        if let prayerContent = value!["content"] as? String{
            content = prayerContent
        }else{
            content = ""
        }
        
        if let prayerUser = value!["addedByUser"] as? String{
            addedByUser = prayerUser
        }else{
            addedByUser = ""
        }
    }
    
    
    func toAnyObject() -> Any {
        return ["content":content,"addedByUser":addedByUser]
    }
    
    
}

