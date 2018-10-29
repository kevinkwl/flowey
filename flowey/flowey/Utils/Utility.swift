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
