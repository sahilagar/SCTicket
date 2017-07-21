//
//  addTicketViewController.swift
//  SCTicket
//
//  Created by Sahil Agarwal on 7/19/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import UIKit
import Firebase

class addTicketViewController: UIViewController {
    
    @IBOutlet weak var buyOrSell: UISegmentedControl!
    
    @IBOutlet weak var priceEntered: UITextField!

    @IBOutlet weak var enteredDescription: UITextField!
    
    var gamePostedIn = ""

    override func viewDidLoad() {
        super.viewDidLoad()
//        //hide navigation bar
//        self.navigationController?.setNavigationBarHidden(true, animated: true)

        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "cancel" {
                print("Cancel button tapped")
            } else if identifier == "save" {
                /*
                // add ticket to database
                */
                let userID = Auth.auth().currentUser!.uid
                var tryingToBuy = false
                if buyOrSell.selectedSegmentIndex == 0 {
                    tryingToBuy = true
                }
                let requestAttrs = ["price": Double(priceEntered.text!) ?? 0,
                                    "tryingToBuy" : tryingToBuy,
                                    "gamePostedIn": gamePostedIn,
                                    "description": enteredDescription.text!,
                                    "belongsToUser" : userID] as [String : Any]
                let ref = Database.database().reference().child("requests").childByAutoId()
                ref.setValue(requestAttrs) { (error, ref) in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                        return
                    }
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        self.performSegue(withIdentifier: "save", sender: Any?.self)
                        
                    })
                }
                
            }
        }
    }
    
}
