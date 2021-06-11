//
//  UserListCell.swift
//  Parth_iOSPractical
//
//  Created by Parth on 11/06/21.
//

import UIKit

class UserListCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        
        self.imgUser.layer.borderWidth = 2
        self.imgUser.layer.borderColor = UIColor.darkGray.cgColor
        self.imgUser.layer.cornerRadius = self.imgUser.frame.height / 2
    }
}
