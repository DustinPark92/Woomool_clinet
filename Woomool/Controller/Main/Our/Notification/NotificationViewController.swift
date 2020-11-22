//
//  NotificationViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/08/26.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdentifier = "EventTableViewCell"

class NotificationViewController: UITableViewController {
    
    let adView = UIView()
    var noticeListModel = [NoticeListModel]()
    var type = "공지사항"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Request.shared.getNoticeList { (json) in
            for item in json.array! {
                let noticeItem = NoticeListModel(noticeId: item["noticeId"].stringValue, title: item["title"].stringValue, displayDate: item["displayDate"].stringValue)
                
                
                self.noticeListModel.append(noticeItem)
            }
            
            self.tableView.reloadData()
        }
        
        configureUI()

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    

    func configureUI () {
        title = type
        view.backgroundColor = .white
        tableView.tableHeaderView = adView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        addNavbackButton(selector: #selector(handleDismiss))
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationTableViewCell
        
        let item = noticeListModel[indexPath.row]
        cell.titleLabel.text = item.title
        cell.dateLabel.text = item.displayDate
        
    
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeListModel.count
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = noticeListModel[indexPath.row]
        let controller = NotificationDetailTableViewController()
        controller.noticeId = item.noticeId
        navigationController?.pushViewController(controller, animated: true)
        

        
    }
    
    

}
