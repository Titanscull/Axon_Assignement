//
//  UserManager.swift
//  Axon_Assignement
//
//  Created by Ievgen Petrovskiy on 04.04.2021.
//

import Foundation

protocol UserEndPointProtocol: class {
    func fetchUsers(completion: @escaping ((Result<[User], NetworkError>) -> Void))
}

enum NetworkError: Error {
    case urlIsNotValid
    case sessionIsNotValid
    case brokenResponse
    case NoDataRecieved
    case unableToDecode
    case unexpectedStatusCode(Int)
}

class UserManager: UserEndPointProtocol {
    
//    /// Pegination
//    randomuser.me/api/?page=3&results=10&seed=abc
    
    let usersNumber = 20
    
    private lazy var url = "https://randomuser.me/api/?results=\(usersNumber)"
    
    let session = URLSession.shared
    
    func fetchUsers(completion: @escaping ((Result<[User], NetworkError>) -> Void)) {
        
        guard let url = URL(string: url) else {
            completion(.failure(.urlIsNotValid))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            
            if error != nil {
                completion(.failure(.sessionIsNotValid))
                print(error!.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.brokenResponse))
                return
            }
            
            switch response.statusCode {
            case 200..<201:
                guard let data = data else {
                    completion(.failure(.NoDataRecieved))
                    return
                }
                do {
                    let users = try JSONDecoder().decode(Users.self, from: data)
                    completion(.success(users.results))
                } catch {
                    completion(.failure(.unableToDecode))
                }
            default:
                completion(.failure(.unexpectedStatusCode(response.statusCode)))
            }
        }
    }
    
}
