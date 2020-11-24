//
//  AuthDetailTableViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/10/30.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdentifier = "AuthDetailTableViewCell"

class AuthDetailTableViewController: UIViewController {
    
    var contentLabel = ""
    var navTitle = ""
    var id = ""
    let defaults = UserDefaults.standard
    let tableView = UITableView()
    
    let agreeButton : UIButton = {
        let bt = UIButton()
        bt.setTitle("확인", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.backgroundColor = .blue500
        return bt
    }()
    
    let bottomView = UIView()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

    }
    
    func configureUI() {

        
        tableView.register(AuthDetailTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,right: view.rightAnchor)

        view.addSubview(agreeButton)
        agreeButton.anchor(top:tableView.bottomAnchor,left:view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,height: 56)
        agreeButton.addTarget(self, action: #selector(handleAgree), for: .touchUpInside)
        view.addSubview(bottomView)
        bottomView.anchor(top:agreeButton.bottomAnchor,left:view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,width: view.frame.width)
        bottomView.backgroundColor = .blue500
        
        title = navTitle
        addNavbackButton(selector: #selector(handleDismiss))
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @objc func handleDismiss() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func handleAgree() {
        defaults.setValue(true, forKey: id)
        dismiss(animated: false, completion: nil)
        
    }

    // MARK: - Table view data source






}

extension AuthDetailTableViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // #warning Incomplete implementation, return the number of rows
       return 1
   }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AuthDetailTableViewCell
       
       cell.mainLabel.text = contentLabel
       return cell
   }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return tableView.estimatedRowHeight
   }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
       return 1000
   }

    
}


