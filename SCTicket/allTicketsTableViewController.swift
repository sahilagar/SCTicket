//
//  allTicketsTableViewController.swift
//  SCTicket
//
//  Created by Sahil Agarwal on 7/18/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import UIKit
import Firebase

class allTicketsTableViewController: UITableViewController {
    
    var ref = Database.database().reference().child("requests")
    var requests = [Request]()
    
    //string that displays at the top of the controller
    var currentGame = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //refreshes when pull down
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!)

        
        //populate requests array
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            var allRequests = [Request]()
            for item in snapshot.children {
                let tempSnapshot = item as! DataSnapshot
                let singleRequest = Request(snapshot: tempSnapshot)
                if singleRequest?.gamePostedIn == self.currentGame {
                    allRequests.append(singleRequest!)
                }
            }
            self.requests = allRequests
            self.tableView.reloadData()
        })

        
    }
    
    //refreshes when pull down
    func refresh(sender:AnyObject) {
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            var allRequests = [Request]()
            for item in snapshot.children {
                let tempSnapshot = item as! DataSnapshot
                let singleRequest = Request(snapshot: tempSnapshot)
                if singleRequest?.gamePostedIn == self.currentGame {
                    allRequests.append(singleRequest!)
                }
            }
            self.requests = allRequests
            self.tableView.reloadData()
        })
        refreshControl?.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return requests.count
    }

    //send the game posted in to the add ticket view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTicket" {
            let allTicketsTableViewController = segue.destination as! addTicketViewController
            allTicketsTableViewController.gamePostedIn = currentGame
        }
    }
    
    @IBAction func unwindToGameTicketsViewController(_ segue: UIStoryboardSegue) {
        // for now, simply defining the method is sufficient.        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "request", for: indexPath) as! requestTableViewCell

        let curr = requests[indexPath.row]
        
        if curr.tryingToBuy == false {
            cell.buyingOrSellingLabel.text = "Wants to sell"
        } else {
            cell.buyingOrSellingLabel.text = "Wants to buy"
        }

        cell.priceLabel.text = String(curr.price)
        cell.descriptionLabel.text = curr.description
        return cell
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
