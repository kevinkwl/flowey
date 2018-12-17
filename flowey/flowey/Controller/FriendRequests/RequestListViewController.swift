//
//  RequestListViewController.swift
//  flowey
//
//  Created by Zefeng Liu on 11/27/18.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import UIKit
import Siesta
import SiestaUI

class RequestListViewController: UIViewController, ResourceObserver, UITableViewDelegate, UITableViewDataSource, FriendRequestCellDelegate {
    @IBOutlet weak var requestTableView: UITableView!
    
    var requests: [FriendRequest] = [] {
        didSet {
            requestTableView.reloadData()
        }
    }
    
    var statusOverlay = ResourceStatusOverlay()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        requestsResource = FloweyAPI.friend_requests
        self.navigationItem.title = "Friend Requests"
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell", for: indexPath) as? FriendRequestCell {
            cell.usernameLabelView.text = requests[indexPath.row].username
            cell.cellDelegate = self
            return cell
        }
        return UITableViewCell()
    }
 

    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let reject = UITableViewRowAction(style: .destructive, title: "Reject") { action, index in
            let from_user = self.requests[editActionsForRowAt.row].user_id
            self.requests.remove(at: editActionsForRowAt.row)
            FloweyAPI.rejectFriendRequest(from_user, onSuccess: {
                print("success")
            }, onFailure: { (error) in
                print("failed to reject request \(error)")
            })
        }
        reject.backgroundColor = Colorify.Alizarin
        return [reject]
    }

    
    func accept(cell: FriendRequestCell) {
        if let indexPath = requestTableView.indexPath(for: cell) {
            let from_user = self.requests[indexPath.row].user_id
            self.requests.remove(at: indexPath.row)
            FloweyAPI.agreeFriendRequest(from_user, onSuccess: {
                print("success")
            }, onFailure: { (error) in
                print("failed to accept request \(error)")
            })
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    var requestsResource: Resource? {
        didSet {
            // One call to removeObservers() removes both self and statusOverlay as observers of the old resource,
            // since both observers are owned by self (see below).
            
            oldValue?.removeObservers(ownedBy: self)
            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.1)
            
            // Adding ourselves as an observer triggers an immediate call to resourceChanged().
            
            requestsResource?.addObserver(self)
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
        self.requests = requestsResource?.typedContent() ?? []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        requestsResource?.load()
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
