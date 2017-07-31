//
//  gamesTableViewController.swift
//  SCTicket
//
//  Created by Sahil Agarwal on 7/17/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MBProgressHUD

class gamesTableViewController: UITableViewController {
    
    var ref = Database.database().reference().child("games")
    var games = [String]()
    var titleToSend = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gamesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //populate games array
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            var tempGames = [String]()
            for item in snapshot.children {
                let snap = item as! DataSnapshot
                let singleGame = snap.value as! String
                print(singleGame)
                tempGames.append(singleGame)
            }
            self.games = tempGames
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableView.reloadData()
        })
    }
    @IBOutlet var gamesTableView: UITableView! {
        didSet {
            gamesTableView.delegate = self
            gamesTableView.dataSource = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // listen for update with the .Value event
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resignFirstResponder()
    }
    
    //sign out
    @IBAction func signOutButton(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you wish to sign out?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: { action in
            try! Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "enterPhoneNumberViewController")
            self.present(vc, animated: false, completion: nil)
        }))
        
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return games.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = games[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.titleToSend = games[indexPath.row]
        self.performSegue(withIdentifier: "gameSelected", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameSelected" {
            let allTicketsTableViewController = segue.destination as! allTicketsTableViewController
            allTicketsTableViewController.title = titleToSend
            allTicketsTableViewController.currentGame = titleToSend
        }
        
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

