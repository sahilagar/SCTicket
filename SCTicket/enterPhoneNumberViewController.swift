//
//  enterPhoneNumberViewController.swift
//  SCTicket
//
//  Created by Sahil Agarwal on 7/13/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

class enterPhoneNumberViewController: UIViewController {

    @IBOutlet weak var phonenumberText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }   

    @IBAction func sendCodeButton(_ sender: Any) {
        PhoneAuthProvider.provider().verifyPhoneNumber(self.phonenumberText.text!) { (verificationID, error ) in
            if error != nil { //entered invalid phone number
                //
                //send an error and clear the phone number field
                //
                let alert = UIAlertController(title: "Error", message: "Invalid Phone Number", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.phonenumberText.text = ""
                print("Error entering phone number \n \n ")
            } else {
                
                /*
                 //valid phone number, write to database and send to the next screen
                */
                
                let defaults = UserDefaults.standard
                defaults.setValue(verificationID, forKey: "authVerificationID")
                guard let firUser = Auth.auth().currentUser,
                    let phoneNumber = self.phonenumberText.text,
                    !phoneNumber.isEmpty else { return }
                let userAttrs = ["phoneNumber": phoneNumber]
                let ref = Database.database().reference().child("users").child(firUser.uid)
                ref.setValue(userAttrs) { (error, ref) in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                        return
                    }
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        let user = User(snapshot: snapshot)
                        // handle newly created user here
                        self.performSegue(withIdentifier: "sendVerificationCode", sender: Any?.self)
                    })
                }
            }
        }
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
