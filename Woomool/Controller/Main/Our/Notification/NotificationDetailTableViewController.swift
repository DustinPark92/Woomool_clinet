//
//  NotificationDetailTableViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/07.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "NoticeTableViewCell"

class NotificationDetailTableViewController: UITableViewController {
    var noticeId = ""
    var noticeTitle = ""
    var noticeDate = ""
    let footerView = UIView()
    let footerImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    let footerLabel : UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textColor = .black900
        lb.font = UIFont.NotoRegular16
        lb.textAlignment = .left
        lb.setLineSpacing(lineSpacing: 20, lineHeightMultiple: 0)
        return lb
    }()
    
    lazy var sbView : UIView = {
        let uv = UIView()
        uv.backgroundColor = .gray300
        uv.setDimensions(width: view.frame.width, height: 1)
        return uv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Request.shared.getNoticeListDetail(inputNoticeId: noticeId) { json in
            self.noticeTitle = json["title"].stringValue
            self.footerLabel.text = json["contents"].stringValue
            self.noticeDate = json["displayDate"].stringValue
            self.footerImageView.kf.setImage(with: URL(string: json["image"].stringValue))
            self.tableView.reloadData()
        }
        configureUI()
        
        addNavbackButton(selector: #selector(handleDismiss))
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    func configureUI () {
        
        tableView.tableFooterView = footerView
        footerView.addSubview(footerImageView)
        footerView.addSubview(sbView)
        footerView.addSubview(footerLabel)
        footerLabel.anchor(top:footerView.topAnchor,left:footerView.leftAnchor,right: footerView.rightAnchor,
                           paddingTop: 16,paddingLeft: 32,paddingRight: 32)
        footerImageView.anchor(top:footerLabel.bottomAnchor,left: footerView.leftAnchor,right: footerView.rightAnchor,paddingTop: 16)
        sbView.anchor(top:footerView.topAnchor)
        tableView.separatorInset = .zero
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 100)
        title = "공지사항"
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationTableViewCell
        cell.titleLabel.text = noticeTitle
        cell.dateLabel.text = noticeDate
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
