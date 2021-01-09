//
//  MainViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/08/26.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "MainCollectionViewCell"

class MainViewController: UIViewController {
    var noticeList = [NoticeModel]()
    var eventListModel = [EventListModel]()
    
    var userModel = UserModel(userId: "", email: "", nickname: "", types: "", useCount: 0, remCount: 0, buyCount: 0, levelName: "", levelOrder: 0, levelId: "", joinMonth: "")
    
    var termsModel = [TermsModel]()
    lazy var mainLabel : UILabel = {
        let lb = UILabel()
        lb.text =  ""
        lb.font = UIFont.NotoMedium26
        
        return lb
    }()
    
    private let subLabel : UILabel = {
        let lb = UILabel()
        lb.text = "우물을 찾아 가볼까요?"
        lb.font = UIFont.NotoMedium26
        return lb
    }()
    
    lazy var goodsCountView : UIView = {
        let view = UIView()
        view.backgroundColor = .bestAsk
        view.anchor(width:180,height: 32)
        view.makeAborder(radius: 14)
        let couponImage = UIImageView()
        couponImage.image = UIImage(named: "coupon_home")
        
        view.addSubview(couponImage)
        couponImage.anchor(top:view.topAnchor,left: view.leftAnchor,paddingTop: 4,paddingLeft: 16)
        couponImage.setDimensions(width: 24, height: 24)
        
        let mainLabel = UILabel()
        mainLabel.text = "나의 우물 이용권"
        mainLabel.textColor = .gray400
        mainLabel.font = UIFont.NotoMedium12
        
        view.addSubview(mainLabel)
        mainLabel.anchor(top:view.topAnchor,left: couponImage.rightAnchor,paddingTop:7 ,paddingLeft: 4)
        
        

        
        return view
    }()
    
    let mainCetnerView = MainCenterView()
    var bannerModelHome = [BannerModelHome]()
    
