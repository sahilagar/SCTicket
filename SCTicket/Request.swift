//
//  Ticket.swift
//  SCTicket
//
//  Created by Sahil Agarwal on 7/19/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class Request {
    
    let postID: String
    let price: Double
    let tryingToBuy: Bool
    let gamePostedIn: String
    let description: String
    let belongsToUser: String
    
    init(postID: String, price: Double, tryingToBuy: Bool, gamePostedIn:String, description: String, belongsToUser: String) {
        self.postID = postID
        self.price = price
        self.tryingToBuy = tryingToBuy
        self.gamePostedIn = gamePostedIn
        self.description = description
        self.belongsToUser = belongsToUser
    }

    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let price = dict["price"] as? Double,
            let tryingToBuy = dict["tryingToBuy"] as? Bool,
            let gamePostedIn = dict["gamePostedIn"] as? String,
            let description = dict["description"] as? String,
            let belongsToUser = dict["belongsToUser"] as? String
        else {return nil}
        
        self.postID = snapshot.key
        self.price = price
        self.tryingToBuy = tryingToBuy
        self.gamePostedIn = gamePostedIn
        self.description = description
        self.belongsToUser = belongsToUser
        
    }
}
