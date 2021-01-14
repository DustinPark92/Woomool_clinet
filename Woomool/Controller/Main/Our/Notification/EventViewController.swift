//
//  EventViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
import GoogleMobileAds

private let reuseIdentifier = "EventTableViewCell"

class EventViewController: UITableViewController {
    
    let adView = UIView()
    var type = "공지사항"
    var eventListModel = [EventListModel]()
    
    lazy var bannerView: GADBannerView = {
            let view = GADBannerView(adSize:kGADAdSizeLargeBanner)
            view.rootViewController = self
            return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        APIRequest.shared.getEventList { (json) in
            for item in json.array! {
                let eventItem = EventListModel(banner: item["banner"].stringValue, contents: item["contents"].stringValue, endDate: item["endDate"].stringValue, eventId: item["eventId"].stringValue, image: item["image"].stringValue, postDate: item["postDate"].stringValue, startDate: item["startDate"].stringValue, statusEvent: item["statusEvent"].stringValue, statusImage: item["statusImage"].stringValue, title: item["title"].stringValue)
                    self.eventListModel.append(eventItem)
            }
            
            self.tableView.reloadData()
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
        }
        
        APIRequest.shared.getAdsense(positionCd: "event") { json in
            self.bannerView.adUnitID = json["adUnitId"].stringValue.replacingOccurrences(of: "\"", with: "")
            self.bannerView.load(GADRequest())
            self.bannerView.delegate = self
            
            self.tableView.tableHeaderView = self.bannerView
            self.bannerView.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
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
        tableView.tableHeaderView = bannerView
        bannerView.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EventTableViewCell
        let item = eventListModel[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.dateLabel.text = item.postDate
        cell.progressImage.kf.setImage(with: URL(string: item.statusImage))
//        cell.progressLabel.text = EventViewModel(event: item).eventStatusLabel
//        cell.progressLabel.backgroundColor = EventViewModel(event: item).eventStatusColor
        
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




extension EventViewController : GADBannerViewDelegate {
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

