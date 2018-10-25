//
//  RegisterViewController.swift
//  flowey
//
//  Created by Kangwei Ling on 2018/10/25.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextF: UITextField!
    @IBOutlet weak var pwdTextF: UITextField!
    @IBOutlet weak var pwdConfirmTextF: UITextField!
    @IBOutlet weak var nameTextF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Register(_ sender: UIButton) {
    }
    
    @IBAction func Login(_ sender: Any) {
        performSegue(withIdentifier: "goLogin", sender: self)
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
