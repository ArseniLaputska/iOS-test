//
//  User.swift
//  RandomUsers
//
//  Created by Arseni Laputska on 18.07.25.
//

import Foundation

public struct User: Decodable, Identifiable {
    struct Name: Decodable {
        let title, first, last: String
    }
    
    struct Location: Decodable {
        struct Coord: Decodable {
            let latitude, longitude: String
        }
        
        struct Street: Decodable {
            let number: Int
            let name: String
        }
        
        let city, state, country: String
        let street: Street
        let coordinates: Coord
    }
    
    struct Picture: Decodable {
        let thumbnail, medium, large: String
    }

    public var id = UUID()
    let name: Name
    let email: String
    let location: Location
    let picture: Picture
    
    private enum CodingKeys: String, CodingKey {
        case name, email, location, picture
    }
    
}
