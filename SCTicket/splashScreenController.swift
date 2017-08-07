//
//  splashScreenController.swift
//  SCTicket
//
//  Created by Sahil Agarwal on 8/3/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import UIKit

//shows the splash screen and segues after a certain tims
class splashScreenController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        perform(#selector(splashScreenController.showNavController), with: nil, afterDelay: 2)
    }
    
    func showNavController()
    {
        performSegue(withIdentifier: "splash", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
  
