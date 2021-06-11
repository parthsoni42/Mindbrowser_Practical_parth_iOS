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

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Private Methods
    private func initialConfig() {
        
    }
    
    //MARK:- IBActions
    @IBAction func btnLogin_click(_ sender: Any) {
            
        User().loginWithTwitter { (objUser) in
            if let obj = objUser {
                
                Utilies.showAlert("Success", message: "User Authentication Success", buttonTitle: "OK") {
                    
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
