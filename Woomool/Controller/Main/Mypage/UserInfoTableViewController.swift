//
//  UserInfoTableViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/03.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdentifier = "UserInfoTableViewCell"

class UserInfoTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        title = "회원정보"
        tableView.register(UserInfoTableViewCell.self, forCellReuseIdentifier: "UserInfoTableViewCell")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "left_arrow"), style: .plain, target: self, action: #selector(handledismiss))
              
              navigationItem.leftBarButtonItem?.tintColor = .black900

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: - objc
    
    @objc func handledismiss() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return userInfoType.allCases.count
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        as! UserInfoTableViewCell
        
        let option = userInfoType(rawValue: indexPath.row)
         
        cell.option = option
        
        if indexPath.row > 3 {
            cell.editButton.isHidden = false
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 4:
            let controller = ChagneNicknameViewController()
            navigationController?.pushViewController(controller, animated: true)
        case 5:
            let controller =  ChangePassAuthPopUpViewController()
            controller.modalPresentationStyle = .overCurrentContext
            
            present(controller, animated: true, completion: nil)
        case 6:
            let controller = ChangePasswordViewController()
            navigationController?.pushViewController(controller, animated: true)
        default:
            break;
        }
    }
    
    


}
