//
//  Utility.swift
//  flowey
//
//  Created by Kangwei Ling on 2018/10/27.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import Foundation
import UIKit

func isValidEmail(testStr:String) -> Bool {
    //print("validate emilId: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: testStr)
    return result
}


func setLogin() {
    UserDefaults.standard.set(true, forKey: Constants.hasLoginKey)
}

func setLogout() {
    UserDefaults.standard.set(false, forKey: Constants.hasLoginKey)
}

func disableButton(_ btn: UIButton) {
    btn.backgroundColor = FloweyTheme.ButtonColor.deactivatebg
    btn.isEnabled = false
}

func enableButton(_ btn: UIButton) {
    btn.backgroundColor = FloweyTheme.ButtonColor.activebg
    btn.isEnabled = true
}

func getMoneyStr(money: Int) -> String {
    let dollars = String(money / 100)
    let cents = String(format: "%02d", arguments: [money % 100])
    return "$\(dollars).\(cents)"
}


func is_flow(_ category: String) -> Bool {
    return category == "Lend" || category == "Borrow" || category == "Return" || category == "Receive"
}

func is_flow(_ cid: Int) -> Bool {
    return is_flow(categories[cid])
}

func is_flow_out(_ category: String) -> Bool {
    return category == "Lend" || category == "Return"
}

func is_flow_out(_ cid: Int) -> Bool {
    return is_flow_out(categories[cid])
}

func get_flow_text(_ flow: Int) -> String {
    if flow > 0 {
        return "You are owed"
    } else if flow < 0 {
        return "You owe"
    } else {
        return "All clear"
    }
}

func get_flow_color(_ flow: Int) -> UIColor {
    if flow > 0 {
        return Colorify.Nephritis
    } else if flow < 0 {
        return Colorify.Grenadine
    } else {
        return Colorify.Steel
    }
}

func get_flow_display_set(_ flow: Int) -> (String, UIColor) {
    return (get_flow_text(flow), get_flow_color(flow))
}

// "2018-12"
func get_this_month_date() -> String {
    let now = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM"
    return dateFormatter.string(from: now)
}
