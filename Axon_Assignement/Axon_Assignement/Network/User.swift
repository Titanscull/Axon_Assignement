//
//  User.swift
//  Axon_Assignement
//
//  Created by Ievgen Petrovskiy on 04.04.2021.
//

import Foundation

// MARK: - User
struct User: Decodable {
    let gender: String
    let name: Name
    let dob, registered: Dob
    let phone, cell: String
    let picture: Picture
    var fullName: String {
        return "\(name.title) \(name.first) \(name.last)"
    }
}

// MARK: - Name
struct Name: Decodable {
    let title, first, last: String
}

// MARK: - Dob
struct Dob: Decodable {
    let date: String
    let age: Int
}

// MARK: - Picture
struct Picture: Decodable {
    let large, medium, thumbnail: String
}
