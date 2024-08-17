//
//  UserDetailFollowCell.swift
//  TymeXTest
//
//  Created by Thanh Nhut on 7/5/24.
//  Copyright © 2024 Mediastep. All rights reserved.
//

import UIKit

class UserDetailFollowCell: UITableViewCell {
    @IBOutlet weak var followerNumberLabel: UILabel!
    @IBOutlet weak var followerTitleLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    @IBOutlet weak var followingTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        followerTitleLabel.text = "Follower"
        followingTitleLabel.text = "Following"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        followerNumberLabel.text = nil
        followingNumberLabel.text = nil
    }
    
    func bindData(user: CUser?) {
        followerNumberLabel.text = "\(user?.followers ?? 0)"
        followingNumberLabel.text = "\(user?.following ?? 0)"
    }
}
