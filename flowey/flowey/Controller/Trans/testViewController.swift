//
//  MyFormViewController.swift
//  flowey
//
//  Created by Kunyan Han on 11/25/18.
//  Copyright © 2018 duckduckrush. All rights reserved.
//  hankunyan@test.com
//

import UIKit
import Eureka

struct User: Codable, Hashable, CustomStringConvertible {
    var user_id: Int
    var username: String
    
    var description: String {
        return username
    }
}


class MyFormViewController: FormViewController {
    
    // the friend list will be fetched from database
    let friendList = ["Kangwei Ling", "Xi Yang", "Zefeng Liu"]
    
    
    var liu = User(user_id: 1, username: "Zefeng Liu")
    var yang = User(user_id: 2, username: "Xi Yang")
    var ling = User(user_id: 3, username: "Kangwei Ling")
    
    var userList = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userList.append(liu)
        userList.append(yang)
        userList.append(ling)
        
        
        
        
        DateRow.defaultRowInitializer = { row in row.minimumDate = Date() }
        
        form +++
            Section()
            
            <<< DecimalRow() {
                $0.tag = "Amount"
                $0.useFormatterDuringInput = true
                $0.title = "Amount"
                $0.value = 0
                let formatter = CurrencyFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                $0.formatter = formatter
            }
            
            <<< DateRow() {
                $0.tag = "Date"
                $0.title = "Date"
                $0.value = Date();
            }
        
            <<< ActionSheetRow<String>() {
                $0.tag = "Category"
                $0.title = "Category"
                $0.selectorTitle = "Choose a category"
                $0.options = categories
                $0.value = categories[0]
                }
                .onPresent { from, to in
                    to.popoverPresentationController?.permittedArrowDirections = .up
            }
            
//            <<< TextRow() {  row in
//                row.tag = "Info"
//                row.title = "Info"
//                row.placeholder = "Enter your info here"
//            }
            
            +++ Section()
            
            <<< PushRow<User>("Choose a friend"){
                $0.title = $0.tag
                $0.selectorTitle = "Select a friend"
                $0.options = userList
                
                $0.hidden = .function(["Category"], { form -> Bool in
                    let actionSheetRow: ActionSheetRow<String>? = form.rowBy(tag: "Category")
                    let category_string = actionSheetRow!.value! // string
                    if category_string == "Lending" || category_string == "Borrowing" || category_string == "Return" {
                        return false
                    }else{
                        return true
                    }
                })
            }
            
            <<< SwitchRow("Split bill with friends"){
                $0.title = $0.tag
                $0.hidden = .function(["Category"], { form -> Bool in
                    let actionSheetRow: ActionSheetRow<String>? = form.rowBy(tag: "Category")
                    let category_string = actionSheetRow!.value! // string
                    if category_string == "Lending" || category_string == "Borrowing" || category_string == "Return" {
                        return true
                    }else{
                        return false
                    }
                })
            }
            
            <<< MultipleSelectorRow<User>() {
                $0.tag = "Split"
                $0.title = "Split With"
                $0.selectorTitle = "Select friends"
                $0.options = userList
//
//                $0.displayValueFor = { (rowValue: Set<User>?) in
//                    return rowValue?.map({ $0.username }).sorted().joined(separator: ", ")
//                }
                //$0.value = ["None"]    // initially selected
                
                $0.hidden = .function(["Split bill with friends", "Category"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowBy(tag: "Split bill with friends")
                    let actionSheetRow: ActionSheetRow<String>? = form.rowBy(tag: "Category")
                    let category_string = actionSheetRow!.value! // string
                    return row.value ?? false == false ||
                        category_string == "Lending" || category_string == "Borrowing" || category_string == "Return"
                })
            }
    }
    
    
    @IBAction func DoneButton(_ sender: Any) {
//        if let infoRow: TextRow = form.rowBy(tag: "Info"), let value = infoRow.value {
//            let info = value
//            print(info)
//        }
//        let allValues = form.values()
//        print(allValues)
//
//        for item in allValues {
//            print(item.key, item.value)
//            if item.value == nil {
//                print(item.key, "is nil")
//            }
//        }
        
        
        let decimalRow: DecimalRow? = form.rowBy(tag: "Amount")
        let double_amount = decimalRow!.value! * 100
        let amount = Int(double_amount)
        
        let dateRow: DateRow? = form.rowBy(tag: "Date")
        let original_date = dateRow!.value! // Date type
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: original_date)
        
        let actionSheetRow: ActionSheetRow<String>? = form.rowBy(tag: "Category")
        let category_string = actionSheetRow!.value! // string
        let category = categoryDict[category_string]!
        
        let pushRow: PushRow<User>? = form.rowBy(tag: "Choose a friend")
        
        var split_with = [Int]()
        let multipleSelectorRow: MultipleSelectorRow<User>? = form.rowBy(tag: "Split")
        let splitSet = multipleSelectorRow!.value
        if splitSet == nil {
            print("nil")
        }else{
            print(type(of: splitSet), splitSet!)
            for item in splitSet! {
                split_with.append(item.user_id)
            }
        }
        
        
        var tranDict: [String: Any] = ["amount" :  amount,
                                       "date" : date,
                                       "category" : category,
                                       "currency" : "usd"]
        if split_with.count > 0 {
            tranDict["split_with"] = split_with
        }
        if let obj_user = pushRow?.value {
            tranDict["object_user_id"] = obj_user.user_id
        }
        print("tranDict is:")
        print(tranDict)
        // ["date": "2018-11-26", "category": 0, "currency": "usd", "amount": 233]
    }
    
    
    
    class CurrencyFormatter : NumberFormatter, FormatterProtocol {
        override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, range rangep: UnsafeMutablePointer<NSRange>?) throws {
            guard obj != nil else { return }
            var str = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            if !string.isEmpty, numberStyle == .currency && !string.contains(currencySymbol) {
                // Check if the currency symbol is at the last index
                if let formattedNumber = self.string(from: 1), String(formattedNumber[formattedNumber.index(before: formattedNumber.endIndex)...]) == currencySymbol {
                    // This means the user has deleted the currency symbol. We cut the last number and then add the symbol automatically
                    str = String(str[..<str.index(before: str.endIndex)])
                    
                }
            }
            obj?.pointee = NSNumber(value: (Double(str) ?? 0.0)/Double(pow(10.0, Double(minimumFractionDigits))))
        }
        
        func getNewPosition(forPosition position: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
            return textInput.position(from: position, offset:((newValue?.count ?? 0) - (oldValue?.count ?? 0))) ?? position
        }
    }
    
    
    
}
