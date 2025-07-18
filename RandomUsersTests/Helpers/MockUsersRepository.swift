//
//  MockUsersRepository.swift
//  RandomUsers
//
//  Created by Arseni Laputska on 18.07.25.
//


import Foundation
@testable import RandomUsers

final class MockUsersRepository: UserProviderProtocol {
    var sampleUsers: [User] = [.mock]
    var shouldFail = false

    func fetch(
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[User], Error>) -> Void
    ) {
        DispatchQueue.main.async {
            self.shouldFail
                ? completion(.failure(NSError(domain: "Test", code: 1)))
                : completion(.success(self.sampleUsers))
        }
    }
}
