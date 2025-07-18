//
//  UserProviderProtocol.swift
//  RandomUsers
//
//  Created by Alejandro Guerra, DSpot on 9/13/21.
//

import Foundation
import Moya

public protocol UserProviderProtocol {
    func fetch(
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[User], Error>) -> Void
    )
}
