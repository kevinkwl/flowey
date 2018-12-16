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

            groupedTrans = Dictionary(grouping: transactions, by: { $0.date })
        }
    }
    
    var groupedTrans: [String: [Transaction]] = [:] {
        didSet {
            dates = groupedTrans.keys.sorted().reversed()
            tableView.reloadData()
            updateSpendTotal()
        }
    }
    
    var dates: [String] = []
    
    func updateSpendTotal() {
        var total = 0
        for (_, trans) in groupedTrans {
            for t in trans {
                print("\(t) amount = \(t.expense_amount())")
                total += t.expense_amount()
            }
        }
        print("new total \(total)")
        totalLabelView.text = getMoneyStr(money: total)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // table view delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedTrans[dates[section]]!.count
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
//        cell.transaction = transactions[indexPath.row]
        cell.transaction = groupedTrans[dates[indexPath.section]]![indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dates.count
    }
    
    // this method handles row deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // remove the item from the data model
            // delete the table view row
//            let tid = transactions[indexPath.row].transaction_id
//            transactions.remove(at: indexPath.row)
            let dateGroup = dates[indexPath.section]
            let transaction = groupedTrans[dateGroup]![indexPath.row]
            let tid = transaction.transaction_id
            groupedTrans[dateGroup]!.remove(at: indexPath.row)
            if groupedTrans[dateGroup]!.count == 0 {
                // must first remove from dates
                dates.remove(at: indexPath.section)
                groupedTrans.removeValue(forKey: dateGroup)
            }
            

            FloweyAPI.deleteTransaction(tid, onSuccess: {
                print("success")
                
            }, onFailure: { (error) in
                print("failed to delete transaction \(error)")
            })
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Not used in our example, but if you were adding a new row, this is where you would do it.
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dates[section]
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.font = UIFont(name: "Futura", size: 12) // change it according to ur requirement
        header?.textLabel?.textColor = UIColor.darkGray // change it according to ur requirement
    }
        
}
