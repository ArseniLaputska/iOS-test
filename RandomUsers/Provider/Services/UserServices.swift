//
//  UserServices.swift
//  RandomUsers
//
//  Created by Alejandro Guerra, DSpot on 9/13/21.
//

import Foundation
import Moya

enum UserServices {
    case users(page: Int, results: Int)
}

extension UserServices: TargetType {
    var baseURL: URL {
        return URL(string: "https://randomuser.me/api")!
    }

    var path: String {
        return "/"
    }

    var method: Moya.Method {
        .get
    }

    var sampleData: Data {
        switch self {
        default:
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        }
    }

    var task: Task {
        switch self {
            case let .users(page, results):
                let params: [String: Any] = [
                    "page": page,
                    "results": results,
                    "seed": "ios‑test",
                    "inc": "name,email,location,picture"
                ]
                return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            }
    }

    var headers: [String: String]? {
        nil
    }

}
