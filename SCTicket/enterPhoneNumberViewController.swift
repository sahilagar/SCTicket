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
            if error != nil {
                //
                //send an error and clear the phone number field
                //
                let alert = UIAlertController(title: "Error", message: "Invalid Phone Number", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.phonenumberText.text = ""
                print("Error entering phone number \n \n ")
            } else {
                let defaults = UserDefaults.standard
                defaults.setValue(verificationID, forKey: "authVerificationID")
                //if phone number already exists in database
                //perform segue to the logged in page
                
                //else send verification code
                self.performSegue(withIdentifier: "sendVerificationCode", sender: Any?.self)
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
