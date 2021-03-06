//
//  BestAskDetailTableViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/07.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdentifier = "BestAskDetailTableViewCell"
private let reuseIdentifierDetail = "BestAskDetailContentsTableViewCell"

class BestAskDetailTableViewController: UITableViewController {
    var bestAskModel = [BestAskModel]()
    
   let headerView = UIView()
    lazy var headerLabel : UILabel = {
        let lb = UILabel()
        lb.text = bestAskTitle
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
    
    let groupId : String
    let bestAskTitle : String
    
    init(groupId : String,bestAskTitle : String) {
        self.groupId = groupId
        self.bestAskTitle = bestAskTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        callRequest()
        addNavbackButton(selector: #selector(handleDismiss))
    }
    
    func callRequest() {
        APIRequest.shared.getFAQDetail(groupId: groupId) { json in
            for item in json.arrayValue {
                let bestAskItem = BestAskModel(open: false, contents: item["contents"].stringValue, title: item["title"].stringValue, image: item["image"].stringValue)
                
                
                self.bestAskModel.append(bestAskItem)
            }
            
            self.tableView.reloadData()
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
        }

    }
    
    func configureUI() {
        tableView.separatorInset = .zero
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 76)
        headerView.addSubview(headerLabel)
        headerLabel.anchor(top:headerView.topAnchor,left: headerView.leftAnchor,paddingTop: 38, paddingLeft: 32)
        headerView.addSubview(sbView)
        sbView.anchor(left:headerView.leftAnchor,bottom: headerView.bottomAnchor,right: headerView.rightAnchor)
        
        
        
        tableView.register(BestAskDetailTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
            tableView.register(BestAskDetailContentsTableViewCell.self, forCellReuseIdentifier: reuseIdentifierDetail)
        title = "자주하는 질문"
    }
    
    @objc func handleDismiss() {
        
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return bestAskModel.count
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bestAskModel[section].open == true {
            return 1 + 1
            
        }else{
            return 1
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = bestAskModel[indexPath.section]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! BestAskDetailTableViewCell
            cell.questionLabel.text = item.title
    
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierDetail, for: indexPath) as! BestAskDetailContentsTableViewCell
            
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
        guard let cell = tableView.cellForRow(at: indexPath) as? BestAskDetailTableViewCell else { return }
        guard let index = tableView.indexPath(for: cell) else { return }
        if index.row == indexPath.row {
            if index.row == 0 {
                
                if bestAskModel[indexPath.section].open == true {
                    bestAskModel[indexPath.section].open = false
                    
                    let section = IndexSet.init(integer: indexPath.section)
                    
                    tableView.reloadSections(section, with: .fade)
                    
                }else {
                    bestAskModel[indexPath.section].open = true
                    
                    let section = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(section, with: .fade)
                    
                }
                
                
                
            }
        }



}
}
