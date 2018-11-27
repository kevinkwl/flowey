//
//  NewTransactionVC.swift
//  flowey
//
//  Created by Kangwei Ling on 2018/10/30.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import UIKit

class NewTransactionVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var amountTextF: UITextField!
    @IBOutlet weak var categoryTextF: UITextField!
    @IBOutlet weak var dateTextF: UITextField!
    
    var transaction: Transaction?
    
    let datePicker = UIDatePicker()
    let pickerView = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showDatePicker()

        pickerView.delegate = self
        categoryTextF.inputView = pickerView
        
        pickerView.showsSelectionIndicator = true
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneCategoryPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelCategoryPicker));
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        categoryTextF.inputAccessoryView = toolbar
        categoryTextF.delegate = self
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == categoryTextF && textField.text!.isEmpty {
            pickerView.selectRow(0, inComponent: 0, animated: false)
            pickerView(self.pickerView, didSelectRow: 0, inComponent: 0)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("select!")
        categoryTextF.text = categories[row]
    }
    
    @objc func doneCategoryPicker() {
        categoryTextF.resignFirstResponder()
    }
    
    @objc func cancelCategoryPicker() {
        categoryTextF.resignFirstResponder()
    }

    
    func showDatePicker() {
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        dateTextF.inputAccessoryView = toolbar
        dateTextF.inputView = datePicker
        
    }
    
    @objc func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateTextF.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    
    
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        guard let amount = Int(amountTextF.text ?? "_"), let date = dateTextF.text else {
            print("invalid transaction")
            return
        }
        let category = self.pickerView.selectedRow(inComponent: 0)
        let tranDict: [String: Any] = ["amount" : amount,
                        "date" : date,
                        "category" : category,
                        "currency" : "usd"]
        print("tranDict is:")
        print(tranDict)
        print(type(of: date))
        // ["date": "2018-11-26", "category": 0, "currency": "usd", "amount": 233]
        FloweyAPI.addNewTransaction(tranDict, onSuccess: {
                print("successfully add new transaction!")
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
