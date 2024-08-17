//
//  GithubUserCell.swift
//  BeeCow
//
//  Created by Thanh Nhut on 7/5/24.
//  Copyright © 2024 Mediastep. All rights reserved.
//

import UIKit

enum GithubUserCellMode {
    case list
    case detail
}

class GithubUserCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var landingPageLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var data: CUser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.roundCornersAndDropShadow(cRadius: 8, sColor: UIColor.gray, sOpacity: 0.25, sOffset: .zero, sBlur: 50, sSpread: 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImageView.image = nil
        addressLabel.text = nil
        landingPageLabel.attributedText = nil
        usernameLabel.text = nil
    }
    
    func bindData(user: CUser?, mode: GithubUserCellMode = .list) {
        self.data = user
        
        addressLabel.superview?.isHidden = mode == .list
        landingPageLabel.isHidden = mode == .detail
        usernameLabel.text = user?.username
        addressLabel.text = user?.location
        setLandingPageUrl()
        
        if let avatarUrl = user?.avatarUrl, !avatarUrl.isEmpty {
            avatarImageView.loadImage(avatarUrl)
        }
    }
    
    private func setLandingPageUrl() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(linkTapped))
        let linkText = self.data?.landingPageUrl ?? ""
        let attributedString = NSMutableAttributedString(string: linkText, 
                                                         attributes: [.link : linkText,
                                                                      .underlineStyle: NSUnderlineStyle.single.rawValue])
        landingPageLabel.attributedText = attributedString
        landingPageLabel.isUserInteractionEnabled = true
        landingPageLabel.textColor = .systemBlue
        landingPageLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func linkTapped() {
        if let landingPageUrl = self.data?.landingPageUrl, let url = URL(string: landingPageUrl) {
            UIApplication.shared.open(url)
        }
    }
}
