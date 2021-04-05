//
//  UserListVCPresenter.swift
//  Axon_Assignement
//
//  Created by Ievgen Petrovskiy on 04.04.2021.
//

import UIKit

protocol UserListVCPresenterView: class {
    func refreshTableView()
}

class UserListVCPresenter {
    
    private weak var view: UserListVC?
    
    init(view: UserListVC) {
        self.view = view
    }
    
    var users = [User]()
    
    var usersCount: Int {
        return users.count
    }
    
    let manager = UserManager()
    
    func setupCell(_ cell: UserTableViewCell, indexpath: IndexPath) {
        cell.userFullNameLabel.text = users[indexpath.row].fullName
        
        let imageUrl = "\(users[indexpath.row].picture.thumbnail)"
        cell.userImage.downloaded(from: imageUrl)
        
        cell.userImage.layer.masksToBounds = true
        cell.userImage.layer.cornerRadius = (cell.userImage.frame.height / 2)
    }
    
    func viewDidLoad() {
        manager.fetchUsers { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let users):
                self?.users = users
                print(users.first!.picture)
                DispatchQueue.main.async {
                    self?.view?.refreshTableView()
                }
            }
        }
    }
    
}




