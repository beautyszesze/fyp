//
//  User.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 25/11/2019.
//  Copyright © 2019 Valerie Wai Sze Ng. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabase

class User: NSObject{
    var userId: String?
    var nickname: String=""
    var email: String=""
    let user = Auth.auth().currentUser
    var snapshot: Any
    
    init?(snapshot: DataSnapshot)
    {
        self.snapshot=snapshot
        super.init()
        self.dbConnect()
    }
    
    
    func dbConnect(){
          let db = Firestore.firestore()
          
          
          db.collection("users").whereField("email", isEqualTo: user?.email).getDocuments{ (snapshot, error) in
              for document in snapshot!.documents {
                    
                    let dataDescription = document.data()
                    
               
                    let Nickname = dataDescription["nickname"] as? String ?? ""
                    let email = dataDescription["email"] as? String ?? ""
                   
                   self.nickname=Nickname
                    self.email=email
                 
              }
          }
    }
    
    
}
