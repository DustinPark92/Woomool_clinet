//
//  MyPageTableViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/07.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
import Kingfisher

private let myEnviromentCell = "MyEnvironmentTableViewCell"
private let historyCell = "HistoryFilterTableViewCell"
private let couponCell = "CouponBuyTableViewCell"

protocol MypageVCDelegate: class {
    
    func didSelect(filter: MypageFilterOptions)
    func didSelectHistory(filter: MypageHistroyOption)
}

class MypageVC: UIViewController, UIGestureRecognizerDelegate {
    
    
    
    
    private let topView = MyPageTopView()
    private let filterView = MypageFilterView()
    private let bottomView = UITableView()
    var index = 0
    var showingPayPage = false
    
    
    //Network Model
    
    var historyAllModel = [HistoryAllModel]()
    var historyGoodsModel = [HistoryGoodsModel]()
    var historyStoreModel = [HistoryStoreModel]()
    
    
    
    var goodsPrice = "9,900원"
    var viewModel = MypageViewModel()
    lazy var historyDate = viewModel.getCurrenYearMonths(monthConfig: 0)
    
    
    
    weak var delegate : MypageVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

        
        navigationController?.navigationBar.isHidden = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        viewModel.callRequestMyPage(success: {
            let userModel = self.viewModel.userModel
            self.topView.nameLabel.text = "\(userModel.nickname)님"
            self.topView.userRank.text = "\(userModel.levelName) 회원입니다."
            self.topView.viewModel.couponCount = self.viewModel.couponCount
            self.topView.collectionViewTop.reloadData()
            
        }, fail: { error in
                self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                    
                }
        })
        

        
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = true
    }
    
    func configureUI() {
        bottomView.tableHeaderView = topView
        topView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 320)
        
        topView.friendInviteButton.addTarget(self, action: #selector(handleInviteBtn), for: .touchUpInside)
        topView.settingBtn.addTarget(self, action: #selector(handleSettingBtn), for: .touchUpInside)
        topView.nextBtn.addTarget(self, action: #selector(handleUserSetting), for: .touchUpInside)
        
        topView.userGradeButton.addTarget(self, action: #selector(handleUserGradeButton), for: .touchUpInside)
        
        
        
        topView.filterBar.delegate = self
        view.backgroundColor = .white
        
        
        view.addSubview(bottomView)
        bottomView.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor)
        
        bottomView.delegate = self
        bottomView.dataSource = self
        bottomView.bounces = false
        
        bottomView.register(CouponBuyTableViewCell.self, forCellReuseIdentifier: couponCell)
        bottomView.register(MyEnvironmentTableViewCell.self, forCellReuseIdentifier: myEnviromentCell)

        bottomView.register(CouponUsingTableViewCell.self, forCellReuseIdentifier: "CouponUsingTableViewCell")
        bottomView.register(CouponPayReciptTableViewCell.self, forCellReuseIdentifier: "CouponPayReciptTableViewCell")
        bottomView.register(CouponBuyMethodTableViewCell.self, forCellReuseIdentifier: "CouponBuyMethodTableViewCell")
        
        
        bottomView.register(HistoryFilterTableViewCell.self, forCellReuseIdentifier: historyCell)
        bottomView.register(HistoryDateTableViewCell.self, forCellReuseIdentifier: "HistoryDateTableViewCell")
        bottomView.register(HistoryTableViewCell.self, forCellReuseIdentifier: "HistoryTableViewCell")
        

        
        
    }
    

    
    
    func callHistroyRequest(type : String, searchMonth : String) {
        APIRequest.shared.getHistory(type: type, searchMonth: searchMonth) { json in
            if type == "" {
                self.historyAllModel.removeAll()
                for item in json.arrayValue {
                    let historyAllItem = HistoryAllModel(name: item["name"].stringValue, count: item["count"].intValue, countUnit: item["countUnit"].stringValue, price: item["price"].intValue, priceUnit: item["priceUnit"].stringValue, date: item["date"].stringValue, image: item["image"].stringValue, historyNo: item["historyNo"].intValue)
                    self.historyAllModel.append(historyAllItem)
                }
                self.bottomView.reloadData()
            } else if type == "/store"{
                self.historyStoreModel.removeAll()
                for item in json.arrayValue {
                    
                    let historyStoreItem = HistoryStoreModel(historyNo: item["historyNo"].intValue, count: item["count"].intValue, storeId: item["store"]["storeId"].stringValue, name: item["store"]["name"].stringValue, date: item["date"].stringValue, countUnit: item["countUnit"].stringValue, image: item["image"].stringValue)
                    

                    self.historyStoreModel.append(historyStoreItem)
                    
                }
                self.bottomView.reloadData()
                
            } else if type == "/goods" {
                self.historyGoodsModel.removeAll()
                for item in json.arrayValue {
                    
                    let historyGoodsItem = HistoryGoodsModel(historyNo: item["historyNo"].intValue, date: item["date"].stringValue, goodsId: item["goods"]["goodsId"].intValue, name: item["goods"]["name"].stringValue, price: item["price"].intValue, image: item["image"].stringValue, priceUnit: item["priceUnit"].stringValue)
                    
                    self.historyGoodsModel.append(historyGoodsItem)
                    
                }
                self.bottomView.reloadData()
                
            }
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
        }
        
    }
    
    
    
    
    
    //MARK: - objc
    
    
    @objc func handleUserSetting() {
        let controller = UserInfoTableViewController()
        
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func handleSettingBtn() {
        let controller = SettingViewController(style: .grouped)
        controller.userLogintype = viewModel.userModel.types
        navigationController?.pushViewController(controller, animated : true)
        
        
    }
    
    @objc func handleInviteBtn() {
        let controller = InviteViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleSubmit() {
        showingPayPage = true
        bottomView.reloadData()
        let index = IndexPath(row: 0, section: 2)
        bottomView.scrollToRow(at: index, at: .none, animated: true)
    }
    
    @objc func handleFilter() {
        if viewModel.couponAbleCount == 0 {
            print("사용 가능한 쿠폰 없음")
        } else {
            let controller = CouponViewController()
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func handleUserGradeButton() {
        let controller = UserGradeViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handlePay() {
        bottomView.reloadRows(at: [IndexPath(row: 0, section: 3)], with: .none)
        
        print("방법은?? \(viewModel.paymentMethodSelected)")
        
        viewModel.callPostGoodsPurchase(suceess: { json in
            
            
            print("결제 params\(json)")
  
                let controller = PaymentAuthViewController(url: json["url"].stringValue,paramsValue: json["paramsValue"].stringValue,paramsKey: json["paramsKey"].stringValue)
                self.navigationController?.pushViewController(controller, animated: true)

        }, fail: { error in
            self.showOkAlert(title: "결제 수단을 선택해주세요.", message: "") {
                
            }
        })
        
    }
        
        @objc func handleMinusMonth() {
            viewModel.monthConfig -= 1
            callHistroyRequest(type: viewModel.historyType, searchMonth: viewModel.getCurrenYearMonths(monthConfig: viewModel.monthConfig))
            bottomView.reloadData()
            
        }
        
        @objc func handlePlusMonth() {
            viewModel.monthConfig += 1
            callHistroyRequest(type: viewModel.historyType, searchMonth: viewModel.getCurrenYearMonths(monthConfig: viewModel.monthConfig))
            bottomView.reloadData()
        }
        
        @objc func handleCancel() {
            viewModel.couponModel = CouponModel(expiryDate: "", name: "", description: "", minusPrice: 0, types: "", plusCount: 0, expiryDays: 0, couponId: "", imgae: "", couponNo: 0)
            viewModel.couponUsing = false
            bottomView.reloadData()
            
        }
        
        func configureRequest() {
            
            
        }
        
        
        
        
        
        
    }
    
    extension MypageVC : UITableViewDelegate,UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            switch index {
            case 0:
                return 1
            case 1:
                return 3
            case 2:
                return 4
            default:
                return 1
            }
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            switch index {
            case 0:
                return 1
            case 1:
                switch section {
                case 0:
                    return 1
                case 1:
                    return 1
                case 2:
                    if viewModel.historyType == "" {
                        return historyAllModel.count
                    } else if viewModel.historyType == "/goods" {
                        return  historyGoodsModel.count
                    } else if viewModel.historyType == "/store" {
                        return historyStoreModel.count
                    }
                    return 5
                default:
                    return 1
                }
                
            case 2:
                return 1
            default:
                return 0
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch index {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: myEnviromentCell , for: indexPath) as! MyEnvironmentTableViewCell
                

                cell.selectionStyle = .none
                
                return cell
            case 1:
                switch indexPath.section {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: historyCell, for: indexPath) as! HistoryFilterTableViewCell
                    cell.selectionStyle = .none
                    cell.filterView.delegate = self
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryDateTableViewCell", for: indexPath) as! HistoryDateTableViewCell
                    cell.selectionStyle = .none
                    cell.dateLabel.text = viewModel.getCurrenYearMonths(monthConfig: viewModel.monthConfig)
                    
                    
                    
                    cell.leftButton.addTarget(self, action: #selector(handleMinusMonth), for: .touchUpInside)
                    cell.rightButton.addTarget(self, action: #selector(handlePlusMonth), for: .touchUpInside)
                    return cell
                case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
                    
                    if viewModel.historyType == ""  {
                        let item = historyAllModel[indexPath.row]
                        cell.nameLabel.text = item.name
                        cell.dateLabel.text = item.date
                        cell.typeImg.kf.setImage(with: URL(string: item.image))
                        cell.countPriceLabel.text = viewModel.historyAllTypeCountPrice(priceUnit: item.priceUnit, countUnit: item.countUnit, price: item.price, count: item.count)
                    } else if viewModel.historyType == "/goods"{
                        let item = historyGoodsModel[indexPath.row]
                        cell.nameLabel.text = item.name
                        cell.dateLabel.text = item.date
                        cell.typeImg.kf.setImage(with: URL(string: item.image))
                        cell.countPriceLabel.text = "\(item.price.withCommas())\(item.priceUnit)"
                    } else if viewModel.historyType == "/store" {
                        let item = historyStoreModel[indexPath.row]
                        cell.nameLabel.text = item.name
                        cell.dateLabel.text = item.date
                        cell.countPriceLabel.text = "\(item.countUnit)\(item.count)회"
                        cell.typeImg.kf.setImage(with: URL(string: item.image))
                    }
                    cell.selectionStyle = .none
                    return cell
                default:
                    return UITableViewCell()
                }
                
            case 2:
                
                switch indexPath.section {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: couponCell, for: indexPath) as! CouponBuyTableViewCell
                    cell.selectionStyle = .none
                    
                    cell.collectionView.delegate = self
                    cell.collectionView.dataSource = self
                    cell.collectionView.register(CouponBuyCollectionViewCell.self, forCellWithReuseIdentifier: "CouponBuyCollectionViewCell")
                    let selectedIndexPath = IndexPath(row: viewModel.couponSelected, section: 0)
                    cell.collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
                    
                    cell.collectionView.backgroundColor = .white
                    
                    return cell
                    
                //쿠폰 사용
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CouponUsingTableViewCell", for: indexPath) as! CouponUsingTableViewCell
                    cell.selectionStyle = .none
                    
                    if viewModel.couponUsing {
                        cell.cancelButton.isHidden = false
                        cell.filterLabel.text = viewModel.couponModel.name
                        cell.cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
                        
                    } else {
                        cell.filterLabel.text = "사용가능한 쿠폰   \(viewModel.couponAbleCount)개"
                        cell.filterButton.addTarget(self, action: #selector(handleFilter), for: .touchUpInside)
                        cell.cancelButton.isHidden = true
                    }
                    
                    
                    return cell
                case 2:
                    
                    // 게산서 관련
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CouponPayReciptTableViewCell", for: indexPath) as! CouponPayReciptTableViewCell
                    cell.selectionStyle = .none
                    
                    
                    // 첫번째로 결제 화면 접근 시
                    if viewModel.firstPaymentTab {
                        //쿠폰 사용 했을 때
                        if viewModel.couponUsing {
                            // 쿠폰 종류 C -> 추가 쿠폰, 할인금액 0원
                            if viewModel.couponModel.types == "C" {
                                viewModel.goodsCount = "\(viewModel.goodsCount) + \(viewModel.couponModel.plusCount) 회"
                                cell.discountPriceLabel.text = "0원"
                                cell.totalPriceLabel.text = viewModel.goodsPrice
                            } else {
                                cell.discountPriceLabel.text = "-\(viewModel.couponModel.minusPrice.withCommas())원"
                                cell.totalPriceLabel.text = viewModel.goodsPrice
                            }
     
                        }
                        
                        //쿠폰 사용 안했을 시 가격 , 쿠폰 가격은 0원
                        cell.priceLabel.text = viewModel.goodsPrice
                        cell.usingCountLabel.text = viewModel.goodsCount
                        cell.totalPriceLabel.text = viewModel.goodsPrice
                        cell.discountPriceLabel.text = "0원"
                        
                    } else {
                        //쿠폰 사용 사용 / 안 사용
                        if viewModel.goodsModel.count != 0 {
                        if viewModel.couponUsing {
                            
                            let item = viewModel.goodsModel[0]
                            if viewModel.couponModel.types == "C" {
                                viewModel.goodsCount = "\(item.offerCount) + \(viewModel.couponModel.plusCount) 회"
                                cell.discountPriceLabel.text = "0원"
                                cell.totalPriceLabel.text = viewModel.goodsPrice
                            } else {
                                cell.discountPriceLabel.text = "-\(viewModel.couponModel.minusPrice.withCommas())원"
                                cell.totalPriceLabel.text = viewModel.goodsPrice
                            }
                            
                            viewModel.couponSelected = indexPath.item
                            viewModel.goodsPrice = "\(item.salePrice.withCommas()) 원"
                            
                            cell.priceLabel.text = viewModel.goodsPrice
                            cell.usingCountLabel.text = viewModel.goodsCount
                        } else {
                            let item = viewModel.goodsModel[0]
                            
                            viewModel.couponSelected = indexPath.item
                            viewModel.goodsPrice = "\(item.salePrice.withCommas()) 원"
                            viewModel.goodsCount = "\(item.offerCount) 회"
                            cell.discountPriceLabel.text = "0원"
                            cell.priceLabel.text = viewModel.goodsPrice
                            cell.usingCountLabel.text = viewModel.goodsCount
                            cell.totalPriceLabel.text = viewModel.goodsPrice
                        }
                        
                        
                        
                    }
                    }
                    

                    
                    
                    return cell
                    
                    // 결제 방법
                case 3:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CouponBuyMethodTableViewCell", for: indexPath) as! CouponBuyMethodTableViewCell
                    cell.selectionStyle = .none
                    cell.delegate = self
                    cell.payButton.addTarget(self, action: #selector(handlePay), for: .touchUpInside)
                    cell.contentView.setDimensions(width: view.frame.width, height: 414)

                    
                    return cell
                default:
                    break
                }
                
                return UITableViewCell()
                
            default:
                return UITableViewCell()
            }
            
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if index == 0 {
                return 500
            } else if index == 1 {
                if indexPath.section == 2{
                    return 80
                }
            } else if index == 2 {
                if indexPath.section == 2 {
                    //영수증
                    return 300
                } else if indexPath.section == 3 {
                    //
                    return 400
                }
            }
            return tableView.estimatedRowHeight
            
            
        }
        
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            switch index {
            case 0:
                return 1000
            case 1:
                switch indexPath.section {
                case 0:
                    return 200
                case 1:
                    return 200
                default:
                    return 200
                }
            case 2:
                switch indexPath.section {
                case 0:
                    return 200
                case 1:
                    return 200
                case 2:
                    return 414
                case 3:
                    return 400
                default:
                    return 200
                }
                
            default:
                return 200
            }
        }
        
        
        
        
        
    }
    
    extension MypageVC: MypageFilterViewDelegate {
        func filterView(_ view: MypageFilterView, didselect indexPath: Int) {
            guard let filter = MypageFilterOptions(rawValue: indexPath) else { return }
            
            index = indexPath
            
            switch index {
            case 0:
                print("나의 환경")
                self.bottomView.reloadData()
                self.delegate?.didSelect(filter: filter)

            case 1:
                print("이용내역")
                callHistroyRequest(type: viewModel.historyType, searchMonth: viewModel.getCurrenYearMonths(monthConfig: viewModel.monthConfig))
                
                bottomView.reloadData()
                delegate?.didSelect(filter: filter)
            case 2:
                viewModel.callGoodsList {
                    self.bottomView.reloadData()
                    self.delegate?.didSelect(filter: filter)
                } fail: { error in
                    self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                        
                    }
                }
            default:
                break
            }
            
            
        }
        
        
    }
    
    
    extension MypageVC : MypageHistoryFilterViewDelegate {
        func filterView(_ view: MypageHistoryFilterView, didselect indexPath: Int) {
            guard let filter = MypageHistroyOption(rawValue: indexPath) else { return }
            
            
            viewModel.filterIndex = indexPath
            
            switch viewModel.filterIndex {
            case 0:
                viewModel.historyType = ""
                callHistroyRequest(type: viewModel.historyType, searchMonth: viewModel.getCurrenYearMonths(monthConfig: viewModel.monthConfig))
            case 1:
                viewModel.historyType = "/store"
                callHistroyRequest(type: viewModel.historyType, searchMonth: viewModel.getCurrenYearMonths(monthConfig: viewModel.monthConfig))
            case 2:
                viewModel.historyType = "/goods"
                callHistroyRequest(type: viewModel.historyType, searchMonth: viewModel.getCurrenYearMonths(monthConfig: viewModel.monthConfig))
            default:
                break
            }
            
            
            
            delegate?.didSelectHistory(filter: filter)
        }
        
        
    }
    
    
    extension MypageVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel.goodsModel.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponBuyCollectionViewCell", for: indexPath) as! CouponBuyCollectionViewCell
            let item = viewModel.goodsModel[indexPath.item]
            
            cell.priceLabel.text = "\(item.salePrice.withCommas()) 원"
            cell.couponDescriptionLabel.text =  String(item.name)
//            cell.couponQuantityLabel.text = String(item.offerCount)
           cell.couponImg.kf.setImage(with: URL(string: item.image))
            
            
            
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize (width: 150, height: 180)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let item = viewModel.goodsModel[indexPath.item]
            viewModel.firstPaymentTab = true
            
            viewModel.couponSelected = indexPath.item
            viewModel.goodsPrice = "\(item.salePrice.withCommas()) 원"
            viewModel.goodsCount = "\(item.offerCount) 회"
            
            
            print("가격은? \(viewModel.goodsPrice)")
            
            let indexPath = IndexPath(row: 0, section: 2)
            
            bottomView.reloadRows(at: [indexPath], with: .none)
            
        }
        
        
    }
    
    
    extension MainTC : UITabBarControllerDelegate  {
        
        
        
    }
    
    
    extension MypageVC : CouponViewControllerDelegate {
        func couponSelected(couponModel: CouponModel) {
            viewModel.couponUsing = true
            viewModel.couponModel = couponModel
            self.bottomView.reloadData()
        }
        
        
        
    }



extension MypageVC : CouponBuyMethodTableViewCellDelegate {
    func paymentMethodSelecte(index: Int) {
        viewModel.paymentMethodSelected = PaymethodList.init(rawValue: index)!.methodCode
    }
    
    
    
    
}
