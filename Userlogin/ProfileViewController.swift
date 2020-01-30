//
//  ProfileViewController.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 17/10/2019.
//  Copyright © 2019 Valerie Wai Sze Ng. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseDatabase
import FirebaseStorage
import ASProgressHud

enum StorageType {
    case userDefaults
    case fileSystem
}



class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let transition = SlideInTransition()
    var topView: UIView?
    var lastName=""
    
    let user = Auth.auth().currentUser
    let id = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        
        profile()
        displayName()
      //  display()
  
        
        
    }
    
    
    
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        menuViewController.didTapMenuType = { menuType in
            print(menuType)
            self.transitionToNew(menuType)
        }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var photourl: UIImageView!
    let imagePicker = UIImagePickerController()
    
    
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var sex: UILabel!
    
    @IBOutlet weak var FNameField: UITextField!
    @IBOutlet weak var LNameField: UITextField!
    @IBOutlet weak var NicknameField: UITextField!
    @IBOutlet weak var SexField: UITextField!
    @IBOutlet weak var AgeField: UITextField!
    //@IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var PhoneField: UITextField!
    
    func transitionToNew(_ menuType: MenuType) {
        let title = String(describing: menuType).capitalized
        self.title = title
        
        topView?.removeFromSuperview()
        switch menuType {
        case .home:
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
            self.view.window?.rootViewController = homeViewController
            self.view.window?.makeKeyAndVisible()
        case .profile:
            let ProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.ProfileViewController) as? ProfileViewController
            self.view.window?.rootViewController = ProfileViewController
            self.view.window?.makeKeyAndVisible()
      case .station:
        let TestingViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.TestingViewController) as? TestingViewController
        self.view.window?.rootViewController = TestingViewController
        self.view.window?.makeKeyAndVisible()
        case .chatroom:
               let NewPostViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.NewPostViewController) as? UIViewController
               self.view.window?.rootViewController = NewPostViewController
               self.view.window?.makeKeyAndVisible()
            
        default:
            break
        }
        
    }
    
    
    @IBAction func upload(_ sender: Any) {
        
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(imagePicker, animated: true, completion: {
            print("handle saving")
        })
        self.refreshProfileImage()
        
        
    }
    
    func refreshProfileImage(){
        if let user = Auth.auth().currentUser{
            let store = Storage.storage()
            let storeRef = store.reference().child("images/\(user.uid)/profile_photo.jpg")
            
            storeRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                } else {
                    let image = UIImage(data: data!)
                    self.photourl.image = image
                }
            }
        }
        
    }
    
    
    
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        self.dismiss(animated: true, completion: nil)
        
        var img = info[.originalImage] as? UIImage
        self.photourl.image=img
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        //let image = UIImage()
        let jpeg = img?.jpegData(compressionQuality: 0.75)
        let base64str="data:image/jpeg;base64," + (jpeg?.base64EncodedString())!

        let store = Storage.storage()
        let user = Auth.auth().currentUser
        if let user = user{
            let storeRef = store.reference().child("images/\(user.uid)/profile_photo.jpg")
            ASProgressHud.showHUDAddedTo(self.view, animated: true, type: .default)
            let _ = storeRef.putData(jpeg!, metadata: metadata) { (metadata, error) in
                ASProgressHud.hideHUDForView(self.view, animated: true)
                guard let _ = metadata else {
                    print("error occurred: \(error.debugDescription)")
                    return
                    
                    
                }
                
                //self.photourl.image = profileImageFromPicker
            }
            
        }
       
        
    }
    private func store(image: UIImage,
                       forKey key: String,
                       withStorageType storageType: StorageType) {
        if let pngRepresentation = image.pngData() {
            switch storageType {
            case .fileSystem:
                if let filePath = filePath(forKey: key) {
                    do  {
                        try pngRepresentation.write(to: filePath,
                                                    options: .atomic)
                    } catch let err {
                        print("Saving file resulted in error: ", err)
                    }
                }
            case .userDefaults:
                UserDefaults.standard.set(pngRepresentation,
                                          forKey: key)
            }
        }
    }
    
    private func retrieveImage(forKey key: String,
                               inStorageType storageType: StorageType) -> UIImage? {
        switch storageType {
        case .fileSystem:
            if let filePath = self.filePath(forKey: key),
                let fileData = FileManager.default.contents(atPath: filePath.path),
                let image = UIImage(data: fileData) {
                return image
            }
        case .userDefaults:
            if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
                let image = UIImage(data: imageData) {
                return image
            }
        }
        
        return nil
    }
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".png")
    }
    
    func display() {
        print("display 1")

        
        let store = Storage.storage()
        let user = Auth.auth().currentUser
        if let user = user{
            
            
            let storeRef = store.reference().child("images/\(user.uid)/profile_photo.jpg")
            storeRef.downloadURL(completion:{(url, error) in
                do {
                    
                    let data = try Data(contentsOf: url!)
                    let image = UIImage(data: data as Data)
                    self.photourl.image = image
                    }
                catch{
                    print(error.localizedDescription)}
            })
        
        }
    }


