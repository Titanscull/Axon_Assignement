//
//  UserManager.swift
//  Axon_Assignement
//
//  Created by Ievgen Petrovskiy on 04.04.2021.
//

import Foundation

protocol UserEndPointProtocol: class {
    func fetchUsers(completion: @escaping ((Result<[User], NetworkError>) -> Void))
    func fetchMoreUsers(pagination: Bool, completion: @escaping ((Result<[User], NetworkError>) -> Void))
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
    
    public var isPaginating = false
    
    private var usersNumber : Int = 20
    
    private var currentPage: Int = 0
    
    private lazy var url = "https://randomuser.me/api/?page=\(currentPage)&results=\(usersNumber)&seed=abc"
    
    private let session = URLSession.shared
    
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
                print("No response")
                return
            }
            
            switch response.statusCode {
            case 200...201:
                guard let data = data else {
                    completion(.failure(.NoDataRecieved))
                    print("No data recieved")
                    return
                }
                do {
                    let users = try JSONDecoder().decode(Users.self, from: data)
                    completion(.success(users.results))
                    self.currentPage = users.info.page
                } catch {
                    completion(.failure(.unableToDecode))
                }
            default:
                completion(.failure(.unexpectedStatusCode(response.statusCode)))
            }
        }.resume()
    }
    
    func fetchMoreUsers(pagination: Bool = false, completion: @escaping ((Result<[User], NetworkError>) -> Void)) {
        
        if pagination {
            isPaginating = true
        }
        
        self.currentPage += 1
        print("Current page now is \(currentPage)")
        
        guard let url = URL(string: "https://randomuser.me/api/?page=\(currentPage)&results=\(usersNumber)&seed=abc") else {
            completion(.failure(.urlIsNotValid))
            return
        }
        
        print("Url for current page is \(url)")
        
        session.dataTask(with: url) { data, response, error in
            
            if error != nil {
                completion(.failure(.sessionIsNotValid))
                print(error!.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.brokenResponse))
                print("No response")
                return
            }
            
            switch response.statusCode {
            case 200...201:
                guard let data = data else {
                    completion(.failure(.NoDataRecieved))
                    print("No data recieved")
                    return
                }
                do {
                    let users = try JSONDecoder().decode(Users.self, from: data)
                    completion(.success(users.results))
                    
                    // Stop peginating
                    if pagination {
                        self.isPaginating = false
                    }
                } catch {
                    completion(.failure(.unableToDecode))
                }
            default:
                completion(.failure(.unexpectedStatusCode(response.statusCode)))
            }
        }.resume()
    }
    
}
