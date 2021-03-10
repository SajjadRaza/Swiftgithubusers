//
//  UsersViewController.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import UIKit

class UsersViewController: UIViewController {
    
    // MARK: Internal Properties
    
    @IBOutlet weak var searchTextField: BaseTextFeilds!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: UserDataSource!
    
    let viewModel = UserListViewModel()
    
    var searching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.prepareUI()
        self.fetchUserList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

// MARK: Prepare UI

extension UsersViewController {
    
    func prepareUI() {
        self.prepareTableView()
        self.prepareViewModelObserver()
        self.prepareField()
    }
    func prepareField() {
        self.searchTextField.setBorder(color: .black, width: 0.5, radius: 8)
        self.searchTextField.addTarget(self, action: #selector(self.textFieldChange(textField:)), for: .editingChanged)
    }
    
    @objc func textFieldChange(textField: UITextField) {
        self.searching = true
        self.viewModel.setSearch(text: textField.text!)
    }
    
    func prepareTableView() {
        self.dataSource = UserDataSource(attachView: self)
        self.view.backgroundColor = .white
        self.tableView.separatorStyle = .none
    }
}

// MARK: Private Methods

extension UsersViewController {
    
    func fetchUserList() {
        self.view.activityStartAnimating(activityColor: .black, backgroundColor: UIColor.white.withAlphaComponent(0.5))
        DispatchQueue.global(qos: .background).async {
            self.viewModel.fetchUserList(nextBatch: false)
        }
    }
    
    func prepareViewModelObserver() {
        self.viewModel.userDidChanges = { (_, error) in
            if !error {
                DispatchQueue.main.async {
                    self.reloadTableView()
                    self.view.activityStopAnimating()
                }
            }
        }
        
        self.viewModel.userFetched = {(user) in
            DispatchQueue.main.async {
                if let vc = self.storyboard?.instantiateViewController(identifier: "UserDetailViewController") as? UserDetailViewController {
                    vc.userDetail = user
                    vc.viewModel = self.viewModel
                    self.view.activityStopAnimating()
                    if self.navigationController?.topViewController?.classForCoder != UserDetailViewController.classForCoder() {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
}

extension UsersViewController: UserDataSourceProtocol {
    
    func userSelect(user: User) {
        self.view.activityStartAnimating(activityColor: .black, backgroundColor: UIColor.white.withAlphaComponent(0.5))
        DispatchQueue.global(qos: .background).async {
            self.viewModel.fetchUserDetail(userName: user.login!)
        }
    }
    
}
