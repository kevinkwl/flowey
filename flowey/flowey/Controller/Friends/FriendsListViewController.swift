//
//  FriendsListViewController.swift
//  flowey
//
//  Created by Zefeng Liu on 11/25/18.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import UIKit
import Siesta
import SiestaUI

class FriendsListViewController: UITableViewController, ResourceObserver {
    
    var friends: [Friend] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var oweLabelView: UILabel!
    @IBOutlet weak var areOweLabelView: UILabel!
    
    

    var statusOverlay = ResourceStatusOverlay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        friendsResource = FloweyAPI.friends
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
        var totalFlow = 0
        for flow in friends[indexPath.row].flows {
            totalFlow += flow.flow_amount()
        }
        
        if totalFlow > 0 {
            
        }
        cell.flowLabelView.text = getMoneyStr(money: abs(totalFlow))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    var friendsResource: Resource? {
        didSet {
            // One call to removeObservers() removes both self and statusOverlay as observers of the old resource,
            // since both observers are owned by self (see below).
            
            oldValue?.removeObservers(ownedBy: self)
            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.1)
            
            // Adding ourselves as an observer triggers an immediate call to resourceChanged().
            
            friendsResource?.addObserver(self)
                .addObserver(statusOverlay, owner: self)
                .loadIfNeeded()
        }
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        // typedContent() infers that we want a User from context: showUser() expects one. Our content tranformer
        // configuation in GitHubAPI makes it so that the userResource actually holds a User. It is up to a Siesta
        // client to ensure that the transformer output and the expected content type line up like this.
        //
        // If there were a type mismatch, typedContent() would return nil. (We could also provide a default value with
        // the ifNone: param.)
        print(friendsResource?.typedContent() ?? "empty")
        self.friends = friendsResource?.typedContent() ?? []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        friendsResource?.load()
    }
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            let user_to_delete = self.friends[editActionsForRowAt.row].user_id
            self.friends.remove(at: editActionsForRowAt.row)
            FloweyAPI.removeFriend(user_to_delete, onSuccess: {
                print("success")
            }, onFailure: { (error) in
                print("failed to reject request \(error)")
            })
        }
        delete.backgroundColor = Colorify.Alizarin
        return [delete]
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let fvc = segue.destination as? FlowsListViewController {
            if let idx = tableView.indexPathForSelectedRow {
                fvc.trans = friends[idx.row].flows
            }
        }
    }
}
