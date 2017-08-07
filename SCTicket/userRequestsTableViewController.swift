//
//  userRequestsTableViewController.swift
//  SCTicket
//
//  Created by Sahil Agarwal on 7/25/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD


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
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
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
            MBProgressHUD.hide(for: self.view, animated: true)
            self.requests = allRequests
            self.tableView.reloadData()
        })
        let imageView = UIImageView(image: UIImage(named: "Background"))
        self.tableView.backgroundView = imageView
        
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
        
        var temp = ""
        if curr.tryingToBuy == false {
            temp = "Selling"
        } else {
            temp = "Buying"
        }
        
        cell.textLabel?.text = curr.gamePostedIn + ": \(temp) for $" + String(Int(curr.price))

        cell.selectionStyle = .none
        
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear

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

}
