//
//  Ticket.swift
//  SCTicket
//
//  Created by Sahil Agarwal on 7/19/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class Ticket {
    
    let postID: String
    let price: Double
    let tryingToBuy: Bool
    let gamePostedIn: String
    let description: String
    
    init(postID: String, price: Double, tryingToBuy: Bool, gamePostedIn:String, description: String) {
        self.postID = postID
        self.price = price
        self.tryingToBuy = tryingToBuy
        self.gamePostedIn = gamePostedIn
        self.description = description
    }

    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let price = dict["price"] as? Double,
            let tryingToBuy = dict["tryingToBuy"] as? Bool,
            let gamePostedIn = dict["gamePostedIn"] as? String,
            let description = dict["description"] as? String
        else {return nil}
        
        self.postID = snapshot.key
        self.price = price
        self.tryingToBuy = tryingToBuy
        self.gamePostedIn = gamePostedIn
        self.description = description
        
    }
}