func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
}


@IBAction func change(_ sender: Any) {
    saveBtn.isHidden=false;
    name.isHidden=true
    FNameField.isHidden=false;
    LNameField.isHidden=false;
    NicknameField.isHidden=false;
    nickname.isHidden=true;
    SexField.isHidden=false;
    sex.isHidden=true;
    AgeField.isHidden=false;
    age.isHidden=true;
    //EmailField.isHidden=false;
    PhoneField.isHidden=false;
    phone.isHidden=false;
}

@IBAction func save(_ sender: Any) {
    let fNameValue=FNameField.text ?? ""
    print("fNameValue="+fNameValue);
    let lNameValue=LNameField.text ?? ""
    print("lNameValue="+lNameValue);
    name.text=fNameValue+" "+lNameValue
    let nicknameField=NicknameField.text ?? ""
    print("nicknameField="+nicknameField);
    let sexField=SexField.text ?? ""
    print("SexField=" + sexField);
    let ageField=AgeField.text ?? ""
    print("AgeField=" + ageField);
    //        let emailField=EmailField.text ?? ""
    //        print("EmailField=" + emailField);
    let phoneField=PhoneField.text ?? ""
    print("PhoneField=" + phoneField);
    
    
    saveBtn.isHidden=true;
    name.isHidden=false
    FNameField.isHidden=true;
    LNameField.isHidden=true;
    NicknameField.isHidden=true
    nickname.isHidden=false;
    SexField.isHidden=true;
    sex.isHidden=false;
    AgeField.isHidden=true;
    age.isHidden=false;
    //EmailField.isHidden=true;
    PhoneField.isHidden=true;
    phone.isHidden=false;
    let db = Firestore.firestore()
    
    
    db.collection("users").whereField("email", isEqualTo: user?.email).getDocuments{ (snapshot, error) in
        for document in snapshot!.documents {
            document.reference.updateData(["firstname":fNameValue,"lastname":lNameValue,"nickname":nicknameField,"sex":sexField,"age":ageField,"phone":phoneField])
        }
    }
}




func displayName()
{
    
    let db = Firestore.firestore()
    
    
    db.collection("users").whereField("email", isEqualTo: user?.email).getDocuments{ (snapshot, error) in
        for document in snapshot!.documents {
            
            let dataDescription = document.data()
            
            let Sex = dataDescription["sex"] as? String ?? ""
            let Phone=dataDescription["phone"] as? String ?? ""
            let Age = dataDescription["age"] as? String ?? ""
            let Nickname = dataDescription["nickname"] as? String ?? ""
            let firstName = dataDescription["firstname"] as? String ?? ""
            self.lastName = dataDescription["lastname"] as? String ?? ""
            let URL1 = dataDescription["photoURL"] as? String ?? ""
            print(firstName)
            
            if let url = URL(string:URL1){
                
                do{
                    do {
                        let data1 = try Data(contentsOf: url)
                        
                        self.photourl.image = UIImage(data:data1)
                        print(data1)
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    
                    print (url)
                    print(URL1)
                }
            }
            self.name.text=firstName+" "+self.lastName
            self.sex.text=Sex
            self.phone.text = Phone
            self.age.text = Age
            self.nickname.text=Nickname
            self.display()
            
        }
        
        
    }
    
}





@IBOutlet weak var uid: UILabel!

@IBOutlet weak var email: UILabel!



func profile()
{
    email.text = user?.email
    uid.text=id
    
    
    
    
}


}

extension ProfileViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
