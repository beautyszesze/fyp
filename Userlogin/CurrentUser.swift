//
//  CurrentUser.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 18/10/2019.
//  Copyright © 2019 Valerie Wai Sze Ng. All rights reserved.
//

import Foundation

struct CurrentUser {
    let uid: String
    let name: String
    let email: String
    
    init(dictionary: [String: Any])
    {
        self.uid = uid
        self.name=dictionary["firstname"]as? String ??
    }
}
