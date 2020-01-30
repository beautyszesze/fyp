//
//  PostTableViewCell.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 7/11/2019.
//  Copyright © 2019 Valerie Wai Sze Ng. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 weak var post:Post?
    func set(post:Post){
       
        ImageService.getImage(withURL : post.author.photoURL)
        { image in
            self.profileImageView.image = image
        }
        usernameLabel.text = post.author.username
        postTextLabel.text = post.text
        subtitleLabel.text = post.createdAt.calenderTimeSinceNow()
    }
}
