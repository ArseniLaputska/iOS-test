//
//  UserProvider.swift
//  RandomUsers
//
//  Created by Alejandro Guerra, DSpot on 9/13/21.
//

import Foundation
import Moya

final public class UserProvider: UserProviderProtocol {
    private let service: MoyaProvider<UserServices>
    
    init(service: MoyaProvider<UserServices> = .init()) {
        self.service = service
    }
    
    public func fetch(
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[User], Error>) -> Void
    ) {
        service.request(.users(page: page, results: perPage)) { result in
            switch result {
            case let .success(response):
                completion(
                    Result {
                        try JSONDecoder().decode(UsersResponse.self, from: response.data).results
                    }
                )
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
}

public extension UserProvider {
    public struct UsersResponse: Decodable {
        let results: [User]
    }
}
