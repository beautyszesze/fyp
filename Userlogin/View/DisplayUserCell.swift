//
//  DisplayUserCell.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 25/11/2019.
//  Copyright © 2019 Valerie Wai Sze Ng. All rights reserved.
//

import Foundation
import Firebase

class DisplayUserCell: UITableViewCell {
    
    let photourl: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
        }()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64,y: (textLabel?.frame.origin.y)!-2,width: (textLabel?.frame.width)!, height:(textLabel?.frame.height)!)
detailTextLabel?.frame = CGRect(x: 64,y: (detailTextLabel?.frame.origin.y)!+2,width: (textLabel?.frame.width)!, height:(detailTextLabel?.frame.height)!)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:.subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(timeLabel)
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
       timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18 ).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100)
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
    //constraints
    
}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}
}
