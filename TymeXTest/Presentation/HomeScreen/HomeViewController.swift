//
//  HomeViewController.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/14.
//

import UIKit

class HomeViewController: BaseViewController {

    let titleLabel = UILabel().then {
        $0.text = ""
        $0.textAlignment = .center
        $0.backgroundColor = .blue
    }
    
    private var viewModel: HomeViewModel?
    
    convenience init(viewModel: HomeViewModel?) {
        self.init()
        
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        viewModel?.fetchData()
        viewModel?.fetchUserProfileData()
    }
    
    private func bind(to viewModel: HomeViewModel) {
        viewModel.title.observe(on: self) { [weak self] in self?.titleLabel.text = $0 }
    }
    
    override func setupViews() {
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.text = viewModel?.title.value
    }
}
