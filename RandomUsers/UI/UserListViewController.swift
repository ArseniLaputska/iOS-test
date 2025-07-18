//
//  UserListViewController.swift
//  RandomUsers
//
//  Created by Alejandro Guerra, DSpot on 9/13/21.
//

import Foundation
import UIKit

final class UserListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let userListViewModel: UsersListViewModelProtocol
    
    init(userListViewModel: UsersListViewModelProtocol) {
        self.userListViewModel = userListViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Random Users"
        view.backgroundColor = .systemBackground

        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.rowHeight = 60
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        bind()
        userListViewModel.loadInitial()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: true)
        }
    }
    
    private func bind() {
        userListViewModel.didUpdate = { [weak self] update in
            guard let self else { return }
            switch update {
            case .initial:
                tableView.reloadData()
            case let .appended(range):
                let idxPaths = range.map { IndexPath(row: $0, section: 0) }
                tableView.insertRows(at: idxPaths, with: .automatic)
            case let .updated(rows):
                let idxPaths = rows.map { IndexPath(row: $0, section: 0) }
                tableView.reloadRows(at: idxPaths, with: .automatic)
            }
        }

        userListViewModel.didFail = { [weak self] error in
            let alert = UIAlertController(
                title: "Error",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(.init(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        userListViewModel.users.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let user = userListViewModel.users[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseId, for: indexPath) as? UserCell else { return UITableViewCell() }
        cell.configure(with: user)
        
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == userListViewModel.users.count - 1 {
            userListViewModel.loadNext()
        }
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let user = userListViewModel.didSelect(row: indexPath.row)
        let userDetailsVC = UserDetailsViewController(user: user)
        navigationController?.pushViewController(userDetailsVC, animated: true)
    }
}

extension UserListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let user = userListViewModel.users[indexPath.row]
            if let url = URL(string: user.picture.thumbnail) {
                ImageLoader.shared.load(url) { _ in }
            }
        }
    }
}
