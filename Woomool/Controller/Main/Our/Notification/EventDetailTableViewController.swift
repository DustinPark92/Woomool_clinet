//
//  EventDetailTableViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/07.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdentifier = "EventTableViewCell"

class EventDetailTableViewController: UITableViewController {
    var eventId = ""
    var eventTitle = ""
    var eventDate = ""
    var eventStatus = ""
    
    
    let footerView = UIView()
     let footerImageView : UIImageView = {
         let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.image = UIImage(named: "event_example")
        return iv
     }()
    
    lazy var sbView : UIView = {
        let uv = UIView()
        uv.backgroundColor = .gray300
        uv.setDimensions(width: view.frame.width, height: 1)
        return uv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addNavbackButton(selector: #selector(handleDismiss))

       
    }
    

    func configureUI () {
        
        
        Request.shared.getEventListDetail(inputEventId: eventId) { json in
            self.eventTitle = json["title"].stringValue
            self.eventDate = json["displayDate"].stringValue
            self.footerImageView.kf.setImage(with: URL(string: json["image"].stringValue))
            self.tableView.reloadData()
        }
        
        
        view.backgroundColor = .white
        tableView.tableFooterView = footerView
        footerView.addSubview(footerImageView)
        footerView.addSubview(sbView)
        footerImageView.anchor(top:footerView.topAnchor,left:footerView.leftAnchor,bottom: footerView.bottomAnchor,right: footerView.rightAnchor,paddingTop: 16)
        sbView.anchor(top:footerView.topAnchor)
       
        tableView.separatorInset = .zero
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 500)
        title = "이벤트"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EventTableViewCell
    
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
