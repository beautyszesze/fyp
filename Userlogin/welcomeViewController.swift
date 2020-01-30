//
//  welcomeViewController.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 4/10/2019.
//  Copyright © 2019 Valerie Wai Sze Ng. All rights reserved.
//

import UIKit

class welcomeViewController: UIViewController {
 @IBOutlet weak var welcom: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        welcom.loadGif(name: "a")

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

}
