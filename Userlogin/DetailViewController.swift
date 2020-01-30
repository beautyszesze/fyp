//
//  DetailViewController.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 3/11/2019.
//  Copyright © 2019 Valerie Wai Sze Ng. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

   
    @IBAction func back(_ sender: Any) {
        let NewPost = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.NewPostViewController) as? UIViewController
                     self.view.window?.rootViewController = NewPost
                     self.view.window?.makeKeyAndVisible()
    }
    var image1 = UIImage()
    var name1 = ""
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = name1
        img.image = image1
        // Do any additional setup after loading the view.
    }
    

}
