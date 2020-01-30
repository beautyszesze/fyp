//
//  MenuViewController.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 31/10/2019.
//  Copyright © 2019 Valerie Wai Sze Ng. All rights reserved.
//

import UIKit
enum MenuType: Int{
    case home
    case profile
    case station
    case chatroom
}
class MenuViewController: UITableViewController {
 var didTapMenuType: ((MenuType) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else { return }
        dismiss(animated: true) { [weak self] in
            print("Dismissing: \(menuType)")
            self?.didTapMenuType?(menuType)
        }
    }

}
