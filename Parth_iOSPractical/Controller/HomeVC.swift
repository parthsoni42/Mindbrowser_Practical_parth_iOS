//
//  HomeVC.swift
//  Parth_iOSPractical
//
//  Created by Parth on 10/06/21.
//

import UIKit
import Swifter
import SDWebImage

class HomeVC: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var imgVwProfile: UIImageView!
    @IBOutlet weak var lblScreenName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblTotalFriends: UILabel!
    @IBOutlet weak var lblTotalFollowers: UILabel!
    
    //MARK:- Variables
    var objUser:User?
    var swiffer: Swifter?
    var navigationCon:UINavigationController?
    private var objFriend = Friends()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isModalInPresentation = true
        self.initialConfig()
    }
    
    //MARK:- Private Methods
    private func initialConfig() {
        
        self.imgVwProfile.layer.borderWidth = 2
        self.imgVwProfile.clipsToBounds = true
        self.imgVwProfile.layer.borderColor = UIColor.darkGray.cgColor
        self.imgVwProfile.layer.cornerRadius = imgVwProfile.frame.height / 2
        
        swiffer = Swifter(consumerKey: Constant.consumerKey, consumerSecret: Constant.consumerSecretKey, appOnly: true)
        
        self.onSetUserDetails()
    }
    
    private func onSetUserDetails() {
        
        self.title = "Welcome, \(self.objUser?.screenName ?? "")"
        self.lblScreenName.text = self.objUser?.screenName
        if let profileUrlIs = URL(string: self.objUser?.profileImage ?? "") {
            self.imgVwProfile.sd_setImage(with: profileUrlIs, completed: nil)
        }
        self.lblName.text = "Name: \(self.objUser?.firstName ?? "") \(self.objUser?.lastName ?? "")"
        self.lblEmail.text = "Email: \(self.objUser?.email ?? "")"
        self.lblTotalFriends.text = "Total Friends: 0"
        self.lblTotalFollowers.text = "Total Followers: 0"
        
        self.swiffer?.authorizeAppOnly(success: { (token, response) in
            
            //Following
            self.swiffer?.getUserFollowersIDs(for: .id(self.objUser?.userId ?? ""), success: { responseJson, prev, next in
                
                DispatchQueue.main.async {
                    if let arrData = responseJson.array {
            
                        self.lblTotalFriends.text = "Total Friends: \(arrData.count)"
                        self.objFriend.totalFollowers = arrData.count
                        
                        var arrFriends = [String]()
                        
                        for obj in arrData {
                            arrFriends.append(obj.description.toString())
                        }
                        self.objFriend.arrFollowerIds = arrFriends
                    }
                }
            }, failure: { error in
                print("LOG: \(#function): \(error.localizedDescription)")
            })
            
            self.getTotalUserFollowers()
            
        }, failure: { (errorIs) in
            print("LOG: \(#function): \(errorIs.localizedDescription)")
        })
    }
    
    private func getTotalUserFollowers(nextCursorIs: String = "") {

        //Following
        self.swiffer?.getUserFollowingIDs(for: .id(self.objUser?.userId ?? ""), success: { responseJson, prev, next in
            
            DispatchQueue.main.async {
                
                if let arrData = responseJson.array {
                    self.lblTotalFollowers.text = "Total Following: \(arrData.count)"
                    self.objFriend.totalFollowings = arrData.count
                    
                    var arrFollowers = [String]()
                    
                    for obj in arrData {
                        arrFollowers.append(obj.description.toString())
                    }
                    self.objFriend.arrFollowingIds = arrFollowers
                }
            }
        }, failure: { error in
            print("LOG: \(#function): \(error.localizedDescription)")
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnFollowers_click(_ sender: Any) {

        guard let objFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "FriendsVC") as? FriendsVC else {
            return
        }
        objFriendVC.objUser = self.objUser
        objFriendVC.objFriend = self.objFriend
        self.navigationCon?.pushViewController(objFriendVC, animated: true)
    }
    
    @IBAction func btnFollowing_click(_ sender: Any) {
        
        guard let objFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "FriendsVC") as? FriendsVC else {
            return
        }
        objFriendVC.objUser = self.objUser
        objFriendVC.isForFollowers = false
        objFriendVC.objFriend = self.objFriend
        self.navigationCon?.pushViewController(objFriendVC, animated: true)
    }

    @IBAction func btnLogout_click(_ sender: Any) {
        
        User.logOutUser()
        self.dismiss(animated: true, completion: nil)
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
