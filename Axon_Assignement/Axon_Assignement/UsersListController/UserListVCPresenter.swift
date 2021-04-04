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
        print(imageUrl)
        cell.userImage.downloaded(from: imageUrl)
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


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

