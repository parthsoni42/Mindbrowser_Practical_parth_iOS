//
//  LoginVC.swift
//  Parth_iOSPractical
//
//  Created by Parth on 10/06/21.
//

import UIKit
import TwitterKit

class LoginVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var btnLogin: UIButton!
    
    //MARK:- Variables
    private var objCurrentUser:User?
    
    //MARK:- Page Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Login"
    }
    
    //MARK:- IBActions
    @IBAction func btnLogin_click(_ sender: Any) {
        
        User().loginWithTwitter { (objUser) in
            if let obj = objUser {
                
                Utilies.showAlert("Success", message: "Authentication Success!", buttonTitle: "OK") {
                    
                    guard let objHomeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else {
                        return
                    }
                    objHomeVC.objUser = obj
                    let navigationVC = UINavigationController(rootViewController: objHomeVC)
                    objHomeVC.navigationCon = navigationVC
                    self.present(navigationVC, animated: true, completion: nil)
                }
            }
        } error: { (errorIs) in
            Utilies.showAlert("Error", message: errorIs, buttonTitle: "OK") {
            }
        }
    }
}
