//
//  UserDecodingTests.swift
//  RandomUsers
//
//  Created by Arseni Laputska on 18.07.25.
//

import XCTest
@testable import RandomUsers

final class UserDecodingTests: XCTestCase {
    typealias UsersResponse = UserProvider.UsersResponse
    
    func testDecodingMinimalJSON() throws {
        let json = """
        { "results": [
            {
              "name":{"title":"Ms","first":"Jane","last":"Doe"},
              "email":"jane@doe.com",
              "location":{
                 "street":{"number":1,"name":"Baker"},
                 "city":"London",
                 "state":"London",
                 "country":"UK",
                 "coordinates":{"latitude":"0","longitude":"0"}
              },
              "picture":{
                 "thumbnail":"t.jpg",
                 "medium":"m.jpg",
                 "large":"l.jpg"
              }
            }
        ]}
        """.data(using: .utf8)!
        let decoded = try JSONDecoder().decode(UsersResponse.self, from: json)
        XCTAssertEqual(decoded.results.first?.email, "jane@doe.com")
    }
}
