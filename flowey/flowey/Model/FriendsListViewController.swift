//
//  FriendsListViewController.swift
//  flowey
//
//  Created by Zefeng Liu on 11/25/18.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import UIKit

class FriendsListViewController: UITableViewController {
    
    var friends: [Friendship] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // mock data
//        friends.append(Friendship(username: "Alice", flow: [1.0, 2.0, 3.0]))
//        friends.append(Friendship(username: "Bob", flow: [2.0, -3.0]))
    }
    
    // table view delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        cell.usernameLabelView.text = friends[indexPath.row].username
        var totalFlow: Double = 0
        for flow in friends[indexPath.row].flow {
            totalFlow += flow
        }
        cell.flowLabelView.text = String(totalFlow)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
