//
//  ticketUser.swift
//  SCTicket
//
//  Created by Sahil Agarwal on 7/14/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User {
    
    let uid: String
    let phoneNumber: String
    let requests: [String] = []
    
    
    init(uid: String, phoneNumber: String) {
        self.uid = uid
        self.phoneNumber = phoneNumber
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let phoneNumber = dict["phoneNumber"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.phoneNumber = phoneNumber
    }
}
