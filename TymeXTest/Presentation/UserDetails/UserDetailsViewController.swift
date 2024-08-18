//
//  UserDetailsViewController.swift
//  TymeXTest
//
//  Created by Thanh Nhut on 18/8/24.
//

import UIKit

class UserDetailsViewController: BaseViewController {
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    
    private var vm: UserDetailsVM?
    
    convenience init(viewModel: UserDetailsVM?) {
        self.init()
        
        self.vm = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        vm?.fetchData()
    }
    
    override func bind() {
        vm?.userInfo.observe(on: self) { [weak self] _ in
            executeBlockOnMainIfNeeded { [weak self] in
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
        
        vm?.error.observe(on: self) { [weak self] _ in
            executeBlockOnMainIfNeeded { [weak self] in
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    override func setupViews() {
        title = "User Details"
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.estimatedRowHeight = 44
        tableView.sectionHeaderHeight = CGFloat.leastNonzeroMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.regisCells(GithubUserCell.className,
                             UserDetailFollowCell.className)
        tableView.registerCells(UserDetailBlogCell.self)
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshDataInfo), for: .valueChanged)
    }
    
    @objc func refreshDataInfo() {
        vm?.fetchData(isRefresh: true)
    }
}

extension UserDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDetailsCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = UserDetailsCellType(rawValue: indexPath.row)
        
        switch cellType {
        case .general:
            return generalCell(tableView, cellForRowAt: indexPath)
        case .followerFollowing:
            return followCell(tableView, cellForRowAt: indexPath)
        case .blog:
            return blogCell(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell().then {
                $0.selectionStyle = .none
                $0.backgroundColor = .gray
            }
        }
    }
    
    func generalCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GithubUserCell.className, for: indexPath) as? GithubUserCell else {
            return UITableViewCell().then {
                $0.selectionStyle = .none
            }
        }
        
        cell.bindData(user: vm?.userInfo.value, mode: .detail)
        
        return cell
    }
    
    func followCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailFollowCell.className, for: indexPath) as? UserDetailFollowCell else {
            return UITableViewCell().then {
                $0.selectionStyle = .none
            }
        }
        
        cell.bindData(user: vm?.userInfo.value)
        
        return cell
    }
    
    func blogCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailBlogCell.className, for: indexPath) as? UserDetailBlogCell else {
            return UITableViewCell().then {
                $0.selectionStyle = .none
            }
        }
        
        return cell
    }
}
