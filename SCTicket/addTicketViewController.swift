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
                
                if self.priceEntered.text == nil || self.priceEntered.text == "" {
                    let alert = UIAlertController(title: "Error", message: "Please enter a valid price", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                /*
                 // add ticket to database
                 */
                let userID = Auth.auth().currentUser!.uid
                let userPhoneNumberReference = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
                var userPhoneNumber: String = ""
                
                let dispatchGroup = DispatchGroup()
                
                //makes the closure run first instead of last
                dispatchGroup.enter()
                userPhoneNumberReference.observeSingleEvent(of: .value, with: { (snapshot) in
                    for item in snapshot.children {
                        let snap = item as! DataSnapshot
                        userPhoneNumber = snap.value as! String
                        print(userPhoneNumber + " in the observe single event")
                    }
                   dispatchGroup.leave()
                })
                
                //populates the request and uploads to database
                dispatchGroup.notify(queue: .main, execute: { 
                    var tryingToBuy = false
                    if self.buyOrSell.selectedSegmentIndex == 0 {
                        tryingToBuy = true
                    }
                    var descriptionText = " "
                    if self.enteredDescription.text != nil {
                        descriptionText = self.enteredDescription.text!
                    }
                    let requestAttrs = ["price": Double(self.priceEntered.text!) as Any,
                                        "tryingToBuy" : tryingToBuy,
                                        "gamePostedIn": self.gamePostedIn,
                                        "description": descriptionText,
                                        "belongsToUser" : userID,
                                        "belongsToPhoneNumber": userPhoneNumber] as [String : Any]
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
                })
            }
        }
    }
}
