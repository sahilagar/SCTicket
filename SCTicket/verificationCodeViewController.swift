//
//  verificationCodeViewController.swift
//  SCTicket
//
//  Created by Sahil Agarwal on 7/13/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import UIKit
import FirebaseAuth

class verificationCodeViewController: UIViewController {

    @IBOutlet weak var codeText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func loginButton(_ sender: Any) {
        let defaults = UserDefaults.standard
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVerificationID")!, verificationCode: codeText.text!)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("error: \(String(describing: error?.localizedDescription))")
            } else {
                print("Phone number: \(String(describing: user?.phoneNumber))")
                let userInfo = user?.providerData[0]
                print("Provider ID: \(String(describing: userInfo?.providerID))")
                self.performSegue(withIdentifier: "logged", sender: Any?.self)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
