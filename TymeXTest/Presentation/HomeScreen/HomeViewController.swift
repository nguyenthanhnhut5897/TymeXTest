//
//  HomeViewController.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/14.
//

import UIKit

class HomeViewController: BaseViewController {
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    
    private var vm: HomeViewModel?
    
    convenience init(viewModel: HomeViewModel?) {
        self.init()
        
        self.vm = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        vm?.fetchData()
    }
    
    override func bind() {
        vm?.userList.observe(on: self) { [weak self] _ in
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
        title = "Github Users"
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
        tableView.regisCells(GithubUserCell.className)
        
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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm?.userList.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (vm?.userList.value.count ?? 0) - 1 {
            vm?.loadMoreIfNeed()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GithubUserCell.className, for: indexPath) as? GithubUserCell else {
            return UITableViewCell().then {
                $0.selectionStyle = .none
            }
        }
        
        let user = vm?.userList.value[safe: indexPath.row]
        
        cell.bindData(user: user)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vm?.didSelectItem(at: indexPath.row)
    }
}
