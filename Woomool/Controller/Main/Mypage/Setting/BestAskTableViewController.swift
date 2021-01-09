//
//  BestAskTableViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
import GoogleMobileAds

private let reuseIdentifier = "BestAskTableViewCell"

class BestAskTableViewController: UIViewController, GADBannerViewDelegate {
    
    var faqModel = [FAQModel]()
    
    lazy var bannerView: GADBannerView = {
            let view = GADBannerView(adSize:kGADAdSizeLargeBanner)
            view.rootViewController = self
            return view
    }()
    
    let tableView = UITableView()


    override func viewDidLoad() {
        super.viewDidLoad()
        callRequst()
        configureTV()
        configureUI()
       
    }
    
    func callRequst() {
        APIRequest.shared.getFAQCategory { json in
            
            for item in json.array! {
                let faqItem = FAQModel(groupId: item["groupId"].stringValue, title: item["title"].stringValue)
                
                self.faqModel.append(faqItem)
            }
            
            self.tableView.reloadData()
           
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
        }
        
        APIRequest.shared.getAdsense(positionCd: "faq") { json in
            self.bannerView.adUnitID = json["adUnitId"].stringValue
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
        }
        
    }
    
    func configureUI() {
         addNavbackButton(selector: #selector(handleDismiss))
        bannerView.load(GADRequest())
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.delegate = self
        view.addSubview(bannerView)
        view.addSubview(tableView)
        view.backgroundColor = .white
        
        tableView.anchor(top:view.topAnchor,left: view.leftAnchor,right: view.rightAnchor)
        bannerView.anchor(top:tableView.bottomAnchor,left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,width: 320,height: 100)
        title = "자주하는 질문"
        
    }
    
    func configureTV() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.register(BestAskTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
       
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    


}


extension BestAskTableViewController : UITableViewDelegate, UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqModel.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! BestAskTableViewCell
        
        let item = faqModel[indexPath.row]
        cell.titleLabel.text = item.title
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = faqModel[indexPath.row]
        let controller = BestAskDetailTableViewController(groupId: item.groupId, bestAskTitle: item.title)
        navigationController?.pushViewController(controller, animated: true)


    }

    
    
    
    
}
