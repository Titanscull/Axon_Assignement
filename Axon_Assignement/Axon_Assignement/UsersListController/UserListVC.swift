//
//  UserListVC.swift
//  Axon_Assignement
//
//  Created by Ievgen Petrovskiy on 04.04.2021.
//

import UIKit

class UserListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var presenter = UserListVCPresenter(view: self)
    private let manager = UserManager()
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        presenter.viewDidLoad()
    }
    
    func setupDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension UserListVC: UITableViewDelegate {
    
}
extension UserListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.usersCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserTableViewCell
        presenter.setupCell(cell, indexpath: indexPath)
        return cell
    }
}

extension UserListVC: UserListVCPresenterView {
    func refreshTableView() {
        tableView.reloadData()
    }
}
