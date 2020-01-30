//
//  HomeViewController.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 19/9/2019.
//  Copyright © 2019 Valerie Wai Sze Ng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import BTNavigationDropdownMenu

class HomeViewController: UIViewController {
    
    let transition = SlideInTransition()
   var topView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        // Do any additional setup after loading the view.
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
           let NewPost = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.NewPostViewController) as? UIViewController
               self.view.window?.rootViewController = NewPost
               self.view.window?.makeKeyAndVisible()
            
        default:
            break
        }
    
}
    
    @IBAction func girlhi(_ sender: Any) {
        if (girl1.isHidden == false) 
        {
        girl1.isHidden=true
        girl2.isHidden=false
            print("girl")}
        else {
            girl1.isHidden=false
            girl2.isHidden=true
        }
    }
    
    @IBOutlet weak var girl2: UIImageView!
    
    @IBOutlet weak var girl1: UIImageView!
    
    @IBAction func SignoutButton(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let welcomeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.welcomeViewController) as? welcomeViewController
            view.window?.rootViewController = welcomeViewController
            view.window?.makeKeyAndVisible()
            print ("logout")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
