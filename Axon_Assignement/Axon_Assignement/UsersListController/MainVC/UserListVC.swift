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
    
    // MARK - Temporary array to use with DetailVC
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

// MARK - extensions to TableView & sending data to DetailVC logic
extension UserListVC: UITableViewDelegate {
}

extension UserListVC: UITableViewDataSource {
    
    // Number of sections to display
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.usersCount
    }
    
    // Set up Cell with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserTableViewCell
        presenter.setupCell(cell, indexpath: indexPath)
        
        return cell
    }
    
    // If user taps on Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // MARK - temporary array of selected user
        self.user = presenter.users[tableView.indexPathForSelectedRow!.row]
        print(user!)
        performSegue(withIdentifier: "SeeDetails", sender: self)
        
    }
    
    // MARK - Set up DetailVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeDetails" {
            
            guard let detailVC = segue.destination as? DetailVC else {return}
            
            _ = detailVC.view
            
            detailVC.fullNameLabel.text = "\(user?.fullName ?? "Unknown")"
            detailVC.genderLabel.text = "Gender: \(user?.gender ?? "Unknown")"
            detailVC.dobLabel.text = "Date of Birth : \(formatDate(date: user?.dob.date ?? "Unknow date of birth"))"
            detailVC.phoneLabel.text = "tel/fax: \(user?.phone ?? "No city phone")"
            detailVC.mobilePhoneLabel.text = "mob: \(user?.cell ?? "No cell phone")"
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

       let dateObj: Date? = dateFormatterGet.date(from: date)

       return dateFormatter.string(from: dateObj!)
    }
    
}

extension UserListVC: UserListVCPresenterView {
    func refreshTableView() {
        tableView.reloadData()
    }
}
