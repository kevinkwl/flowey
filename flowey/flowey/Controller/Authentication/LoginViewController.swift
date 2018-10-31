//
//  LoginViewController.swift
//  flowey
//
//  Created by Kangwei Ling on 2018/10/25.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextF: SkyFloatingLabelTextField!
    @IBOutlet weak var pwdTextF: SkyFloatingLabelTextField!
    @IBOutlet weak var LoginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.emailTextF.title = "Email"
        self.pwdTextF.title = "Password"
        
        self.emailTextF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.pwdTextF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        checkLogin()
    }
    
    @IBAction func Register(_ sender: UIButton) {
        performSegue(withIdentifier: "goRegister", sender: self)
    }
    
    @IBAction func Login(_ sender: UIButton) {
        let emailText = emailTextF.text!
        let pwdText = pwdTextF.text!
        
        if !isValidEmail(testStr: emailText) || pwdText.count == 0 {
            return
        }
        FloweyAPI.login(emailText, pwdText, onSuccess: { [weak self] () in
            // set login
            setLogin()
            
            self?.performSegue(withIdentifier: "loginSucceed", sender: self)
        }, onFailure: { (error) in
            print(error)
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailTextF {
            pwdTextF.becomeFirstResponder()
        } else if textField == pwdTextF {
            // do nothing
        }
        return true
    }
    
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if textfield == self.emailTextF {
            if let text = textfield.text {
                if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                    if(!isValidEmail(testStr: text)) {
                        floatingLabelTextField.errorMessage = "Invalid email"
                    }
                    else {
                        // The error message will only disappear when we reset it to nil or empty string
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
        }
        checkLogin()
    }
    
    func checkLogin() {
        if let email = self.emailTextF.text, let pwd = self.pwdTextF.text, isValidEmail(testStr: email) && !pwd.isEmpty {
            enableButton(self.LoginBtn)
        } else {
            disableButton(self.LoginBtn)
        }
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
