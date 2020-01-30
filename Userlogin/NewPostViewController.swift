//
//  NewPostViewController.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 18/12/2019.
//  Copyright © 2019 Valerie Wai Sze Ng. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import FirebaseDatabase

protocol NewPostVCDelegate
{
    func didUploadPost(withID id: String)
}


class NewPostViewController:UIViewController, UITextViewDelegate {
 //var ref: DatabaseReference!
    
    let user = Auth.auth().currentUser
       let id = Auth.auth().currentUser?.uid
    var delegate:NewPostVCDelegate?
       
    var ref = Database.database().reference()
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
           super.viewDidLoad()
           textView.delegate=self
       }
    
    
//    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
//        textView.resignFirstResponder()
////                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
////                     super.dismiss(animated: true, completion: completion)
////                 })
//        super.dismiss(animated: true, completion: completion)
//    }
//
     


    
    @IBAction func postButton(_ sender: Any) {
 let store = Storage.storage()
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()

        if let user = user{
            
            
            let storeRef = store.reference().child("images/\(user.uid)/profile_photo.jpg")
            storeRef.downloadURL(completion:{(url, error) in
                do {
                    
                    db.collection("users").whereField("email", isEqualTo: user.email).getDocuments{ (snapshot, error) in
                                       for document in snapshot!.documents {
                                                   let dataDescription = document.data()
                                                                                                                 
                                                                                                                                                                          
                                                                                                                                                                        let Nickname = dataDescription["nickname"] as? String ?? ""
                                                                                                                                                                 let postObject =
                                                                                                                                                                    ["text" : self.textView.text,
                                                                                                                                                                                                    "timestamp" :ServerValue.timestamp(),
                                                                                                                                                                                                    "author":[
                                                                                                                                                                                                        "username":Nickname , "uid":self.id,"photourl":url?.absoluteString]] as [String : Any]
                                                                                                                                                                                  
                                                                                                                                                                 self.ref.child("posts").childByAutoId().setValue(postObject)
                                                                                                                                                                          self.textView.resignFirstResponder()
                                       
                                             
                            
                                   }
                    }
                }

                catch{
                    print(error.localizedDescription)}
       //let postRef = ref.child("posts").childByAutoId()

            })
        }
  

         
          //         DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
          //            self.dismiss(animated: true, completion: nil)
          //                         })
                    
                   
                         print("hi")
          self.dismiss(animated: true, completion: nil)
        
        
    
    }
    
    
 
    @IBOutlet weak var placeHolderLabel: UILabel!
    
   

      
    @IBAction func cancel(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    

    
  
}
