//
//  MyPageTableViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/07.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

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
    var userModel : UserModel?
    
    var goodsModel = [GoodsModel]()
    var couponAbleCount = 0
    var goodsPrice = "9,900원"
    var viewModel = MypageViewModel()
    
    
    weak var delegate : MypageVCDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        callGoodsList()
        configureUI()
        navigationController?.navigationBar.isHidden = true
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = true
    }
    
    func configureUI() {
        bottomView.tableHeaderView = topView
        topView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 320)
        
        topView.friendInviteButton.addTarget(self, action: #selector(handleInviteBtn), for: .touchUpInside)
        topView.settingBtn.addTarget(self, action: #selector(handleSettingBtn), for: .touchUpInside)
        topView.nextBtn.addTarget(self, action: #selector(handleUserSetting), for: .touchUpInside)
        topView.userModel = userModel
        
        topView.userGradeButton.addTarget(self, action: #selector(handleUserGradeButton), for: .touchUpInside)
        
        
        
        topView.filterBar.delegate = self
        view.backgroundColor = .white
        

        view.addSubview(bottomView)
        bottomView.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor)
   
        bottomView.delegate = self
        bottomView.dataSource = self
        
        bottomView.register(CouponBuyTableViewCell.self, forCellReuseIdentifier: couponCell)
        bottomView.register(MyEnvironmentTableViewCell.self, forCellReuseIdentifier: myEnviromentCell)
        bottomView.register(HistoryFilterTableViewCell.self, forCellReuseIdentifier: historyCell)
        bottomView.register(CouponUsingTableViewCell.self, forCellReuseIdentifier: "CouponUsingTableViewCell")
        bottomView.register(CouponPayReciptTableViewCell.self, forCellReuseIdentifier: "CouponPayReciptTableViewCell")
        bottomView.register(HistoryDateTableViewCell.self, forCellReuseIdentifier: "HistoryDateTableViewCell")
        bottomView.register(HistoryTableViewCell.self, forCellReuseIdentifier: "HistoryTableViewCell")
        
        
        
    }
    
    //MARK: - objc
    
    
    @objc func handleUserSetting() {
        let controller = UserInfoTableViewController()
        
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func handleSettingBtn() {
        let controller = SettingViewController(style: .grouped)
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
        if couponAbleCount == 0 {
            print("사용 가능한 쿠폰 없음")
        } else {
        let controller = CouponViewController()
        navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func handleUserGradeButton() {
        let controller = UserGradeViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handlePay() {
//        Request.shared.PostGoodsPurchase(couponId: "", goodsId: goodsModel[viewModel.couponSelected].goodsId, buyInfo: "카드결제", buyMethod: "C", buyPrice: goodsModel[viewModel.couponSelected].salePrice) { json in
//            self.showOkAlert(title: "\(self.goodsModel[self.viewModel.couponSelected].goodsId)\n\(self.goodsModel[self.viewModel.couponSelected].salePrice)원 결제완료.", message: "결제완료") {
//                print("아아")
//            }
//        } refreshSuccess: {
//            Request.shared.PostGoodsPurchase(couponId: "", goodsId: "", buyInfo: "카드결제", buyMethod: "C", buyPrice: 9900) { json in
//                print("Success")
//            } refreshSuccess: {
//                print("nil")
//            }
//        }

    }
    
    func configureRequest() {

        
    }
    

    
    func callGoodsList() {
//        Request.shared.getGoodsList { json in
//            
//            self.couponAbleCount = json["couponCount"].intValue
//            
//            
//            for item in json["goods"].arrayValue {
//                let goodsList = GoodsModel(goodsId: item["goodsId"].stringValue, name: item["name"].stringValue, description: item["description"].stringValue, image: item["image"].stringValue, goodsType:  item["types"].stringValue, ableCount: item["ableCount"].intValue, originPrice: item["originPrice"].intValue, salePrice: item["salePrice"].intValue, discountRate: item["discountRate"].intValue, offerCount: item["offerCount"].intValue)
//                
//                
//                self.goodsModel.append(goodsList)
//            }
//            
//            self.bottomView.reloadData()
//        }
        
    }
    

}

extension MypageVC : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch index {
        case 1:
            return 3
        case 2:
            return 3
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
        let cell = tableView.dequeueReusableCell(withIdentifier: myEnviromentCell, for: indexPath) as! MyEnvironmentTableViewCell
    
        switch index {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: myEnviromentCell , for: indexPath) as! MyEnvironmentTableViewCell
            
           
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
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
                cell.selectionStyle = .none
                return cell
            default:
                return cell
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
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CouponUsingTableViewCell", for: indexPath) as! CouponUsingTableViewCell
                cell.selectionStyle = .none
                cell.filterLabel.text = "사용가능한 쿠폰   \(couponAbleCount)개"
                cell.filterButton.addTarget(self, action: #selector(handleFilter), for: .touchUpInside)
                cell.cancelButton.isHidden = false
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CouponPayReciptTableViewCell", for: indexPath) as! CouponPayReciptTableViewCell
                cell.selectionStyle = .none
//                cell.priceLabel.text = viewModel.goodsPrice
//                cell.usingCountLabel.text = viewModel.goodsCount
//
        
                
                
                
                cell.payButton.addTarget(self, action: #selector(handlePay), for: .touchUpInside)
                cell.contentView.setDimensions(width: view.frame.width, height: 414)
               
                return cell
            default:
                break
            }

            return cell
            
        default:
            return cell
        }
        

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch index {
        case 0:
            return 200
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
            bottomView.reloadData()
            delegate?.didSelect(filter: filter)
        case 1:
            print("이용내역")
            bottomView.reloadData()
            delegate?.didSelect(filter: filter)
        case 2:
            bottomView.reloadData()
            delegate?.didSelect(filter: filter)
        default:
            break
        }
        

    }
    

}


extension MypageVC : MypageHistoryFilterViewDelegate {
    func filterView(_ view: MypageHistoryFilterView, didselect indexPath: Int) {
        guard let filter = MypageHistroyOption(rawValue: indexPath) else { return }


//        viewModel.filterIndex = indexPath
//
//        switch viewModel.filterIndex {
//        case 0:
//            print("123")
//        case 1:
//            print("123")
//        case 2:
//            print("123")
//        default:
//            break
//        }
        
        
        
        delegate?.didSelectHistory(filter: filter)
    }
    
    
}


extension MypageVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return goodsModel.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponBuyCollectionViewCell", for: indexPath) as! CouponBuyCollectionViewCell
    let item = goodsModel[indexPath.item]
    
    cell.priceLabel.text = String(item.name)
    //cell.couponQuantityLabel.text = String(item.offerCount)
    
    
    
    
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
        let item = goodsModel[indexPath.item]
        
        viewModel.couponSelected = indexPath.item
//        viewModel.goodsPrice = String(item.salePrice.withCommas())
//        viewModel.goodsCount = "\(item.offerCount) 회"
     
        let indexPath = IndexPath(row: 0, section: 2)
        
        bottomView.reloadRows(at: [indexPath], with: .none)
        
    }
    
    
}
