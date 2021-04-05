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
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegates()
        presenter.viewDidLoad()
        
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
        // MARK - temporary array of selected user
        self.user = presenter.users[tableView.indexPathForSelectedRow!.row]
        print(user!)
        performSegue(withIdentifier: "SeeDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeDetails" {
            
            guard let detailVC = segue.destination as? DetailVC else {return}
            _ = detailVC.view
            
            detailVC.fullNameLabel.text = user?.fullName
            detailVC.genderLabel.text = user?.gender.uppercased()
            detailVC.dobLabel.text = formatDate(date: user!.dob.date)
            detailVC.phoneLabel.text = "\(String(describing: user!.cell))"
            let imageUrl = user!.picture.large
            detailVC.userImageView.downloaded(from: imageUrl)
            detailVC.userImageView.layer.masksToBounds = true
            detailVC.userImageView.layer.cornerRadius = detailVC.userImageView.frame.height / 2
            
        }
    }
    
    // MARK - Use to formate DOB
    func formatDate(date: String) -> String {
       let dateFormatterGet = DateFormatter()
       dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

       let dateFormatter = DateFormatter()
       dateFormatter.dateStyle = .medium
       dateFormatter.timeStyle = .none

       let dateObj: Date? = dateFormatterGet.date(from: date)

       return dateFormatter.string(from: dateObj!)
    }
    
}

extension UserListVC: UserListVCPresenterView {
    func refreshTableView() {
        tableView.reloadData()
    }
}
