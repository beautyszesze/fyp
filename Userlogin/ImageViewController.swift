//
//  ImageViewController.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 1/11/2019.
//  Copyright © 2019 Valerie Wai Sze Ng. All rights reserved.
//
import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseDatabase
import FirebaseStorage
import ASProgressHud

class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    @IBAction func upload(_ sender: Any) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(imagePicker, animated: true, completion: {
            print("handle saving")
        })
        self.refreshProfileImage()
    }
    @IBOutlet weak var photourl: UIImageView!
    let imagePicker = UIImagePickerController()
    
    @IBAction func done(_ sender: Any) {
         self.transitionToHome()
    }
    let user = Auth.auth().currentUser
    let id = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func refreshProfileImage(){
        if let user = Auth.auth().currentUser{
            let store = Storage.storage()
            let storeRef = store.reference().child("images/\(user.uid)/profile_photo.jpg")
            print(user.uid)
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

    
    
    func setUpElements(){
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func transitionToHome()
    {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    

}
