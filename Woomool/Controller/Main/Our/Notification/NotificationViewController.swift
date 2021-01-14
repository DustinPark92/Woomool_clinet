//
//  NotificationViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/08/26.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
import GoogleMobileAds

private let reuseIdentifier = "EventTableViewCell"

class NotificationViewController: UITableViewController {
    
    let adView = UIView()
    var noticeListModel = [NoticeListModel]()
    var type = "공지사항"
    
    lazy var bannerView: GADBannerView = {
            let view = GADBannerView(adSize:kGADAdSizeLargeBanner)
            view.rootViewController = self
            return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        callRequest()
        
        configureUI()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    func callRequest() {
        
        APIRequest.shared.getNoticeList { (json) in
            for item in json.array! {
                let noticeItem = NoticeListModel(noticeId: item["noticeId"].stringValue, title: item["title"].stringValue, postDate: item["postDate"].stringValue, contents: item["contents"].stringValue, image: item["image"].stringValue)
                
                self.noticeListModel.append(noticeItem)
            }
            
            self.tableView.reloadData()
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
        }
        
        APIRequest.shared.getAdsense(positionCd: "notice") { json in
            self.bannerView.adUnitID = json["adUnitId"].stringValue.replacingOccurrences(of: "\"", with: "")
            self.bannerView.load(GADRequest())
            self.bannerView.delegate = self
            
            self.tableView.tableHeaderView = self.bannerView
            self.bannerView.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
        }
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
        cell.dateLabel.text = item.postDate
        
        
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
        controller.noticeModel = item
        navigationController?.pushViewController(controller, animated: true)
        
        
        
    }
    
    
    
    
    
    
}





extension NotificationViewController : GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("adViewDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }

}

