//
//  UserRequestViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
import KakaoSDKTalk
import SafariServices
import GoogleMobileAds

private let reuseIdentifier = "UserRequestTableViewCell"

class UserRequestViewController: UIViewController {
    
    let headerView = UserRequestHeaderView()
    
    lazy var bannerView: GADBannerView = {
            let view = GADBannerView(adSize:kGADAdSizeLargeBanner)
            view.rootViewController = self
            return view
    }()
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIRequest.shared.getAdsense(positionCd: "qna") { json in
            self.bannerView.adUnitID = json["adUnitId"].stringValue
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
        }
        
        
        configureTV()
        configureUI()
       
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
        title = "문의하기"
        
    }
    
    func configureTV() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 337)
        headerView.kakaoButton.addTarget(self, action: #selector(handleKakaoButton), for: .touchUpInside)
        headerView.kakaoAreaButton.addTarget(self, action: #selector(handleKakaoButton), for: .touchUpInside)
        tableView.register(UserRequestTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self

        
       
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleKakaoButton() {
        guard let url = URL(string: "http://pf.kakao.com/_xhbPfK/chat") else { return }

        let safariViewController = SFSafariViewController(url: url)

        present(safariViewController, animated: true, completion: nil)
        
        
        }
        
    
    




}

extension UserRequestViewController : UITableViewDelegate, UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserRequestOption.allCases.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserRequestTableViewCell
        let option = UserRequestOption(rawValue: indexPath.row)
        cell.option = option
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let controller = BestAskTableViewController()
            navigationController?.pushViewController(controller, animated: true)
            
        case 0:
            let controller = ManagementViewController()
            navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
    }
    
}


extension UserRequestViewController : GADBannerViewDelegate {
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

