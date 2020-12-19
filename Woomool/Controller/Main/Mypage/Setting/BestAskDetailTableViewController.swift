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
    var bestAskModel = BestAskModel()
    
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
    
    var groupId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        callRequest()
        addNavbackButton(selector: #selector(handleDismiss))
    }
    
    func callRequest() {
        APIRequest.shared.getFAQDetail(groupId: groupId) { json in
            print(json)
        } refreshSuccess: {
            APIRequest.shared.getFAQDetail(groupId: self.groupId) { json in
                print(json)
            } refreshSuccess: {
                print("nil")
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
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bestAskModel.open == true {
            return 1 + 1
            
        }else{
            return 1
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! BestAskDetailTableViewCell
            
    
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierDetail, for: indexPath) as! BestAskDetailContentsTableViewCell

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
                
                if bestAskModel.open == true {
                    bestAskModel.open = false
                    
                    let section = IndexSet.init(integer: indexPath.section)
                    
                    tableView.reloadSections(section, with: .fade)
                    
                }else {
                    bestAskModel.open = true
                    
                    let section = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(section, with: .fade)
                    
                }
                
                
                
            }
        }



}
}
