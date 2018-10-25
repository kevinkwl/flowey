//
//  LoginViewController.swift
//  flowey
//
//  Created by Kangwei Ling on 2018/10/25.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextF: UITextField!
    @IBOutlet weak var pwdTextF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Register(_ sender: UIButton) {
        performSegue(withIdentifier: "goRegister", sender: self)
    }
    
    @IBAction func Login(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: Constant.hasLoginKey)
        print(UserDefaults.standard.bool(forKey: Constant.hasLoginKey))
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
