//
//  RegisterViewController.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 19/9/2019.
//  Copyright © 2019 Valerie Wai Sze Ng. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseDatabase
import FirebaseStorage
import ASProgressHud


class RegisterViewController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   // class var whitespacesAndNewlines: CharacterSet { get }
    @IBOutlet weak var firstname: UITextField!
    
    @IBOutlet weak var lastname: UITextField!
       @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var sex: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    //@IBOutlet weak var photourl: UITextField!
    @IBOutlet weak var repeatpassword: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
         
        // Do any additional setup after loading the view.
     
    }
    
    func setUpElements(){

    }
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func validateFields() ->String? {
        //checkin the field is not empty
        if ((firstname.text?.isEmpty)!||(lastname.text?.isEmpty)!||(email.text?.isEmpty)!||(password.text?.isEmpty)!||(repeatpassword.text?.isEmpty)!||(nickname.text?.isEmpty)!||(age.text?.isEmpty)!||(sex.text?.isEmpty)!||(phone.text?.isEmpty)!)
    {
            //display alert msg
            displayalert(userMsg: "All fields are required")
            return "error"

        }
        //check the password is secure enough
        let cleanPass=password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanPass)==false
        {
            displayalert(userMsg: "Please make the password is at least 8, a special character and a number")
            return "error"

        }
        //validate password
        if password.text != repeatpassword.text
        {
            
            //display alter msg
            displayalert(userMsg: "Please make sure that password match")
            return "error"

        }
        return nil
    }

    
    @IBAction func RegisterButton(_ sender: Any) {

       let error1 = validateFields()
        
        let firstName = firstname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Email = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Password = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Sex = sex.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Nickname = nickname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Age = age.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Phone = phone.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //let URL = photourl.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        
        if (error1 != nil){
            print("error")
        }else {
        //create the user
            Auth.auth().createUser(withEmail: Email, password:Password) { (abc, error)in
            if let err = error {
            print("error1 is found")
            print(err)
            }else
            {
        //create clean version of the data
                print("create")
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["firstname" :firstName,"lastname" :lastName,"email": Email,"sex":Sex,"age":Age,"nickname":Nickname,"phone":Phone]){ (error) in
                    if error != nil {
                        print("error is found")
                    }
          
            }
   
                //Transition to the home screen
                self.transitionToHome()
        }
            
            }
        }
    
    }
    
    func displayalert(userMsg:String)->Void
    {
        DispatchQueue.main.async {
            let alertcontroller = UIAlertController(title: "Alert", message:userMsg , preferredStyle: .alert)
            //create alert controller
            let okAction = UIAlertAction(title: "OK", style: .default)
            {
                (action:UIAlertAction!) in
                DispatchQueue.main.async
                    {
                        self.dismiss(animated:true,completion: nil)                }
            }
            alertcontroller.addAction(okAction)
            self.present(alertcontroller, animated: true, completion: nil)
            //present alert controller
        }
    }
    
    func transitionToHome()
    {
        let ImageViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.ImageViewController) as? ImageViewController
        view.window?.rootViewController = ImageViewController
        view.window?.makeKeyAndVisible()
    }
 
}

