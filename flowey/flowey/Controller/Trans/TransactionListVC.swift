//
//  TransactionViewController.swift
//  flowey
//
//  Created by Kangwei Ling on 2018/10/28.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import UIKit

class TransactionListVC: UITableViewController {

    @IBOutlet weak var totalLabelView: UILabel!
    var transactions: [Transaction] = [] {
        didSet {
            tableView.reloadData()
            
            var total = 0
            for t in transactions {
                total += t.real_amount()
            }
            totalLabelView.text = String(total)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // table view delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // section header
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionSectionCell") as! TransactionSectionCell
//
//            return cell
//        }
//
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        cell.transaction = transactions[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // this method handles row deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // remove the item from the data model
            // delete the table view row
            print("before \(transactions.count)")
            let tid = transactions[indexPath.row].transaction_id
            transactions.remove(at: indexPath.row)
            FloweyAPI.deleteTransaction(tid, onSuccess: {
                print("success")
            }, onFailure: { (error) in
                print("failed to delete transaction \(error)")
            })
            print(transactions.count)
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Not used in our example, but if you were adding a new row, this is where you would do it.
        }
    }
    
    
}
