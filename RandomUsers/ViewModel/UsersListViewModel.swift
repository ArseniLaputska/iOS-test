//
//  UsersListViewModel.swift
//  RandomUsers
//
//  Created by Arseni Laputska on 18.07.25.
//

import Foundation

enum UsersUpdate {
    case initial
    case appended(range: Range<Int>)
    case updated(rows: [Int])
}

protocol UsersListViewModelProtocol: AnyObject {
    var users: [User] { get }
    var didUpdate: ((UsersUpdate) -> Void)? { get set }
    var didFail: ((Error) -> Void)? { get set }
    
    func loadInitial()
    func loadNext()
    func didSelect(row: Int) -> User
}

final public class UsersListViewModel: UsersListViewModelProtocol {
    private let repo: UserProviderProtocol
    private(set) var users: [User] = []
    
    var didUpdate: ((UsersUpdate) -> Void)?
    var didFail: ((Error) -> Void)?
    
    private var page = 1
    private let perPage = 50
    private var isLoading = false
    
    init(repo: UserProviderProtocol) {
        self.repo = repo
    }
    
    func loadInitial() {
        users.removeAll()
        page = 1
        fetch()
    }
    
    func loadNext() {
        guard !isLoading else { return }
        page += 1
        fetch()
    }
    
    func didSelect(row: Int) -> User {
        users[row]
    }
    
    private func fetch() {
        isLoading = true
        repo.fetch(page: page, perPage: perPage) { [weak self] result in
            guard let self else { return }
            isLoading = false
            
            switch result {
                case let .success(new):
                    let start = users.count
                    users.append(contentsOf: new)
                    
                    let end = users.count
                    let range = start..<end
                    
                    didUpdate?(page == 1 ? .initial : .appended(range: range))
                case let .failure(error):
                    didFail?(error)
            }
        }
    }
    
}
