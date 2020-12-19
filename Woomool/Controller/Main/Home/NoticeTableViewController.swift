//
//  NoticeTableViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/10/11.
//  Copyright © 2020 Woomool. All rights reserved.
//


import UIKit

private let reuseIdentifier = "NoticeTableViewCell"
private let reuseIdentifierDetail = "NoticeDetailTableViewCell"

class NoticeTableViewController: UITableViewController {
    var noticeList = [NoticeModel]()
    
   let headerView = UIView()
    let headerLabel : UILabel = {
        let lb = UILabel()
        lb.text = "이용관련"
        lb.font = UIFont.NotoRegular16
        lb.textColor = .black900
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
        configureUI()
        callRequest()
        addNavbackButton(selector: #selector(handleDismiss))
    }
    
    
    func callRequest() {
        
        APIRequest.shared.getUserNoti { json in
            for item in json.arrayValue {
                let notiItem = NoticeModel(open: false, messageNo: item["messageNo"].intValue, category: item["category"].stringValue, title: item["title"].stringValue, contents: item["contents"].stringValue, status: item["status"].stringValue)
                self.noticeList.append(notiItem)
            }
            self.tableView.reloadData()
        } refreshSuccess: {
            APIRequest.shared.getUserNoti { json in
                for item in json.arrayValue {
                    let notiItem = NoticeModel(open: false, messageNo: item["messageNo"].intValue, category: item["category"].stringValue, title: item["title"].stringValue, contents: item["contents"].stringValue, status: item["status"].stringValue)
                    self.noticeList.append(notiItem)
                }
                self.tableView.reloadData()
            } refreshSuccess: {
                print("nil")
            }
        }
    }
    
    func callUserNotiReaing() {
        

    }
    
    func configureUI() {
        tableView.separatorInset = .zero
        
        tableView.register(NoticeTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(NoticeDetailTableViewCell.self, forCellReuseIdentifier: reuseIdentifierDetail)
        title = "알림"
    }
    
    @objc func handleDismiss() {
        
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return noticeList.count
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if noticeList[section].open == true {
            return 1 + 1
            
        }else{
            return 1
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = noticeList[indexPath.section]

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoticeTableViewCell
            
            cell.typeLabel.text = item.category
            cell.noticeLabel.text = item.title
            
            if noticeList[indexPath.section].status == "Y" {
                cell.typeLabel.textColor = .black400
                cell.noticeLabel.textColor = .black400
                
            }
            if noticeList[indexPath.section].open {
                cell.foldButotn.setImage(UIImage(named: "arrow_bottom"), for: .normal)
            } else {
                cell.foldButotn.setImage(UIImage(named: "top_arrow"), for: .normal)
            }
            
    
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierDetail, for: indexPath) as! NoticeDetailTableViewCell
            cell.contentLabel.text = item.contents
            return cell
        }
    }
    

    

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        } else {
            return 250
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NoticeTableViewCell else { return }
        guard let index = tableView.indexPath(for: cell) else { return }
        if index.row == indexPath.row {
            
            
            if index.row == 0 {
                
                if noticeList[indexPath.section].open == true {
                    noticeList[indexPath.section].open = false
                    
                    
                    let section = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(section, with: .fade)
                    
                }else {
                    
                    APIRequest.shared.putUserNotiReading(messageNo: noticeList[indexPath.section].messageNo) { json in
                        print(json)
                        self.noticeList[indexPath.section].open = true
                        let section = IndexSet.init(integer: indexPath.section)
                        tableView.reloadSections(section, with: .fade)
                    } refreshSuccess: {
                        APIRequest.shared.putUserNotiReading(messageNo: self.noticeList[indexPath.section].messageNo) { json in
                            self.noticeList[indexPath.section].open = true
                            let section = IndexSet.init(integer: indexPath.section)
                            tableView.reloadSections(section, with: .fade)
                        } refreshSuccess: {
                            print("nil")
                        }
                    }


                    
                }
                
                
                
            }
        }



}
}
