//
//  ViewController.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 19/9/2019.
//  Copyright © 2019 Valerie Wai Sze Ng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "welcome", sender: self)
    }
    

}
