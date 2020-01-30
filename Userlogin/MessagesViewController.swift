//
//  MessagesViewController.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 25/11/2019.
//  Copyright © 2019 Valerie Wai Sze Ng. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class MessagesViewController: UITableViewController{
    let transition = SlideInTransition()
    var topView: UIView?
     
    override func viewDidLoad(){
       
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.compose, target: self, action: #selector(handNewMessageTap))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    @objc  func handNewMessageTap()
    {
        let newMessageController: NewMessagesViewController = NewMessagesViewController()
        let navController = UINavigationController(rootViewController: newMessageController)
        self.present(navController, animated: true,completion: nil)
        //self.navigationController?.pushViewController(NewMessagesViewController, animated: true)
    }
    
    @IBAction func didtapMeun(_ sender: UIBarButtonItem) {
            guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
            menuViewController.didTapMenuType = { menuType in
                print(menuType)
                self.transitionToNew(menuType)
            }
            menuViewController.modalPresentationStyle = .overCurrentContext
            menuViewController.transitioningDelegate = self
            present(menuViewController, animated: true)
        }
        
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
        
}
extension MessagesViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}

