
//
//  RecentViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/08/26.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
//import NMapsMap
import CoreLocation



private let reuseIdentifier = "MyAreaTableViewCell"

class MyAreaViewController: UIViewController {
    

    
//    let marker = NMFMarker()
//    let mapView = NMFMapView()
    let tableView = SelfSizedTableView()
    let bottomActionSheet = MyAreaBottomSheetHeaderView()
    let bottomActionSheetFooter = MyAreaBottomActionSheetFooterView()
    let viewModel = MyWoomoolViewModel()
    

    
    let myLocationButton : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "iconMyLocation"), for: .normal)
        bt.setDimensions(width: 54, height: 54)
        return bt
    }()
    var storeModel = [StoreModel]()
    var count = 3
    var locationManager = CLLocationManager()
    

    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUserLocation()
        currentLocation()
        configureUI()
        configureMap()
        configureTV()
        NotificationCenter.default.addObserver(self, selector: #selector(pushWooMoolService(noti:)), name: NSNotification.Name("pushWooMoolService"), object: nil)
        
        Request.shared.getStoreList { json in
            
            
            for item in json.array! {
                
                let storeData = StoreModel(contact: item["contact"].stringValue, storeId: item["storeId"].stringValue, operatingTime: item["operatingTime"].stringValue, address: item["address"].stringValue, scope: item["scope"].intValue, image: item["image"].stringValue, name: item["name"].stringValue, latitude: item["latitude"].doubleValue
                                           , longitude: item["longitude"].doubleValue)
                
                
                self.storeModel.append(storeData)
            }
            
            self.tableView.reloadData()
        }
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white

        title = "내 근처 우물"

        

    }
    
    func configureMap() {
        

//        view.addSubview(mapView)
//        mapView.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,right: view.rightAnchor)
//        mapView.positionMode = .compass
//
//        
//        viewModel.setActiveIcon(mapView: mapView, lat: 37.5451851, lng: 127.0705772, setActive: "pos_active")
//        viewModel.setActiveIcon(mapView: mapView, lat: 37.5455212, lng: 127.0711417, setActive: "pos_inactive")
        

        
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
//        view.addSubview(tableView)
//        view.addSubview(bottomActionSheet)
//        view.addSubview(bottomActionSheetFooter)
//        view.addSubview(myLocationButton)
//        myLocationButton.anchor(left:mapView.leftAnchor,bottom: mapView.bottomAnchor,paddingLeft: 15,paddingBottom: 8)
//        
//        myLocationButton.addTarget(self, action: #selector(handleMyLocation), for: .touchUpInside)
//        
//        
//        tableView.anchor(top:bottomActionSheet.bottomAnchor,left:view.leftAnchor,right: view.rightAnchor,height: 200)
//        
//        
//        
//        
//        bottomActionSheet.anchor(top:mapView.bottomAnchor,left:view.leftAnchor,bottom: tableView.topAnchor,right: view.rightAnchor,height: 80)
//        bottomActionSheetFooter.anchor(top:tableView.bottomAnchor,left:view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,height: 95)
//        tableView.tableFooterView?.backgroundColor = .white
//        tableView.register(MyAreaTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
//        tableView.delegate = self
//        tableView.dataSource = self
//       
//        
//        bottomActionSheet.topButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
//        bottomActionSheetFooter.serviceRequestButton.addTarget(self, action: #selector(handleRequest), for: .touchUpInside)
//        
    }
    
    
    
    //MARK: - @objc
    
    
    @objc func handleDismiss() {
        
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
    
    
}


extension MyAreaViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MyAreaTableViewCell
        
        cell.selectionStyle = .none
        
//        let storeItem = storeModel[indexPath.row]
//
//        cell.cafeNameLabel.text = storeItem.name
//        cell.adressLabel.text = storeItem.address
//        viewModel.setActiveIcon(mapView: mapView, lat: storeItem.latitude, lng: storeItem.longitude, setActive: "pos_inactive")
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
   
            
        } else if scrollView.contentOffset.y > 3 {
            let controller = MyAreaDetailTableViewController()
               present(controller, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("handle Cell")
    }
    
    
    
    
}


// MARK: - CLLocationManagerDelegate
//1
extension MyAreaViewController: CLLocationManagerDelegate {
    // 2
    
    
    func currentLocation() {

            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {

                case .notDetermined, .restricted, .denied:
                    let alert = UIAlertController(title: "위치 정보를 확인 할 수 없습니다.", message: "지도를 사용하기 위해서는 위치정보가 필요 합니다.", preferredStyle: .alert)
                    let addAction = UIAlertAction(title: "확인", style: .cancel) { (_) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(addAction)
                    present(alert, animated: true, completion: nil)
                    
   
                case .authorizedAlways, .authorizedWhenInUse:
                        print("ok")
                    @unknown default:
                    break
                }
                } else {
                    print("Location services are not enabled")
            }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            
            
            return
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
//        mapView.isMyLocationEnabled = true
//        mapView.settings.myLocationButton = true
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        
//        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude))
//        mapView.moveCamera(cameraUpdate)
//        
        locationManager.stopUpdatingLocation()
        
        
        // 7

        // 8
        
    }
}
