//
//  BestAskTableViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdentifier = "BestAskTableViewCell"

class BestAskTableViewController: UITableViewController {
    
    var faqModel = [FAQModel]()


    override func viewDidLoad() {
        super.viewDidLoad()
        callRequst()
        configureTV()
        configureUI()
       
    }
    
    func callRequst() {
        Request.shared.getFAQCategory { json in
            
            for item in json.array! {
                let faqItem = FAQModel(groupId: item["groupId"].stringValue, title: item["title"].stringValue)
                
                self.faqModel.append(faqItem)
            }
            
            self.tableView.reloadData()
           
        } refreshSuccess: {
            
            Request.shared.getFAQCategory { json in
                
                for item in json.array! {
                    let faqItem = FAQModel(groupId: item["groupId"].stringValue, title: item["title"].stringValue)
                    
                    self.faqModel.append(faqItem)
                }
                
                self.tableView.reloadData()
               
            } refreshSuccess: {
                print("nil")
                
            }
        }
        
    }
    
    func configureUI() {
         addNavbackButton(selector: #selector(handleDismiss))
        title = "자주하는 질문"
        
    }
    
    func configureTV() {
        tableView.separatorInset = .zero
        tableView.register(BestAskTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
       
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! BestAskTableViewCell
        
        let item = faqModel[indexPath.row]
        cell.titleLabel.text = item.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = faqModel[indexPath.row]
            let controller = BestAskDetailTableViewController()
        controller.groupId = item.groupId
        
        navigationController?.pushViewController(controller, animated: true)


    }


}
