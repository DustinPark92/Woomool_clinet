
//
//  RecentViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/08/26.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
import NMapsMap
import CoreLocation



private let reuseIdentifier = "MyAreaTableViewCell"

class MyAreaViewController: UIViewController {
    

    
    let marker = NMFMarker()
    let activeMarker = NMFMarker()
    let mapView = NMFMapView()
    let tableView = SelfSizedTableView()
    let bottomActionSheet = MyAreaBottomSheetHeaderView()
    let bottomActionSheetFooter = MyAreaBottomActionSheetFooterView()
    let viewModel = MyWoomoolViewModel()
    let cafeDetailView = MyAreaBottomSheetCafeDetail()
    

    
    let myLocationButton : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "iconMyLocation"), for: .normal)
        bt.setDimensions(width: 54, height: 54)
        return bt
    }()
    var storeModel = [StoreModel]()
    var pickupStoreModel = PickUpStoreModel()
    var count = 3
    var locationManager = CLLocationManager()
    
    lazy var cancelRightBarButton = UIBarButtonItem(image: UIImage(named: "MyAreaXicon"), style: .done, target: self, action: #selector(handleMapList))
    lazy var listRightBarButton = UIBarButtonItem(image: UIImage(named: "list"), style: .done, target: self, action: #selector(handleListButton))
    

    

    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = listRightBarButton
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        configureUserLocation()
        configureUI()
        configureMap()
        configureTV()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushWooMoolService(noti:)), name: NSNotification.Name("pushWooMoolService"), object: nil)
        
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        
        
    }
    
    func callRequest() {
        
        APIRequest.shared.getStoreList(lat:viewModel.userLocation[0],lon: viewModel.userLocation[1]) { json in

            for item in json.array! {
                
                let storeData = StoreModel(contact: item["contact"].stringValue, storeId: item["storeId"].stringValue, operTime: item["operTime"].stringValue, address: item["address"].stringValue, distanceUnit: item["distanceUnit"].stringValue, scope: item["scope"].intValue, image: item["image"].stringValue, name: item["name"].stringValue, latitude: item["latitude"].doubleValue
                                           , longitude: item["longitude"].doubleValue,scopeColor: item["scopeColor"].stringValue,distance:item["distance"].stringValue,fresh: item["fresh"].stringValue)
                
                
                self.storeModel.append(storeData)
            }
            
            self.tableView.reloadData()
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        
        
        //상단 카드들..
        bottomActionSheet.addGestureRecognizer(tap)
        bottomActionSheet.isUserInteractionEnabled = true
        view.backgroundColor = .white

        title = "내 근처 우물"


    }
    
    func configureMap() {
        NotificationCenter.default.addObserver(self, selector: #selector(cafeDetailAppear(noti:)), name: NSNotification.Name("cafeDetailAppear"), object: nil)

        view.addSubview(mapView)
        mapView.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,right: view.rightAnchor)
        mapView.positionMode = .compass
        mapView.touchDelegate = self

        

        

        
    }
    
    @objc func cafeDetailAppear(noti : Notification) {
        guard let storeModel = noti.object.unsafelyUnwrapped as? StoreModel
        else { return }
    
        
        viewModel.bottomSheetCondition = "cafeUnFold"
        cafeDetailView.isHidden = false
        bottomActionSheet.isHidden = false
        bottomActionSheetFooter.isHidden = true
        tableView.isHidden = true
        self.navigationItem.rightBarButtonItem = cancelRightBarButton
        
        
        bottomActionSheet.distanceNotiLabel.isHidden = true
        cafeDetailView.adressLabel.text = storeModel.address
        cafeDetailView.distanceLabel.text = storeModel.distance
        cafeDetailView.cafeNameLabel.text = storeModel.name
        cafeDetailView.phoneLabel.text = storeModel.contact
        cafeDetailView.scopeLabel.text = String(storeModel.scope)
        cafeDetailView.bestImageView.image = viewModel.setScopeIcon(scopeColor: storeModel.scopeColor)
        
        if storeModel.fresh == "N" {
            cafeDetailView.newImageView.isHidden = true
        }
        
        
    }
    
    func configureUserLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    
    func configureTV() {
        let stack = UIStackView(arrangedSubviews: [mapView,bottomActionSheet,cafeDetailView,tableView,bottomActionSheetFooter])
        view.addSubview(stack)
        stack.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor)
        stack.axis = .vertical
        stack.spacing = 0
        view.addSubview(myLocationButton)
        myLocationButton.anchor(left:mapView.leftAnchor,bottom: mapView.bottomAnchor,paddingLeft: 15,paddingBottom: 8)
        myLocationButton.addTarget(self, action: #selector(handleMyLocation), for: .touchUpInside)
        cafeDetailView.setDimensions(width: view.frame.width, height: 220)
        bottomActionSheet.setDimensions(width: view.frame.width, height: 56)
        bottomActionSheetFooter.setDimensions(width: view.frame.width, height: 100)
        tableView.setDimensions(width: view.frame.width, height: 220)
  
        cafeDetailView.isHidden = true
        

        tableView.tableFooterView?.backgroundColor = .white
        tableView.register(MyAreaTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
//       
//        
        bottomActionSheet.topButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        bottomActionSheetFooter.serviceRequestButton.addTarget(self, action: #selector(handleRequest), for: .touchUpInside)
//        
    }
    
    func callCafeDetailByMap(storeId : String, lat: Double,lon : Double,success : @escaping() -> ()) {
        APIRequest.shared.getStoreDetail(storeId: storeId, lat: lat, lon: lon) { json in
          let pickupStoreModel = self.pickupStoreModel
            
            
            pickupStoreModel.address = json["address"].stringValue
            pickupStoreModel.operTime = json["operTime"].stringValue
            pickupStoreModel.scopeColor = json["scopeColor"].stringValue
            pickupStoreModel.latitude = json["latitude"].doubleValue
            pickupStoreModel.storeId = json["storeId"].stringValue
            pickupStoreModel.fresh = json["fresh"].stringValue
            pickupStoreModel.scope = json["scope"].doubleValue
            pickupStoreModel.longitude = json["longitude"].doubleValue
            pickupStoreModel.distance = json["distance"].stringValue
            pickupStoreModel.name = json["name"].stringValue
            pickupStoreModel.image = json["image"].stringValue
            pickupStoreModel.contact = json["contact"].stringValue
            pickupStoreModel.distanceUnit = json["distanceUnit"].stringValue
        
            success()
            
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
        }

    }
    
    
    
    //MARK: - @objc
    
    
    @objc func handleDismiss() {
        if viewModel.bottomSheetCondition == "basicUnFold" {
            viewModel.bottomSheetCondition = "basicFold"
            bottomActionSheet.distanceNotiLabel.isHidden = true
            cafeDetailView.isHidden = true
            bottomActionSheet.isHidden = false
            bottomActionSheetFooter.isHidden = true
            tableView.isHidden = true
            self.navigationItem.rightBarButtonItem = listRightBarButton
            self.navigationItem.rightBarButtonItem?.tintColor = .black
        } else if viewModel.bottomSheetCondition == "basicFold" {
            viewModel.bottomSheetCondition = "basicUnFold"
            bottomActionSheet.distanceNotiLabel.isHidden = false
            cafeDetailView.isHidden = true
            bottomActionSheet.isHidden = false
            bottomActionSheetFooter.isHidden = false
            tableView.isHidden = false
            self.navigationItem.rightBarButtonItem = listRightBarButton
            self.navigationItem.rightBarButtonItem?.tintColor = .black
        } else if viewModel.bottomSheetCondition == "cafeUnFold" {
            viewModel.bottomSheetCondition = "cafeFold"
            bottomActionSheet.distanceNotiLabel.isHidden = true
            cafeDetailView.isHidden = true
            bottomActionSheet.isHidden = false
            bottomActionSheetFooter.isHidden = true
            tableView.isHidden = true
            self.navigationItem.rightBarButtonItem = cancelRightBarButton
            self.navigationItem.rightBarButtonItem?.tintColor = .black
        } else if viewModel.bottomSheetCondition == "cafeFold" {
            viewModel.bottomSheetCondition = "cafeUnFold"
            cafeDetailView.isHidden = false
            bottomActionSheet.distanceNotiLabel.isHidden = true
            bottomActionSheet.isHidden = false
            bottomActionSheetFooter.isHidden = true
            tableView.isHidden = true
            self.navigationItem.rightBarButtonItem = cancelRightBarButton
            self.navigationItem.rightBarButtonItem?.tintColor = .black
            
        }
    }
    
    @objc func handleRequest() {
        let controller = WoomoolServiceRequestViewController()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func pushWooMoolService(noti: Notification) {
        let controller = WoomoolServiceRequestViewController()
        navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    @objc func handleMyLocation() {
        locationManager.startUpdatingLocation()
    }
    
    
    @objc func handleMapList() {
        viewModel.bottomSheetCondition = "basicUnFold"
        cafeDetailView.isHidden = true
        bottomActionSheet.isHidden = false
        bottomActionSheetFooter.isHidden = false
        tableView.isHidden = false
        self.navigationItem.rightBarButtonItem = listRightBarButton
        activeMarker.mapView = nil
    }
    
    @objc func handleListButton() {
        let controller = MyAreaDetailTableViewController()
        controller.userLocation = viewModel.userLocation
           present(controller, animated: true, completion: nil)
    }
    
    
}


extension MyAreaViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeModel.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MyAreaTableViewCell
        
        cell.selectionStyle = .none
        
        let storeItem = storeModel[indexPath.row]

        cell.cafeNameLabel.text = storeItem.name
        cell.adressLabel.text = storeItem.address
        cell.bestImageView.image = viewModel.setScopeIcon(scopeColor: storeItem.scopeColor)
        cell.distanceLabel.text = "\(storeItem.distance)\(storeItem.distanceUnit)"
        
        if storeItem.fresh == "N" {
            cell.newImageView.isHidden = true
        }
        
        if indexPath.row > 3 {
            cell.alpha = 0.5
        }
  
        
        
     viewModel.setInActiveIcon(mapView: mapView, lat: storeItem.latitude, lng: storeItem.longitude, setActive: "pos_inactive")
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
   
            
        } else if scrollView.contentOffset.y > 3 {
            let controller = MyAreaDetailTableViewController()
            controller.userLocation = viewModel.userLocation
               present(controller, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storeItem = storeModel[indexPath.row]
        

        viewModel.bottomSheetCondition = "cafeUnFold"
        cafeDetailView.isHidden = false
        bottomActionSheet.isHidden = false
        bottomActionSheet.distanceNotiLabel.isHidden = true
        bottomActionSheetFooter.isHidden = true
        tableView.isHidden = true
        self.navigationItem.rightBarButtonItem = cancelRightBarButton
        
        
        cafeDetailView.adressLabel.text = storeItem.address
        cafeDetailView.distanceLabel.text = "\(storeItem.distance)\(storeItem.distanceUnit)"
        cafeDetailView.cafeNameLabel.text = storeItem.name
        cafeDetailView.phoneLabel.text = storeItem.contact
        cafeDetailView.scopeLabel.text = "\(storeItem.scope)"
        cafeDetailView.bestImageView.image = viewModel.setScopeIcon(scopeColor: storeItem.scopeColor)
        
        viewModel.setActiveIcon(mapView: mapView, lat: storeItem.latitude, lng: storeItem.longitude, setActive: "pos_active", marker: self.activeMarker)
        
        if storeItem.fresh == "N" {
            cafeDetailView.isHidden = true
        }

    }
    
    
    
    
}

//MARK: - naverMapViewDelegate


extension MyAreaViewController : NMFMapViewTouchDelegate {
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        viewModel.storeId.removeAll()
        
        viewModel.storeId = storeModel.filter {
            round($0.latitude*1000)/1000 == round(latlng.lat*1000)/1000 && round($0.longitude*1000)/1000 == round(latlng.lng*1000)/1000
        }.map {
            $0.storeId
        }
        
        
        if viewModel.storeId == [] {
            activeMarker.mapView = nil
            viewModel.bottomSheetCondition = "basicFold"
            bottomActionSheet.distanceNotiLabel.isHidden = true
            cafeDetailView.isHidden = true
            bottomActionSheet.isHidden = false
            bottomActionSheetFooter.isHidden = true
            tableView.isHidden = true
            self.navigationItem.rightBarButtonItem = nil
        } else {
            activeMarker.mapView = nil
      
            callCafeDetailByMap(storeId: viewModel.storeId[0], lat: viewModel.userLocation[0], lon: viewModel.userLocation[1], success: {
                
                self.viewModel.bottomSheetCondition = "cafeFold"
                self.bottomActionSheet.distanceNotiLabel.isHidden = true
                self.cafeDetailView.isHidden = false
                self.cafeDetailView.adressLabel.text = self.pickupStoreModel.address
                self.cafeDetailView.cafeNameLabel.text = self.pickupStoreModel.name
                self.bottomActionSheet.distanceNotiLabel.isHidden = true
                self.cafeDetailView.adressLabel.text = self.pickupStoreModel.address
                self.cafeDetailView.distanceLabel.text = self.pickupStoreModel.distance
                self.cafeDetailView.phoneLabel.text = self.pickupStoreModel.contact
                self.cafeDetailView.bestImageView.image = self.viewModel.setScopeIcon(scopeColor: self.pickupStoreModel.scopeColor)
                
                if self.pickupStoreModel.fresh == "N" {
                    self.cafeDetailView.newImageView.isHidden = true
                }
                
                
                self.bottomActionSheet.isHidden = false
                self.bottomActionSheetFooter.isHidden = true
                self.tableView.isHidden = true
                self.navigationItem.rightBarButtonItem = self.cancelRightBarButton
                
                self.viewModel.setActiveIcon(mapView: mapView, lat: self.pickupStoreModel.latitude, lng: self.pickupStoreModel.longitude, setActive: "pos_active", marker: self.activeMarker)
            })
            
            }
    }

        
        
        
        
}
    

    

// MARK: - CLLocationManagerDelegate
//1
extension MyAreaViewController: CLLocationManagerDelegate {
    // 2

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            
            
            return
        }

    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        viewModel.userLocation.removeAll()
        storeModel.removeAll()
        
        
        viewModel.userLocation.append(location.coordinate.latitude)
        viewModel.userLocation.append(location.coordinate.longitude)
        
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: viewModel.userLocation[0], lng: viewModel.userLocation[1]))
        mapView.moveCamera(cameraUpdate)
        callRequest()
        
        
        
        
        locationManager.stopUpdatingLocation()
       

    }
}
