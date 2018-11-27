//
//  NewFriendViewController.swift
//  flowey
//
//  Created by Zefeng Liu on 11/25/18.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import UIKit

class NewFriendViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    var friend: Friend?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    @IBAction func requestTapped(_ sender: UIBarButtonItem) {
        guard let email = emailTextField.text else {
            print("enter a email to request!")
            return
        }
        let friendDict: [String: Any] = ["email": email]
        FloweyAPI.addNewFriend(friendDict, onSuccess: {
            print("successfully send a new friend request!")
            self.navigationController?.popToRootViewController(animated: true)
        }, onFailure: { (errormsg) in
            print(errormsg)
        })
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}
