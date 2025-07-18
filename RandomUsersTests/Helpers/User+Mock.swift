//
//  User+Mock.swift
//  RandomUsers
//
//  Created by Arseni Laputska on 18.07.25.
//

import Foundation
@testable import RandomUsers

extension User {
    static let mock: User = {
        User(
            name: .init(title: "Ms", first: "Jane", last: "Doe"),
            email: "jane.doe@example.com",
            location: .init(
                city:  "Mockingbird Lane",
                state: "Mock City",
                country: "Mock State",
                street: .init(number: 1, name: "Mockland"),
                coordinates: .init(latitude: "0.0", longitude: "0.0")
            ),
            picture: .init(
                thumbnail: "https://example.com/thumb.jpg",
                medium:    "https://example.com/med.jpg",
                large:     "https://example.com/large.jpg"
            )
        )
    }()
    
    static let mockList: [User] = [
        .mock,
        User(
            name: .init(title: "Mr", first: "John", last: "Smith"),
            email: "john.smith@example.com",
            location: .init(
                city: "Testonia",
                state: "Demo Town",
                country: "Unit Province",
                street: .init(number: 42, name: "Test Street"),
                coordinates: .init(latitude: "51.5007", longitude: "-0.1246")
            ),
            picture: .init(
                thumbnail: "https://example.com/thumb2.jpg",
                medium:    "https://example.com/med2.jpg",
                large:     "https://example.com/large2.jpg"
            )
        )
    ]
}
