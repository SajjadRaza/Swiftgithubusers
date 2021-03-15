//
//  UserDetailViewController.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    // MARK: UIProperties
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var textBorderView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var headerNameLbl: UILabel!
    @IBOutlet weak var followerLbl: UILabel!
    @IBOutlet weak var followingLbl: UILabel!
    @IBOutlet weak var detailNameLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var blogLbl: UILabel!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    // MARK: Internal Properties
    var userDetail: User!
    
    var viewModel: UserListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.prepareViewModelObserver()
    }
    // MARK: - UIACTIONS
    @IBAction func actionSave(_ sender: Any) {
        self.viewModel.updateUserData(user: self.userDetail, notes: self.textView.text)
    }
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - PRIVATE
extension UserDetailViewController {
    func prepareViewModelObserver() {
        self.viewModel.userDidChanges = { (_, error) in }
        self.viewModel.userFetched = { (user) in }
        self.viewModel.dataUpdated = { (success) in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - UIUPDATE
extension UserDetailViewController {
    func setUI() {
        self.detailView.setBorder(color: .black, width: 1, radius: 8)
        self.textBorderView.setBorder(color: .black, width: 1, radius: 8)
        self.userImageView.setImage(withImageURL: self.userDetail.avatarURL ?? "", placeholderImage: nil, size: .original)
        self.headerNameLbl.text = self.userDetail.name
        self.followerLbl.text = "Followers: \(self.userDetail.followers)"
        self.followingLbl.text = "Following: \(self.userDetail.following)"
        self.detailNameLbl.text = "Name: \(self.userDetail.name ?? "")"
        self.companyLbl.text = "Company: \(self.userDetail.company ?? "")"
        self.blogLbl.text = "Blog: \(self.userDetail.blog!)"
        self.textView.text = self.userDetail.note
    }
}
