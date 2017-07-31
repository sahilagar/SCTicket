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


class enterPhoneNumberViewController: UIViewController, UITableViewDelegate {

    
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    @IBOutlet weak var phonenumberText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        phonenumberText.attributedPlaceholder = NSAttributedString(string:"ex: +14253940344")
    }

    @IBAction func sendCodeButton(_ sender: Any) {
        activityindicator.startAnimating()
        PhoneAuthProvider.provider().verifyPhoneNumber(self.phonenumberText.text!) { (verificationID, error ) in
            if error != nil { //entered invalid phone number
                //
                //send an error and clear the phone number field
                //
                let alert = UIAlertController(title: "Error", message: "Invalid Phone Number", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.phonenumberText.text = ""
            } else {
                
                /*
                 //valid phone number send to the next screen
                */
                
                let defaults = UserDefaults.standard
                defaults.setValue(verificationID, forKey: "authVerificationID")
                self.activityindicator.stopAnimating()
                self.performSegue(withIdentifier: "sendVerificationCode", sender: Any?.self)
            }
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendVerificationCode" {
            let allTicketsTableViewController = segue.destination as! verificationCodeViewController
            allTicketsTableViewController.phoneNumberText = phonenumberText.text!
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
