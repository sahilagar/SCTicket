//
//  verificationCodeViewController.swift
//  SCTicket
//
//  Created by Sahil Agarwal on 7/13/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebasePhoneAuthUI
import FirebaseDatabase

//enter verification code
class verificationCodeViewController: UIViewController {
    
    var phoneNumberText = ""

    @IBOutlet weak var codeText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }

    
    
    
    @IBAction func loginButton(_ sender: Any) {
        //close keyboard
        codeText.resignFirstResponder()
        activityindicator.startAnimating()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        //phone number verification
        let defaults = UserDefaults.standard
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVerificationID")!, verificationCode: codeText.text!)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                
                //invalid authentication
                let alert = UIAlertController(title: "Error", message: "Invalid Authentication Code \"\(self.codeText.text ?? "")\"", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                alert.view.tintColor = UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0)
                self.present(alert, animated: true, completion: nil)
                self.activityindicator.stopAnimating()
                self.codeText.text = ""
            } else { //code was correct
                self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
                let phoneNumber = self.phoneNumberText
                
                guard let firUser = Auth.auth().currentUser else {
                    print ("returning here")
                    return
                }
                self.activityindicator.stopAnimating()
                let userAttrs = ["phoneNumber": phoneNumber]
                let ref = Database.database().reference().child("users").child(firUser.uid)
                ref.setValue(userAttrs) { (error, ref) in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                        return
                    }
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        let _ = User(snapshot: snapshot)
                        //segues through app delegate
                        
                    })
                }
                
                
            }
        }
        
    }
    
    
    
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