    var countLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.NotoMedium12
        lb.textColor = .black900
        return lb
    }()

    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width - 80, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 12)
        return cv
    }()

    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadingHUD.show()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            LoadingHUD.hide()
        }
       

        NotificationCenter.default.addObserver(self, selector: #selector(privacyAuthAgree(noti:)), name: NSNotification.Name("privacyAuthAgree"), object: nil)
        callRequest()
        configureUI()
        configureCV()
        callHomeEventRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callRequest()
        
        APIRequest.shared.getUserNoti { json in
            LoadingHUD.show()
            for item in json.arrayValue {
                let notiItem = NoticeModel(open: false, messageNo: item["messageNo"].intValue, category: item["category"].stringValue, title: item["title"].stringValue, contents: item["contents"].stringValue, status: item["status"].stringValue)
                self.noticeList.append(notiItem)
                LoadingHUD.hide()
            }
            
//            if self.noticeList.count > 0 {
//                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "activeNotice"), style: .plain, target: self, action: #selector(self.handleNotification))
//                self.navigationItem.rightBarButtonItem?.tintColor = .blue500
//
//            } else {
//                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "inactive_bell"), style: .plain, target: self, action: #selector(self.handleNotification))
//                self.navigationItem.rightBarButtonItem?.tintColor = .blue500
//
//            }
            
            
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
        }
        tabBarController?.tabBar.isHidden = false
    }

    
    //MARK: - Helpers
    
    func configureUI() {

        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        view.addSubview(goodsCountView)
        view.addSubview(mainCetnerView)
        view.addSubview(collectionView)
        
 
        mainLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        mainLabel.anchor(height:44)
        
        subLabel.centerX(inView: view, topAnchor: mainLabel.bottomAnchor, paddingTop: 0)
        subLabel.anchor(height:44)
        
        goodsCountView.centerX(inView: view, topAnchor: subLabel.bottomAnchor, paddingTop: 8)
        
        
        goodsCountView.addSubview(countLabel)
        countLabel.anchor(top:goodsCountView.topAnchor,right: goodsCountView.rightAnchor,paddingTop: 7,paddingRight: 16)
    
        
        mainCetnerView.anchor(top:goodsCountView.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 16)


        collectionView.anchor(top:mainCetnerView.bottomAnchor,left:view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,paddingTop: 20,paddingBottom: 27,height: 80)
        
        


        mainCetnerView.delegate = self
        view.backgroundColor = .white
        
        let iv = UIImageView()
        iv.image = UIImage(named: "logo_navbar")
        iv.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        self.navigationItem.titleView = iv
        

        navigationController?.navigationBar.barTintColor = .white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "inactive_bell"), style: .plain, target: self, action: #selector(self.handleNotification))
    }
    
    func configureCV() {
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func callHomeEventRequest() {
        APIRequest.shared.getEventList { (json) in
            for item in json.array! {
                let eventItem = EventListModel(banner: item["banner"].stringValue, contents: item["contents"].stringValue, endDate: item["endDate"].stringValue, eventId: item["eventId"].stringValue, image: item["image"].stringValue, postDate: item["postDate"].stringValue, startDate: item["startDate"].stringValue, statusEvent: item["statusEvent"].stringValue, statusImage: item["statusImage"].stringValue, title: item["title"].stringValue)
                    self.eventListModel.append(eventItem)
            }
            
            self.collectionView.reloadData()
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
        }

        
    }
    
    func configure() {
        mainLabel.text  = "안녕하세요. \(userModel.nickname)님"
        countLabel.text = "\(userModel.remCount)개"

    }
    
    func callRequest() {
        

            
            APIRequest.shared.getUserInfo() { [self] json in
                
                if json["terms"].arrayValue.count == 0 {
                    userModel = UserModel(userId: json["userId"].stringValue, email: json["email"].stringValue, nickname: json["nickname"].stringValue, types: json["types"].stringValue, useCount: json["useCount"].intValue, remCount: json["remCount"].intValue, buyCount: json["buyCount"].intValue, levelName: json["level"]["name"].stringValue, levelOrder: json["level"]["orders"].intValue, levelId: json["level"]["levelId"].stringValue, joinMonth: json["joinMonth"].stringValue)
                        configure()
                } else {
                    
                    for item in json["terms"].arrayValue {
                        let termsItem = TermsModel(required: item["required"].stringValue, url: item["url"].stringValue, title: item["title"].stringValue, termsId: item["termsId"].stringValue, subTitle : item["subTitle"].stringValue)
                        
                        
                        self.termsModel.append(termsItem)
                    }
                    
                    let controller = PrivateAuthVC(termsArray:termsModel)
                    controller.modalPresentationStyle = .overCurrentContext
                    present(controller, animated: true, completion: nil)
                    
                }
                
            } fail: { error in
                self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                    
                }
            }
    }
    

    
    //MARK: -
    
    @objc func handleNotification() {
        let controller = NoticeTableViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    

    
    @objc func privacyAuthAgree(noti : NSNotification) {
        APIRequest.shared.getUserInfo() { [self] json in

                userModel = UserModel(userId: json["userId"].stringValue, email: json["email"].stringValue, nickname: json["nickname"].stringValue, types: json["types"].stringValue, useCount: json["useCount"].intValue, remCount: json["remCount"].intValue, buyCount: json["buyCount"].intValue, levelName: json["level"]["name"].stringValue, levelOrder: json["level"]["orders"].intValue, levelId: json["level"]["levelId"].stringValue, joinMonth: json["joinMonth"].stringValue)
                    configure()
            } fail: { error in
                self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                    
                }
            }
 
      }
    
}


extension MainViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventListModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainCollectionViewCell
        
        cell.bannerImg.kf.setImage(with: URL(string: eventListModel[indexPath.item].banner))

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = eventListModel[indexPath.item]
        
        let controller = EventDetailTableViewController()
        controller.eventModel = item
        navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    
    
    
    
}


extension MainViewController : MainCenterViewDelegate {
    func goToScannerView() {
        if userModel.remCount == 0 {
            mainCetnerView.qrButton.isEnabled = false
            let controller = CustomAlertViewController(beforeType: singleAlertContent.noWoomoolGoods.rawValue)
            controller.modalPresentationStyle = .overCurrentContext
            present(controller, animated: true, completion: nil)
        } else {
        let controller = QrScannverViewController()
        navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
}
