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
            updateFlows()
            tableView.reloadData()
        }
    }
    
    var friendsFlows: [Int: Int] = [:]
    
    @IBOutlet weak var oweLabelView: UILabel!
    @IBOutlet weak var areOweLabelView: UILabel!
    
    

    var statusOverlay = ResourceStatusOverlay()

    func updateFlows() {
        var flow_in = 0
        var flow_out = 0
        for friend in friends {
            let fid = friend.user_id
            var flow = 0
            for t in friend.flows {
                flow += t.flow_amount()
            }
            friendsFlows[fid] = flow
            
            if flow > 0 {
                flow_out += flow
            } else {
                flow_in += abs(flow)
            }
        }
        
        oweLabelView.text = getMoneyStr(money: flow_in)
        areOweLabelView.text = getMoneyStr(money: flow_out)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        friendsResource = FloweyAPI.friends
        
        oweLabelView.textColor = Colorify.Grenadine
        areOweLabelView.textColor = Colorify.Nephritis
    }
    
    // table view delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        cell.usernameLabelView.text = friends[indexPath.row].username
        let flow = friendsFlows[friends[indexPath.row].user_id] ?? 0
        
        if flow > 0 {
            cell.flowLabelView.textColor = Colorify.Nephritis
        } else if flow < 0 {
            cell.flowLabelView.textColor = Colorify.Grenadine
        } else {
            cell.flowLabelView.textColor = Colorify.Steel
        }
        
        cell.flowLabelView.text = getMoneyStr(money: abs(flow))
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

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "flows"
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.font = UIFont(name: "Futura", size: 13) // change it according to ur requirement
        header?.textLabel?.textColor = UIColor.darkGray // change it according to ur requirement
        header?.textLabel?.textAlignment = .center
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let fvc = segue.destination as? FlowsListViewController {
            if let idx = tableView.indexPathForSelectedRow {
                fvc.trans = friends[idx.row].flows
                fvc.listFor = friends[idx.row].username
            }
        }
    }
    
    
}
