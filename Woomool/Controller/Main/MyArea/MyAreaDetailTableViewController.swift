//
//  MyAreaDetailTableViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/10.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MyAreaDetailTableViewCell"

class MyAreaDetailTableViewController: UIViewController {
    let bottomActionSheet = MyAreaBottomSheetHeaderView()
    let bottomActionSheetFooter = MyAreaBottomActionSheetFooterView()
    lazy var serviceRequestButton : UIButton = {
        let bt = UIButton()
        bt.setTitle("우물 서비스 요청", for: .normal)
        bt.titleLabel?.font = UIFont.NotoBold18
        bt.titleLabel?.textColor = .white
        bt.backgroundColor = UIColor.blue500
        bt.makeAborder(radius: 14)
        return bt
    }()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        tableView.register(MyAreaDetailTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        view.addSubview(bottomActionSheet)
        bottomActionSheet.anchor(top:view.topAnchor,left: view.leftAnchor,right: view.rightAnchor,width: view.frame.width,height: 80)
        tableView.anchor(top:bottomActionSheet.bottomAnchor,left:view.leftAnchor,right: view.rightAnchor)
        view.addSubview(bottomActionSheetFooter)
        tabBarController?.tabBar.isHidden = true
        bottomActionSheetFooter.anchor(top:tableView.bottomAnchor,left:view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingBottom: 50,width: view.frame.width,height: 56)
        bottomActionSheetFooter.delegate = self
    }

    // MARK: - Table view data source




    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return bottomActionSheetFooter
//    }
//
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 100
//    }

}

extension MyAreaDetailTableViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MyAreaDetailTableViewCell
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}


extension MyAreaDetailTableViewController : MyAreaBottomActionSheetFooterViewDelegate {
    func handleRequest() {
        dismiss(animated: false) {
            NotificationCenter.default.post(name: NSNotification.Name("pushWooMoolService"), object: nil)
        }

        
    }
    
    
}
