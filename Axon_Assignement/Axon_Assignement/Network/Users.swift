//
//  UserResponse.swift
//  Axon_Assignement
//
//  Created by Ievgen Petrovskiy on 04.04.2021.
//

import Foundation

// MARK - User Response
struct Users: Codable {
    var results = [User]()
    var info : Info
}
