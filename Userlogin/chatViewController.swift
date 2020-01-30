//
//  chatViewController.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 7/11/2019.
//  Copyright © 2019 Valerie Wai Sze Ng. All rights reserved.
//

import UIKit
import Firebase


class chatViewController: UIViewController, UITableViewDataSource , UITableViewDelegate{

    var posts = [Post]()
  var fetchingMore = false
    var endReached = false
    let leadingScreensForBatching:CGFloat = 3.0
     var cellHeights: [IndexPath : CGFloat] = [:]
    let transition = SlideInTransition()
    var topView: UIView?
    var tableView:UITableView!
    var refreshControl:UIRefreshControl!
    var seeNewPostButton: SeeNewPostsButton!
    var seeNewPostButtonTopAnchor: NSLayoutConstraint!
    var postRef:DatabaseReference{
        return Database.database().reference().child("posts")
    }
    var oldPostsQuery: DatabaseQuery{
        var queryRef:DatabaseQuery
           let lastPost = posts.last
           if lastPost != nil {
               let lastTimestamp = lastPost!.createdAt.timeIntervalSince1970 * 1000
               queryRef = postRef.queryOrdered(byChild: "timestamp").queryEnding(atValue: lastTimestamp)
           } else {
               queryRef = postRef.queryOrdered(byChild: "timestamp")
           }
        return queryRef
    }
    var newPostsQuery: DatabaseQuery{
         var queryRef:DatabaseQuery
            let firstPost = posts.first
            if firstPost != nil {
                let firstTimestamp = firstPost!.createdAt.timeIntervalSince1970 * 1000
                queryRef = postRef.queryOrdered(byChild: "timestamp").queryStarting(atValue: firstTimestamp)
            } else {
                queryRef = postRef.queryOrdered(byChild: "timestamp")
            }
         return queryRef
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: .plain)
//        tableView.backgroundColor = UIColor.blue
//
        let cellNib = UINib(nibName: "PostTableViewCell", bundle:nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        tableView.register(LoadingCell.self ,forCellReuseIdentifier: "loadingCell")
        view.addSubview(tableView)
        
        var layoutGuide:UILayoutGuide!
        if #available(iOS 11.0, *)
        {
        layoutGuide = view.safeAreaLayoutGuide
        }else{
            layoutGuide = view.layoutMarginsGuide
        }
        
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive=true
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive=true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive=true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive=true
        
        tableView.delegate=self
        tableView.dataSource=self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        
        refreshControl = UIRefreshControl()
        tableView.refreshControl=refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        
      seeNewPostButton = SeeNewPostsButton()
        view.addSubview(seeNewPostButton)
        seeNewPostButton.translatesAutoresizingMaskIntoConstraints = false
        seeNewPostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        seeNewPostButtonTopAnchor = seeNewPostButton.topAnchor.constraint(equalTo: layoutGuide.topAnchor,constant:-44)
        seeNewPostButtonTopAnchor.isActive = true
        seeNewPostButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        seeNewPostButton.widthAnchor.constraint(equalToConstant: seeNewPostButton.button.bounds.width).isActive = true
        seeNewPostButton.button.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        beginBatchFetch()
        // Do any additional setup after loading the view.
        viewWillAppear(true)
        
    }
    func toggleSeeNewPostsButton(hidden:Bool){
        if hidden{
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.seeNewPostButtonTopAnchor.constant = -45.0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }else{
   UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                           self.seeNewPostButtonTopAnchor.constant = -45.0
                           self.view.layoutIfNeeded()
                       }, completion: nil)
    }
    }
    @objc func handleRefresh()
    {
        print("Refresh!")
        toggleSeeNewPostsButton(hidden: true)
                newPostsQuery.queryLimited(toFirst: 20).observeSingleEvent(of: .value,with:{snapshot in
                    var tempPosts = [Post]()
                    let firstPost = self.posts.first
                    for child in snapshot.children{
                        if let childSnapshot = child as? DataSnapshot,
                            let data = childSnapshot.value as? [String:Any],
                            let post = Post.parse(childSnapshot.key,data)       ,childSnapshot.key != firstPost?.id {

                            tempPosts.insert(post, at: 0)
                   
                        }
                    }
                    self.posts.insert(contentsOf: tempPosts, at: 0)
                  //  self.tableView.reloadData()
                    let newIndexPath = (0..<tempPosts.count).map
                    {
                        i in return IndexPath(row: i, section: 0)
                    }
                    self.tableView.insertRows(at: newIndexPath, with: .top)
                    self.refreshControl.endRefreshing()
                })
    }
    func beginBatchFetch() {
        fetchingMore = true
        self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
        
        fetchPosts { newPosts in
            self.posts.append(contentsOf: newPosts)
            self.fetchingMore = false
            self.endReached = newPosts.count == 0
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
                self.listenForNewPosts()
            }
        }
    }
    
    func fetchPosts(completion: @escaping(_ posts:[Post])->()){
        //let postRef = Database.database().reference().child("posts")
//        let queryRef = postRef.queryOrdered(byChild: "timestamp").queryLimited(toLast:20)
//       var queryRef:DatabaseQuery
//       let lastPost = posts.last
//       if lastPost != nil {
//           let lastTimestamp = lastPost!.createdAt.timeIntervalSince1970 * 1000
//           queryRef = postRef.queryOrdered(byChild: "timestamp").queryEnding(atValue: lastTimestamp).queryLimited(toLast: 20)
//       } else {
//           queryRef = postRef.queryOrdered(byChild: "timestamp").queryLimited(toLast: 20)
//       }
        oldPostsQuery.queryLimited(toLast: 20).observeSingleEvent(of: .value,with:{snapshot in
            var tempPosts = [Post]()
            let lastPost = self.posts.last
            for child in snapshot.children{
                if let childSnapshot = child as? DataSnapshot,
                    let data = childSnapshot.value as? [String:Any],
                    let post = Post.parse(childSnapshot.key,data)       ,childSnapshot.key != lastPost?.id {
//                    let author = dict["author"] as? [String:Any],
//                    let uid = author["uid"] as? String,
//                    let photoURL = author["photourl"] as? String,
//                    let url = URL(string: photoURL),
//                     let username = author["username"] as? String,
//                    let text =  dict["text"] as? String,
//                    let timestamp = dict["timestamp"] as? Double
          
//                    let userProfile = UserProfile(uid: uid, username: username, photoURL: url)
//                    let post = Post(id: childSnapshot.key, author: userProfile, text: text, timestamp: timestamp)
                    tempPosts.insert(post, at: 0)
           
                }
            }
            return completion(tempPosts)
//            self.posts = tempPosts
//            self.tableView.reloadData()
        })
    }
   
    @IBAction func addpost(_ sender: Any) {
      
//        let NewPostViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.NewPostViewController) as? UIViewController
//        self.view.window?.rootViewController = NewPostViewController
//        self.view.window?.makeKeyAndVisible()
    }
    @IBAction func meun(_ sender: Any) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        menuViewController.didTapMenuType = { menuType in
            print(menuType)
            self.transitionToNew(menuType)
        }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//      let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
