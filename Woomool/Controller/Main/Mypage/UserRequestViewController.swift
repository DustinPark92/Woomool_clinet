//
//  UserRequestViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdentifier = "UserRequestTableViewCell"

class UserRequestViewController: UITableViewController {
    
    let headerView = UserRequestHeaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTV()
        configureUI()
       
    }
    
    func configureUI() {
         addNavbackButton(selector: #selector(handleDismiss))
        title = "문의하기"
        
    }
    
    func configureTV() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 337)
        tableView.register(UserRequestTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
       
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserRequestOption.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserRequestTableViewCell
        let option = UserRequestOption(rawValue: indexPath.row)
        cell.option = option
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let controller = BestAskTableViewController()
            navigationController?.pushViewController(controller, animated: true)
            
        case 0:
            let controller = ManagementViewController()
            navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
    }



}
