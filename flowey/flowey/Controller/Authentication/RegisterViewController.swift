//
//  RegisterViewController.swift
//  flowey
//
//  Created by Kangwei Ling on 2018/10/25.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextF: SkyFloatingLabelTextField!
    @IBOutlet weak var pwdTextF: SkyFloatingLabelTextField!
    @IBOutlet weak var pwdConfirmTextF: SkyFloatingLabelTextField!
    @IBOutlet weak var nameTextF: SkyFloatingLabelTextField!
    @IBOutlet weak var RegisterBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.emailTextF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.pwdTextF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.pwdConfirmTextF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.nameTextF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        checkRegister()
    }
    
    @IBAction func Register(_ sender: UIButton) {
        let emailText = emailTextF.text!
        let pwdText = pwdTextF.text!
        let pwdCText = pwdConfirmTextF.text!
        let nameText = nameTextF.text!
        
        if !isValidEmail(testStr: emailText) {
            self.emailTextF.errorMessage = "Invalid email"
            return
        }
        if !isValidEmail(testStr: emailText) || pwdText.count == 0 || pwdText != pwdCText || nameText.count == 0 {
            return
        }
        
        FloweyAPI.register(emailText, pwdText, nameText, onSuccess: { [weak self] () in
            // set login
            print("registered!")
            self?.performSegue(withIdentifier: "goLogin", sender: self)
        }, onFailure: { (error) in
            print(error)
        })
    }
    
    @IBAction func Login(_ sender: Any) {
        performSegue(withIdentifier: "goLogin", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailTextF {
            pwdTextF.becomeFirstResponder()
        } else if textField == pwdTextF {
            pwdConfirmTextF.becomeFirstResponder()
        } else if textField == pwdConfirmTextF {
            nameTextF.becomeFirstResponder()
        } else {
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
        } else if textfield == self.pwdConfirmTextF {
            if let p1 = self.pwdTextF.text {
                if let p2 = textfield.text {
                    if p1 != p2 {
                        self.pwdConfirmTextF.errorMessage = "Password does not match"
                    } else {
                        self.pwdConfirmTextF.errorMessage = ""
                    }
                }
            }
        }
        checkRegister()
    }
    
    func checkRegister() {
        if let email = self.emailTextF.text, let pwd = self.pwdTextF.text, let pwdc = self.pwdConfirmTextF.text
            , let name = self.nameTextF.text {
            print(email, pwd, pwdc, name)
            if isValidEmail(testStr: email) && !pwd.isEmpty && pwdc == pwd && !name.isEmpty {
                enableButton(self.RegisterBtn)
                return
            }
        }
        disableButton(self.RegisterBtn)
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
