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

class verificationCodeViewController: UIViewController {

    @IBOutlet weak var codeText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func loginButton(_ sender: Any) {
        
        
        //phone number verification
        let defaults = UserDefaults.standard
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVerificationID")!, verificationCode: codeText.text!)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("verification code was entered wrong")
                return
            } else {
                let userInfo = user?.providerData[0]
                self.performSegue(withIdentifier: "newPhoneNumberCreated", sender: Any?.self)
            }
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
