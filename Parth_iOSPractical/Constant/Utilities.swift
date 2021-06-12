//
//  Utilities.swift
//  Parth_iOSPractical
//
//  Created by Parth on 11/06/21.
//
import UIKit
import Foundation

class Utilies {
    
    static func showAlert(_ title : String, message : String, buttonTitle: String, onClickCallback : @escaping (()->())) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title:"OK", style: UIAlertAction.Style.default,  handler: {
            action in
            onClickCallback()
            alert.dismiss(animated: true, completion: nil)
        }))
        let rootView : UINavigationController = UIApplication.shared.delegate?.window!?.rootViewController as! UINavigationController
        
        rootView.topViewController?.present(alert, animated: true, completion: nil)
    }
}

extension UITableView {
    
    func registerCell<T: UITableViewCell>(ofType type: T.Type) {
        let cellName = String(describing: T.self)
        
        if Bundle.main.path(forResource: cellName, ofType: "nib") != nil {
            let nib = UINib(nibName: cellName, bundle: Bundle.main)
            register(nib, forCellReuseIdentifier: cellName)
        } else {
            register(T.self, forCellReuseIdentifier: cellName)
        }
    }
}

extension String {
    
    func toString() -> String {
        return self.replacingOccurrences(of: "\"", with: "")
    }
    
    func getHDImageUrl() -> String {
        return self.replacingOccurrences(of: "_normal", with: "_bigger")
    }
}
