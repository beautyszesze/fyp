//
//  loginViewController.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 19/9/2019.
//  Copyright © 2019 Valerie Wai Sze Ng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class loginViewController: UIViewController {

   
    @IBOutlet weak var emailtext: UITextField!
    
    
    @IBOutlet weak var passwordtext: UITextField!
    
    

    @IBAction func Login(_ sender: Any) {
        //Validate the Text Fields
        
        //create text field
        let email=emailtext.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password=passwordtext.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if ((emailtext.text?.isEmpty)!||(passwordtext.text?.isEmpty)!)

        {
            //display alert msg
            self.displayalert(userMsg: "All fields are required")

        }else
        {
       
        //Signning in user
        Auth.auth().signIn(withEmail: email, password: password){ (result, errorhi) in
            if errorhi != nil
            {
               let abc=errorhi?.localizedDescription
                self.displayalert(userMsg:abc!)
                print("Cannot signIn")
            }else
            {
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
