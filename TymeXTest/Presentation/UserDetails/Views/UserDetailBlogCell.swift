//
//  UserDetailBlogCell.swift
//  TymeXTest
//
//  Created by Thanh Nhut on 18/8/24.
//

import UIKit
import SnapKit

class UserDetailBlogCell: UITableViewCell {
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        $0.textColor = .black
        $0.text = "Blog"
    }
    private let contentBlogLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .darkGray
        $0.text = "https://blog.abc"
        $0.numberOfLines = 0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        addSubviews(titleLabel, contentBlogLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(24)
            make.height.equalTo(24)
        }
        contentBlogLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(24)
            make.height.greaterThanOrEqualTo(20)
        }
    }
}
