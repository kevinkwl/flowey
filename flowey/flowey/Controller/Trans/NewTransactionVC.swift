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
import Siesta

class MyFormViewController: FormViewController, ResourceObserver {
    
    var friendsResource: Resource? {
        didSet {
            // One call to removeObservers() removes both self and statusOverlay as observers of the old resource,
            // since both observers are owned by self (see below).
            
            oldValue?.removeObservers(ownedBy: self)
            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.1)
            
            // Adding ourselves as an observer triggers an immediate call to resourceChanged().
            
            friendsResource?.addObserver(self)
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
        if let friends: [Friend] = friendsResource?.typedContent() {
            print("resource changed: \(friends)")
            userList = friends
        } else {
            print("empty friends list")
        }
    }
    
    var userList = [Friend]() {
        didSet {
            if let row = self.form.rowBy(tag: "Choose a friend") as? PushRow<Friend> {
                row.options = userList
            }
            
            if let row = self.form.rowBy(tag: "Split") as? MultipleSelectorRow<Friend> {
                row.options = userList
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsResource = FloweyAPI.friends
        
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
                $0.options = categories_for_creation
                $0.value = categories_for_creation[0]
                }
                .onPresent { from, to in
                    to.popoverPresentationController?.permittedArrowDirections = .up
            }
            
            
            +++ Section()
            
            <<< PushRow<Friend>("Choose a friend"){
                $0.title = $0.tag
                $0.selectorTitle = "Select a friend"
                $0.options = userList
                
                $0.hidden = .function(["Category"], { form -> Bool in
                    let actionSheetRow: ActionSheetRow<String>? = form.rowBy(tag: "Category")
                    let category_string = actionSheetRow!.value! // string
                    if is_flow((category_string)) {
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
                    if is_flow((category_string)) {
                        return true
                    }else{
                        return false
                    }
                })
            }
            
            <<< MultipleSelectorRow<Friend>() {
                $0.tag = "Split"
                $0.title = "Split With"
                $0.selectorTitle = "Select friends"
                $0.options = userList
                
//                $0.displayValueFor = { (rowValue: Set<User>?) in
//                    return rowValue?.map({ $0.username }).sorted().joined(separator: ", ")
//                }
                //$0.value = ["None"]    // initially selected
                
                $0.hidden = .function(["Split bill with friends", "Category"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowBy(tag: "Split bill with friends")
                    let actionSheetRow: ActionSheetRow<String>? = form.rowBy(tag: "Category")
                    let category_string = actionSheetRow!.value! // string
                    return row.value ?? false == false ||
                        is_flow((category_string))
                })
            }
    }
    
    
    @IBAction func DoneButton(_ sender: Any) {
        
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
        
        let pushRow: PushRow<Friend>? = form.rowBy(tag: "Choose a friend")
        
        var split_with = [Int]()
        let multipleSelectorRow: MultipleSelectorRow<Friend>? = form.rowBy(tag: "Split")
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
            tranDict["objects_user_id"] = obj_user.user_id
        }
        print("tranDict is:")
        print(tranDict)
        
        FloweyAPI.addNewTransaction(tranDict, onSuccess: {
            print("successfully add new transaction!")
            self.navigationController?.popToRootViewController(animated: true)
        }, onFailure: { (errormsg) in
            print(errormsg)
        })
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
