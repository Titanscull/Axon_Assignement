//
//  User.swift
//  Axon_Assignement
//
//  Created by Ievgen Petrovskiy on 04.04.2021.
//

import UIKit

// MARK: - User
struct User: Codable {
    let gender: String
    let name: Name
    let dob: Dob
    let phone, cell: String
    let id: ID
    let picture: Picture
    var fullName: String {
        return "\(name.title) \(name.first) \(name.last)"
    }
}
// MARK: - ID
struct ID: Codable {
    let name: String
    let value: String?
}

// MARK: - Name
struct Name: Codable {
    let title, first, last: String
}

// MARK: - Dob
struct Dob: Codable {
    let date: String
    let age: Int
}

// MARK: - Picture
struct Picture: Codable {
    let large, medium, thumbnail: String
}
