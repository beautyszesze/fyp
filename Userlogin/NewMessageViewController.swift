//
//  NewMessageViewController.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 25/11/2019.
//  Copyright © 2019 Valerie Wai Sze Ng. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class NewMessagesViewController: UITableViewController{
    let cellId = "cellId"
    var users = [User]()
      let user = Auth.auth().currentUser
    var userID = Auth.auth().currentUser?.uid
    override func viewDidLoad(){
        super.viewDidLoad()
        
        navigationItem.title = "New Message"
        let rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(handCreateTap))
               self.navigationItem.rightBarButtonItem = rightBarButtonItem
       
        let leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handCancelTap))
               self.navigationItem.leftBarButtonItem = leftBarButtonItem
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        observeAndAppendUsers()
    }
    
    @objc func handCancelTap()
    {
      dismiss(animated: true, completion: nil)
    }
    
    @objc func handCreateTap()
      {
            
      }
    func observeAndAppendUsers()
    {
        var ref: DatabaseReference!
        ref = Database.database().reference()
//
//         ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let user = User(snapshot: snapshot)
//            {
//                user.userId = snapshot.key
//                self.users.append(user)
//
//           let value = snapshot.value as? NSDictionary
//             let username = value?["nickname"] as? String ?? ""
//            let email = value?["email"] as? String ?? ""
//            ref.child("users").child(self.user!.uid).setValue(["nickname": username])
//            let user = User(username: username)
            let db = Firestore.firestore()
        db.collection("users").whereField("email", isEqualTo: user?.email).getDocuments{ (snapshot, error) in
        for document in snapshot!.documents {
   let dataDescription = document.data()
         
         let Sex = dataDescription[""] as? String ?? ""
             
            
            //dataDescription.append(snapshot)
          }
            self.tableView.reloadData()
            }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! DisplayUserCell
//        cell.textLabel?.text = "hi text"
        let user = users[indexPath.row]
        cell.textLabel!.text = user.nickname
        cell.detailTextLabel!.text = user.email
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
