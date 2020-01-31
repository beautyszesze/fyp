//
//  MakeaPickerViewController.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 31/1/2020.
//  Copyright © 2020 Valerie Wai Sze Ng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MakeaPickerViewController: UIViewController {
 var ref = Database.database().reference()
    @IBOutlet weak var LongText: UITextField!
    
    @IBOutlet weak var LatText: UITextField!
    
    @IBOutlet weak var FluButton: UIButton!
    
    @IBAction func FluButton(_ sender: Any) {
        if ((LongText.text?.isEmpty)!||(LatText.text?.isEmpty)!)

                {
                    //display alert msg
                    self.displayalert(userMsg: "All fields are required")
         }else{
             
         let pickerObject = ["LatText" : self.LatText.text,"type" : "Flu","LongText" : self.LongText.text] as [String : Any]
        // var ref: DatabaseReference!
           
            self.ref.child("Map").childByAutoId().setValue(pickerObject)
         let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
                    self.view.window?.rootViewController = homeViewController
                    self.view.window?.makeKeyAndVisible()
         }
    }
    @IBAction func FireButton(_ sender: Any) {
        if ((LongText.text?.isEmpty)!||(LatText.text?.isEmpty)!)

                {
                    //display alert msg
                    self.displayalert(userMsg: "All fields are required")
         }else{
             
         let pickerObject = ["LatText" : self.LatText.text,"type" : "Fire","LongText" : self.LongText.text] as [String : Any]
        // var ref: DatabaseReference!
           
            self.ref.child("Map").childByAutoId().setValue(pickerObject)
         let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
                    self.view.window?.rootViewController = homeViewController
                    self.view.window?.makeKeyAndVisible()
         }
    }
    @IBAction func FightButton(_ sender: Any) {
        if ((LongText.text?.isEmpty)!||(LatText.text?.isEmpty)!)

                {
                    //display alert msg
                    self.displayalert(userMsg: "All fields are required")
         }else{
             
         let pickerObject = ["LatText" : self.LatText.text,"type" : "Fight","LongText" : self.LongText.text] as [String : Any]
        // var ref: DatabaseReference!
           
            self.ref.child("Map").childByAutoId().setValue(pickerObject)
         let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
                    self.view.window?.rootViewController = homeViewController
                    self.view.window?.makeKeyAndVisible()
         }
    }
    
    @IBAction func ProtesterButton(_ sender: Any) {
        if ((LongText.text?.isEmpty)!||(LatText.text?.isEmpty)!)

                {
                    //display alert msg
                    self.displayalert(userMsg: "All fields are required")
         }else{
             
         let pickerObject = ["LatText" : self.LatText.text,"type" : "Protester","LongText" : self.LongText.text] as [String : Any]
        // var ref: DatabaseReference!
           
            self.ref.child("Map").childByAutoId().setValue(pickerObject)
         let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
                    self.view.window?.rootViewController = homeViewController
                    self.view.window?.makeKeyAndVisible()
         }
    }
    
    @IBAction func PoliceButton(_ sender: Any) {
        if ((LongText.text?.isEmpty)!||(LatText.text?.isEmpty)!)

                {
                    //display alert msg
                    self.displayalert(userMsg: "All fields are required")
         }else{
             
         let pickerObject = ["LatText" : self.LatText.text,"type" : "Police","LongText" : self.LongText.text] as [String : Any]
        // var ref: DatabaseReference!
           
            self.ref.child("Map").childByAutoId().setValue(pickerObject)
         let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
                    self.view.window?.rootViewController = homeViewController
                    self.view.window?.makeKeyAndVisible()
         }
    }
    
    @IBAction func AmbuButton(_ sender: Any) {
        if ((LongText.text?.isEmpty)!||(LatText.text?.isEmpty)!)

               {
                   //display alert msg
                   self.displayalert(userMsg: "All fields are required")
        }else{
            
        let pickerObject = ["LatText" : self.LatText.text,"type" : "Ambulance","LongText" : self.LongText.text] as [String : Any]
       // var ref: DatabaseReference!
          
           self.ref.child("Map").childByAutoId().setValue(pickerObject)
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
                   self.view.window?.rootViewController = homeViewController
                   self.view.window?.makeKeyAndVisible()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
   
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
    
}
