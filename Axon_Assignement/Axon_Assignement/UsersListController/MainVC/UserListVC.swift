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
    
    var users: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        presenter.viewDidLoad()
        //        print(users!)
    }
    
    // MARK - Setting up table view
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.users = presenter.users[tableView.indexPathForSelectedRow!.row]
        print(users!)
        performSegue(withIdentifier: "SeeDetails", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeDetails" {
            guard let detailVC = segue.destination as? DetailVC else {return}
            _ = detailVC.view
            
            detailVC.fullNameLabel.text = users?.fullName
            detailVC.genderLabel.text = users?.gender
            detailVC.dobLabel.text = "\(String(describing: users!.dob.date))"
            detailVC.phoneLabel.text = "\(String(describing: users!.phone))"
            let imageUrl = "\(users!.picture.large)"
            detailVC.userImageView.downloaded(from: imageUrl)
            detailVC.userImageView.layer.masksToBounds = true
            detailVC.userImageView.layer.cornerRadius = detailVC.userImageView.frame.height / 4
        }
    }
}

extension UserListVC: UserListVCPresenterView {
    func refreshTableView() {
        tableView.reloadData()
    }
}
