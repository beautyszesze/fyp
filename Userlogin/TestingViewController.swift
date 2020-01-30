//
//  TestingViewController.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 3/11/2019.
//  Copyright © 2019 Valerie Wai Sze Ng. All rights reserved.
//

import UIKit

class TestingViewController: UIViewController {


    let transition = SlideInTransition()
    var topView: UIView?
    var name=["Kwun Tong Line","Tsuen Wan Line","Island Line","South Island Line","Tseung Kwan O Line","Tung Chung Line","Disneyland Resort Line","Airport Express","East Rail Line","West Rail Line","Ma On Shan Line"]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func Menu(_ sender: Any) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        menuViewController.didTapMenuType = { menuType in
            print(menuType)
            self.transitionToNew(menuType)
        }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
 
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    // MARK: - Table view data source
    
}
extension TestingViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
extension TestingViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as?
        CellTableViewCell
        cell?.label.text = name[indexPath.row]
        cell?.img.image = UIImage(named: name[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.DetailViewController) as? DetailViewController
        self.view.window?.rootViewController = DetailViewController
        self.view.window?.makeKeyAndVisible()
        DetailViewController?.image1 = UIImage(named: name[indexPath.row])!
        DetailViewController?.name1 = name[indexPath.row]
        self.navigationController?.pushViewController(DetailViewController!,animated: true)
    }
    
}
