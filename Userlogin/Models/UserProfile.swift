//
//  UserProfile.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 27/12/2019.
//  Copyright © 2019 Valerie Wai Sze Ng. All rights reserved.
//

import Foundation
class UserProfile
{
    var uid : String
    var username : String
    var photoURL : URL
    
    init(uid : String, username : String, photoURL : URL) {
        self.uid = uid
                self.username = username
                self.photoURL = photoURL
    }
}
