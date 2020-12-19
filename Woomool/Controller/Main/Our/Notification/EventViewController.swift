//
//  EventViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdentifier = "EventTableViewCell"

class EventViewController: UITableViewController {
    
    let adView = UIView()
    var type = "공지사항"
    var eventListModel = [EventListModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        APIRequest.shared.getEventList { (json) in
            for item in json.array! {
                let eventItem = EventListModel(eventId: item["eventId"].stringValue, contents: item["contents"].stringValue, postDate: item["postDate"].stringValue, endDate: item["endDate"].stringValue, startDate: item["startDate"].stringValue, image: item["image"].stringValue, title: item["title"].stringValue, displayDate: item["displayDate"].stringValue, eventStatus: item["eventStatus"].stringValue)
                    self.eventListModel.append(eventItem)
            }
            
            self.tableView.reloadData()
        }
        configureUI()
        addNavbackButton(selector: #selector(handleDismiss))
       
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
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EventTableViewCell
        let item = eventListModel[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.dateLabel.text = item.postDate
        cell.progressLabel.text = EventViewModel(event: item).eventStatusLabel
        cell.progressLabel.backgroundColor = EventViewModel(event: item).eventStatusColor
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventListModel.count
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = EventDetailTableViewController()
        let item = eventListModel[indexPath.row]
        controller.eventModel = item
        navigationController?.pushViewController(controller, animated: true)
    }

}
