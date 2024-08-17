//
//  LaunchScreenViewController.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/04.
//

import UIKit

class LaunchScreenViewController: BaseViewController {
    var titleLabel = UILabel().then {
        $0.text = "TymeXTest"
        $0.textAlignment = .center
        $0.backgroundColor = .red
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(165)
            $0.height.equalTo(112)
        }
    }
}