//        cell.set(post: posts[indexPath.row])
//        return cell
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
            cell.set(post: posts[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            cell.spinner.startAnimating()
            return cell
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 72.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         switch section {
               case 0:
                   return posts.count
               case 1:
                   return fetchingMore ? 1 : 0
               default:
                   return 0
               }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let offsetY = scrollView.contentOffset.y
           let contentHeight = scrollView.contentSize.height
           if offsetY > contentHeight - scrollView.frame.size.height * leadingScreensForBatching {
               
               if !fetchingMore && !endReached {
                   beginBatchFetch()
               }
           }
       }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
 
//        navigationController.setNavigationBarHidden(true, animated: false)
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
    
    func listenForNewPosts(){
        newPostsQuery.observe(.childAdded) { (snapshot) in
            if snapshot.key != self.posts.first?.id,
            let data =  snapshot.value as? [String:Any],
                let post = Post.parse(snapshot.key, data)
            {
                self.toggleSeeNewPostsButton(hidden: false)
            }
        }
    }
    
    }

extension chatViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
//extension chatViewController: UITableViewDelegate, UITableViewDataSource{
//Database.database().reference().child("posts")
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return name.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as?
//        CellTableViewCell
//        cell?.label.text = name[indexPath.row]
//        cell?.img.image = UIImage(named: name[indexPath.row])
//        return cell!
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let DetailViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.DetailViewController) as? DetailViewController
//        self.view.window?.rootViewController = DetailViewController
//        self.view.window?.makeKeyAndVisible()
//        DetailViewController?.image1 = UIImage(named: name[indexPath.row])!
//        DetailViewController?.name1 = name[indexPath.row]
//        self.navigationController?.pushViewController(DetailViewController!,animated: true)
//    }
//
//}
