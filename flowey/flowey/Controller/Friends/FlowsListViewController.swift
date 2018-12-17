//
//  FlowsListViewController.swift
//  flowey
//
//  Created by Zefeng Liu on 12/12/18.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import UIKit
import Siesta
import SiestaUI

class FlowsListViewController: UIViewController {
    
    var transListVC: TransactionListVC?
    var trans: [Transaction] = []
    var listFor: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // transactionsResource = FloweyAPI.transactions
        self.title = listFor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // transactionsResource?.load()
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "embedFlowListViewController" {
            transListVC = segue.destination as? TransactionListVC
            transListVC?.transactions = trans
            transListVC?.isShowFriendFlows = true
            transListVC?.navigationItem.title = listFor
        }
    }
}
