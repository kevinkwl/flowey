//
//  SettingViewController.swift
//  flowey
//
//  Created by Kangwei Ling on 2018/10/25.
//  Copyright © 2018 duckduckrush. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var logoutButtonView: UIButton!
    @IBOutlet weak var icons8: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        logoutButtonView.cornerRadius = logoutButtonView.bounds.height / 2
        logoutButtonView.backgroundColor = Colorify.Alizarin
        logoutButtonView.setTitleColor(UIColor.white, for: .normal)
        
        icons8.text = """
        Icons provided by
        Icons8 https://icons8.com
        """
    }
    

    @IBAction func logout(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: Constants.hasLoginKey)
        FloweyAPI.logout(onSuccess: { () in
            
            }, onFailure: { (error) in
                print(error)
        })
        performSegue(withIdentifier: "logout", sender: self)
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
