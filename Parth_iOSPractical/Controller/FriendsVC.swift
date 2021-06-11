//
//  FriendsVC.swift
//  Parth_iOSPractical
//
//  Created by Parth on 11/06/21.
//

import UIKit
import Swifter

class FriendsVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tblFriends: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    //MARK:- Variables
    var objUser: User?
    var objFriend:Friends?
    var isForFollowers:Bool = true
    private var maxFetchLimit = 20
    private var totalRecords = 0
    private var isLoadMore = false
    private var arrUsers = [Friends]()
    private var swiffer = Swifter(
        consumerKey: Constant.consumerKey,
        consumerSecret: Constant.consumerSecretKey
    )
    private var currentIndex = 0
    private var activityIndicator = UIActivityIndicatorView()
    
    //MARK:- Page lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialConfig()
        self.isModalInPresentation = true
    }
    
    //MARK:- Private Methods
    private func initialConfig() {
        
        self.title = isForFollowers ? "My followers" : "Following"
        self.tblFriends.delegate = self
        self.tblFriends.dataSource = self
        self.tblFriends.registerCell(ofType: UserListCell.self)
        
        //Add Activity Indicator in footer
        self.activityIndicator = UIActivityIndicatorView(style: .medium)
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: self.tblFriends.frame.size.width, height: 44)
        self.activityIndicator.backgroundColor = UIColor.clear
        self.tblFriends.tableFooterView = self.activityIndicator
        
        self.showLoader()
        swiffer = Swifter(consumerKey: Constant.consumerKey, consumerSecret: Constant.consumerSecretKey, appOnly: true)
        
        self.swiffer.authorizeAppOnly(success: { (token, response) in
            
            DispatchQueue.main.async {
                self.getUserDetails()
            }
            
        }, failure: { (errorIs) in
            print(errorIs)
            self.hideLoader()
            Utilies.showAlert("Error", message: errorIs.localizedDescription, buttonTitle: "OK") {
            }
        })
    }
    
    private func onSetData(_ response: JSON) {
        
        let obj = Friends.init()
        obj.strName = response["name"].description.toString()
        obj.strProfileImage = response["profile_image_url_https"].description.toString()
        
        self.arrUsers.append(obj)
        
        DispatchQueue.main.async {
            self.hideLoader()
            self.isLoadMore = false
            self.activityIndicator.stopAnimating()
            self.tblFriends.reloadData()
        }
    }
    
    private func getUserDetails() {
        
        if let arrData = self.isForFollowers ? self.objFriend?.arrFollowerIds : self.objFriend?.arrFollowingIds {
            
            self.totalRecords = arrData.count //Total records.
            
            let arrFirstCusrsor = arrData.prefix(maxFetchLimit) //Iterate first 20 records. after thn call by lazy loading.
            
            for userId in arrFirstCusrsor {
                
                self.swiffer.showUser(.id(userId), success: { response in
                    
                    self.onSetData(response)
                    
                }, failure: { error in
                    self.hideLoader()
                    self.isLoadMore = false
                    self.activityIndicator.stopAnimating()
                    print("LOG: \(#function): \(error.localizedDescription)")
                })
                
                if self.arrUsers.count == self.maxFetchLimit {
                    break
                }
            }
        } else {
            self.hideLoader()
        }
    }
    
    private func getMoreFriends() {
        
        if totalRecords > self.arrUsers.count {
            
            let lastIndex = self.arrUsers.count
            
            if totalRecords > lastIndex {
                
                if let arrData = self.isForFollowers ? self.objFriend?.arrFollowerIds : self.objFriend?.arrFollowingIds {
                    
                    var countIs = 0
                    
                    for index in lastIndex..<arrData.count {
                        countIs += 1
                        self.swiffer.showUser(.id(arrData[index]), success: { response in
                            
                            self.onSetData(response)
                        }, failure: { error in
                            self.hideLoader()
                            self.isLoadMore = false
                            self.activityIndicator.stopAnimating()
                            print("LOG: \(#function): \(error.localizedDescription)")
                        })
                        
                        //if countIs == self.maxFetchLimit {
                        //break
                        //}
                    }
                }
            }
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func showLoader() {
        self.loader.isHidden = false
        self.loader.startAnimating()
    }
    
    private func hideLoader() {
        self.loader.isHidden = true
        self.loader.stopAnimating()
    }
}

//MARK:- UITableView Delegate & DataSource
extension FriendsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as! UserListCell
        
        if self.arrUsers.count > indexPath.row {
            
            let objUser = self.arrUsers[indexPath.row]
            
            cell.lblName.text = objUser.strName
            cell.imgUser.sd_setImage(with: URL(string: objUser.strProfileImage), placeholderImage: #imageLiteral(resourceName: "thumbnail"))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

//MARK:- UIScrollView Delegate
extension FriendsVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let visibleCell = self.tblFriends.visibleCells.last,
           let indexPathForCell = self.tblFriends.indexPath(for: visibleCell) {
            let lastFifth = self.arrUsers.count - 5
            if indexPathForCell.row == lastFifth && !self.isLoadMore {
                
                self.activityIndicator.startAnimating()
                self.isLoadMore = true
                self.getMoreFriends()
            }
        }
    }
}
