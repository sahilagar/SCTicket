//
//  userRequestsTableViewController.swift
//  SCTicket
//
//  Created by Sahil Agarwal on 7/25/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import UIKit
import Firebase

class userRequestsTableViewController: UITableViewController {
    
    var ref = Database.database().reference().child("requests")
    var requests = [Request]()

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
            let currUser = Auth.auth().currentUser!.uid
            for item in snapshot.children {
                let tempSnapshot = item as! DataSnapshot
                let singleRequest = Request(snapshot: tempSnapshot)
                //if uid equals belongsToUser
                if singleRequest?.belongsToUser == currUser {
                    allRequests.append(singleRequest!)
                }
            }
            self.requests = allRequests
            self.tableView.reloadData()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //populate requests array
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            var allRequests = [Request]()
            let currUser = Auth.auth().currentUser!.uid
            for item in snapshot.children {
                let tempSnapshot = item as! DataSnapshot
                let singleRequest = Request(snapshot: tempSnapshot)
                //if uid equals belongsToUser
                if singleRequest?.belongsToUser == currUser {
                    allRequests.append(singleRequest!)
                }
            }
            self.requests = allRequests
            self.tableView.reloadData()
        })
    }
    
    //refreshes when pull down
    func refresh(sender:AnyObject) {
        //populate requests array
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            var allRequests = [Request]()
            let currUser = Auth.auth().currentUser!.uid
            for item in snapshot.children {
                let tempSnapshot = item as! DataSnapshot
                let singleRequest = Request(snapshot: tempSnapshot)
                //if uid equals belongsToUser
                if singleRequest?.belongsToUser == currUser {
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return requests.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        
        let curr = requests[indexPath.row]
        
        cell.textLabel?.text = curr.gamePostedIn
        cell.selectionStyle = .none

        return cell
    }
    
    


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let curr = requests[indexPath.row]
            let userPostRef = ref.child(curr.postID)
            userPostRef.removeValue()
            requests.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }   
    }

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
