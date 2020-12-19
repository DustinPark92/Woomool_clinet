//
//  MyWoomoolModel.swift
//  Woomool
//
//  Created by Dustin on 2020/09/02.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
import NMapsMap


enum WoomoolService : Int, CaseIterable {
    case name
    case adress
    case number
    
    var title: String{
        switch self {

        case .name:
            return "카페이름"
        case .adress:
            return  "주소"
        case .number:
            return  "전화번호"
        }
    }
    
    var placeHolder: String{
        switch self {

        case .name:
            return  "카페이름을 입력해주세요."
        case .adress:
            return  "카페의 주소를 입력해주세요"
        case .number:
            return "카페의 전화번호를 입력해주세요."
        }
    }
    
    
}



class MyWoomoolViewModel {
    
    let notiCVImage = ["ourwoomool_notice","ourwoomool_event","ourwoomool_manual","ourwoomool_story"]
    
    let notiTitle = ["공지사항","이벤트","이용방법","우물이야기"]
    
    var woomoolServiceTfContents = ["","",""]
    
    var bottomSheetCondition = "basicUnFold"
    
    var storeId : Array<String> = []
    
    var userLocation : Array<Double> = [0.0,0.0]
    
    
    func setScopeIcon(scopeColor : String) -> UIImage{
        var imageName =  ""
        
        if scopeColor == "GRAY" {
            imageName = "icon_bestWoomool2"
        } else {
            imageName = "icon_bestWoomool"
        }
        
        
        return UIImage(named: imageName)!
    }
    
  
    func setInActiveIcon(mapView: NMFMapView, lat: Double , lng : Double, setActive image : String){
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: lat, lng: lng)
            marker.mapView = mapView
            //마커색 ,이미지
            marker.iconImage = .init(image: UIImage(named: image)!)
            marker.iconTintColor = .blue
      
        }
    
    func setActiveIcon(mapView: NMFMapView, lat: Double , lng : Double, setActive image : String,marker : NMFMarker){
        
            marker.position = NMGLatLng(lat: lat, lng: lng)
            marker.mapView = mapView
            //마커색 ,이미지
            marker.iconImage = .init(image: UIImage(named: image)!)
            marker.iconTintColor = .blue
      
        }
    
    func inputContainerView(textField: UITextField, sv : UIView) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        view.addSubview(textField)
        textField.anchor(top:view.topAnchor,left: view.leftAnchor,right:view.rightAnchor,paddingLeft: 8,paddingBottom: 6)
        textField.setDimensions(width: 24, height: 30)
        textField.textColor = .black900
        textField.font = UIFont.NotoBold16
        
        
        view.addSubview(sv)
        
        
        
        sv.backgroundColor = .blue500
        sv.anchor(top:textField.bottomAnchor,left:view.leftAnchor,right:view.rightAnchor,paddingTop: 6,paddingLeft:8,height: 2)
        
        return view
    }
    
    func textField() -> UITextField {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "카페이름", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray350,NSAttributedString.Key.font : UIFont.NotoRegular16!])
        
        
        return tf
    }
        
    

}
