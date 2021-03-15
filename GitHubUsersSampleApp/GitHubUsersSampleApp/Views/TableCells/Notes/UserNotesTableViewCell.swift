//
//  UserNotesTableViewCell.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import UIKit

class UserNotesTableViewCell: UITableViewCell, ConfigurableTableViewCellProtocol {
    @IBOutlet weak var mainPicView: UIView!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var model: User?
    
    func configureWithModel(_ userModel: User) {
        self.model = userModel
        self.titleLabel.text = userModel.login ?? ""
        if let avatarURL = userModel.avatarURL{
            self.picture.setImage(withImageURL: avatarURL, placeholderImage: nil, size: .original)
        }else{
            self.picture.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.picture.contentMode = .scaleToFill
        self.mainPicView.setBorder(color: .black, width: 1, radius: 40)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
