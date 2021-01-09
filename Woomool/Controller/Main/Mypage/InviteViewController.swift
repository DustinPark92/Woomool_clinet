//
//  InviteViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
import KakaoSDKLink
import KakaoSDKAuth
import KakaoSDKTalk
import KakaoSDKTemplate
import KakaoSDKCommon
import GoogleMobileAds

class InviteViewController: UIViewController {
    
    let viewModel = MypageViewModel()
    var url = ""
    
    lazy var centerView = viewModel.inviteCenterView(inviteCodeLabel: inviteCodeLabel)
    
    lazy var inviteCodeLabel = UILabel()
    
    let text = "친구초대하고 우물 이용권 받으세요!\\n\\n"
    
    lazy var bannerView: GADBannerView = {
        let view = GADBannerView(adSize:kGADAdSizeLargeBanner)
        view.rootViewController = self
        return view
    }()


    
    
    private let mainLabel : UILabel = {
        let lb = UILabel()
        lb.text = "친구초대하고 \n우물 이용권 받으세요!"
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.textColor = .black900
        lb.font = UIFont.NotoMedium26
        return lb
    }()
    
    private let subLabelBelowCenterView : UILabel  = {
        let lb = UILabel()
        lb.text = "초대 받은 사용자가 회원가입 후 추천인 코드를 입력하면 \n 초대를 주고받은 사용자들에게 \n 각각 1개의 우물 이용권이 지급됩니다."
        lb.textAlignment = .center
        lb.font = UIFont.NotoMedium12
        lb.textColor = .black400
        lb.numberOfLines = 0
        return lb
    }()
    private let urlButton : UIButton = {
        let bt = UIButton()
        bt.setDimensions(width: 60, height: 60)
        bt.makeAcircle(dimension: 60)
        bt.setImage(UIImage(named: "url"), for: .normal)
        return bt
    }()
    
    private let kakaoButton : UIButton = {
        let bt = UIButton()
        bt.setDimensions(width: 60, height: 60)
        bt.makeAcircle(dimension: 60)
        bt.setImage(UIImage(named: "sns_kakao"), for: .normal)
        return bt
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        callRequst()
        configureUI()
    }
    
    
    func callRequst() {
        
        APIRequest.shared.getInviteCode { json in
            self.inviteCodeLabel.text = json["inviteCd"].stringValue
            self.url = json["url"].stringValue
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
        }
        
        APIRequest.shared.getAdsense(positionCd: "invite") { json in
            self.bannerView.adUnitID = json["adUnitId"].stringValue
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
        }


    }

    func configureUI() {
        title = "친구 초대"
        view.backgroundColor = .white
        addNavbackButton(selector: #selector(handleDismiss))
        navigationController?.navigationBar.isHidden = false
        view.addSubview(mainLabel)
        view.addSubview(centerView)
        view.addSubview(subLabelBelowCenterView)
        mainLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 66)
        centerView.centerX(inView: view, topAnchor: mainLabel.bottomAnchor, paddingTop: 42)
        centerView.setDimensions(width: view.frame.width - 64, height: 80)
        subLabelBelowCenterView.centerX(inView: view, topAnchor: centerView.bottomAnchor, paddingTop: 10)
        
        let stack = UIStackView(arrangedSubviews: [urlButton,kakaoButton])
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.centerX(inView: view, topAnchor: subLabelBelowCenterView.bottomAnchor, paddingTop: 52)
        
        kakaoButton.addTarget(self, action: #selector(handleKaKaoButton), for: .touchUpInside)
        urlButton.addTarget(self, action: #selector(handleUrlButton), for: .touchUpInside)
        
        
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        view.addSubview(bannerView)
        bannerView.anchor(left:view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,width: 320,height: 100)
        
        
        
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
   
    
    @objc func handleKaKaoButton() {
        
        let textTemplateJsonStringData =
        """
        {
            "object_type": "text",
            "text": "\(text)",
            "link": {
                "web_url": "http://dev.kakao.com",
                "mobile_web_url": "http://dev.kakao.com"
            },
            "button_title": "바로 확인"
        }
        """.data(using: .utf8)!
        
        
        if let templatable = try? SdkJSONDecoder.custom.decode(TextTemplate.self, from: textTemplateJsonStringData) {
            
            
            
            LinkApi.shared.defaultLink(templatable: templatable) {(linkResult, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("defaultLink() success.")

                    if let linkResult = linkResult {
                        UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
        
        
        
    }
    
    @objc func handleUrlButton() {
        
        UIPasteboard.general.string = url
    }

}



extension InviteViewController : GADBannerViewDelegate {
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

