//
//  TransactionViewController.swift
//  flowey
//
//  Created by Kangwei Ling on 2018/10/28.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    // table view delegate
}

extension TransactionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // section header
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionSectionCell") as! TransactionSectionCell
            
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // expand collapse
        if indexPath.row == 0 {
            let sectionCell = tableView.cellForRow(at: indexPath) as! TransactionSectionCell
            sectionCell.flip()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionSectionCell") as! TransactionSectionCell
        
        //let headerTagGesture = UITapGestureRecognizer()
        //headerTagGesture.addTarget(self, action: #selector(self.sectionHeaderWasTouched(_:)))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    
}
