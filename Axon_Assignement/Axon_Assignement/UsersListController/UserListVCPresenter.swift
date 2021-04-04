//
//  UserListVCPresenter.swift
//  Axon_Assignement
//
//  Created by Ievgen Petrovskiy on 04.04.2021.
//

import UIKit

class UserListVCPresenter {
    
    var users = [User]()
    
    var usersCount: Int {
        return users.count
    }
    
    let manager = UserManager()
    
    private weak var view: UserListVC?
    
    init(view: UserListVC) {
        self.view = view
    }
    
    func setupCell(_ cell: UITableViewCell) {
    }
    
    func getUsers() {
        manager.fetchUsers { result in
            switch result {
            case .success(let users):
                self.users = users
                print(users.count)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
