//
//  enterPhoneNumberViewController.swift
//  SCTicket
//
//  Created by Sahil Agarwal on 7/13/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import UIKit
import FirebaseAuth

class enterPhoneNumberViewController: UIViewController {

    @IBOutlet weak var phonenumberText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    

    @IBAction func sendCodeButton(_ sender: Any) {
        let alert = UIAlertController(title: "Phone Number", message: "Is this your phone number? \n \(phonenumberText.text!)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            PhoneAuthProvider.provider().verifyPhoneNumber(self.phonenumberText.text!) { (verificationID, error ) in
                if error != nil {
                    print("error: \(String(describing: error?.localizedDescription))")
                } else {
                    let defaults = UserDefaults.standard
                    defaults.setValue(verificationID, forKey: "authVerificationID")
                    self.performSegue(withIdentifier: "code", sender: Any?.self)
                }
            }
        }
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
