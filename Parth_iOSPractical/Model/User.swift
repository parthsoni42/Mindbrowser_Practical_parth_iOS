//
//  User.swift
//  Parth_iOSPractical
//
//  Created by Parth on 10/06/21.
//

import Foundation
import TwitterKit

class User {

    var oAuthToken: String = ""
    var authToken: String = ""
    var authSecret:String = ""
    var userId: String = ""
    var userName: String = ""
    var screenName: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var profileImage:String = ""
    
    var totalFriends:Int = 0
    var totalFollowers:Int = 0
    
    //MARK:- Twitter SignIn
    func loginWithTwitter(success withResponse: @escaping (User?) -> (), error withError: @escaping (String) -> ()) {
        
        User.logOutUser() //logout user first.
        
        if TWTRTwitter.sharedInstance().sessionStore.session() == nil {
            
            TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
                
                if (session != nil) {
                    
                    //Get client
                    let client = TWTRAPIClient(userID: session?.userID)
                    
                    //Check for emailId
                    client.requestEmail { email, error in
                        if (email != nil) {
                            self.email = email!
                            print("signed in as \(String(describing: session?.userName))");
                        } else {
                            withError(error?.localizedDescription ?? "")
                        }
                    }
                    
                    //User details
                    client.loadUser(withID: (session?.userID)!, completion: { (user, error) -> Void in
                        
                        if let userIdIs = session?.userID {
                            self.userId = userIdIs
                            self.authToken = session?.authToken ?? ""
                            self.authSecret = session?.authTokenSecret ?? ""
                            self.userName = session?.userName ?? ""
                        }
                        if user?.name != nil {
                            let fullNameArr = user!.name.components(separatedBy: " ")
                            if fullNameArr.count > 0 {
                                self.firstName = fullNameArr[0]
                            }
                            if fullNameArr.count > 1 {
                                self.lastName = fullNameArr[1]
                            }
                        }
                        
                        //To get profile image url and screen name
                        self.screenName = user?.screenName ?? ""
                        self.profileImage = user?.profileImageLargeURL ?? ""
                        
                        withResponse(self)
                        
                    })
                } else {
                    withError(error?.localizedDescription ?? "")
                    print("error: \(String(describing: error?.localizedDescription))");
                }
            })
        } else {
            withError("Something went wrong")
        }
    }
    
    class func logOutUser() {
        //Twitter logout
        let store = TWTRTwitter.sharedInstance().sessionStore
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
        }
    }
}
