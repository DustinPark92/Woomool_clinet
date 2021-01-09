//
//  SchemeHandler.swift
//  Woomool
//
//  Created by Dustin on 2020/12/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class SchemeHandler: NSObject {
    
    var viewController : UIViewController? = nil;
    
    func openScheme(requestedURL: NSURL) -> Bool
    {
        return false;
    }
    
    init(vc:UIViewController)
    {
        self.viewController = vc;
    }
    
    
    /**
     요청된 App Scheme URL을 제약 없이 Open 시킨다.
     
     @param requestedURL 요청 URL 정보
     */
    func handleScheme(requestedURL:NSURL)
    {
        let application : UIApplication = UIApplication.shared;
        
        if let url = requestedURL.absoluteURL {
            if #available(iOS 10, *) {
                application.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            
                            let tempStr = url.scheme ?? "알수없음";
                                            
                            if true == success {
                               print("Open \(tempStr) : success");

                                            //MARK: - 결제 성공 : okaydanalpay
                                            if tempStr == "okaydanalpay" {
                                                
                                                self.viewController?.showOkAlert(title: "결제가 완료 되었습니다", message: "", fail: {
                                                    let controller = MainTC()
                                                    controller.selectedIndex = 0
                                                    UIApplication.shared.windows.first?.rootViewController = controller
                                                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                                                    
                    
                                                })
                                                
                                            }
                                        } else {
                                            
                                            
                                            
                                            switch tempStr {
                                            //MARK: - 결제 취소, 결제 실패
                                            case "canceldanalpay","errordanalpay":
                                                do {
                                                    try self.openUrlByCustomList(requestURL: requestedURL);
                                                } catch {
                                                    print("error: \(error)")
                                                }
                                            //MARK: - 본인 인증 성공
                                            case "okaydanaluas":
                                                NotificationCenter.default.post(name: NSNotification.Name("okaydanaluas"), object: nil)
                                            //MARK: - 본인 인증 취소
                                            case "canceldanaluas":
                                                print("canceldanaluas")
                                                
                                            default:
                                                break
                                            }
                    
                                            print("App Scheme 값이 잘못 되었거나, 접근을 허용하지 않았거나, 앱이 설치 되어 있지 않습니다.\(tempStr))");

                                        }
                                            
                })
            } else {
                let success : Bool = application.openURL(url);
                
                let tempStr = requestedURL.scheme ?? "알수없음";
                if( true == success )
                {
                    
                    print("Open 1 \(tempStr): success");
                } else {
                    print("App Scheme 값이 잘못 되었거나, 접근을 허용하지 않았거나, 앱이 설치 되어 있지 않습니다.\(tempStr)");
                    
                    do {
                        try self.openUrlByCustomList(requestURL: requestedURL);
                    } catch {
                        print("error: \(error)")
                    }
                }
                
            }
        }
    }
    
    
    func openUrlByCustomList(requestURL: NSURL) throws
    {
        var tempDic : NSDictionary? = nil;
        
        tempDic = SamplePlistManager.Shared.getValue(key: requestURL.scheme!);
        if( tempDic == nil || tempDic == [:] )
        {
            let tempStr = requestURL.absoluteString ?? "알수없음";
            let tempMsg : String = "(SamplePlistManager) Scheme 값 정보가 없음\n(DanalPayDemo)\nrequestedURL, \(tempStr)";
            
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "" ,
                                                        message: tempMsg,
                                                        preferredStyle: UIAlertController.Style.alert);
                
                let cancelButton = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil);
                alertController.addAction(cancelButton);
                self.viewController?.present(alertController,animated: true,completion: nil);
                
            }
        }
        else
        {
            var tempIsKnownAppDNUrl = false;
            var tempMsg = "";
            
            if( (tempDic!["itunes-id"] as! String).elementsEqual("Unknown") == true ||
            (tempDic!["itunes-id"] as! String).elementsEqual("") == true )
            {
                tempIsKnownAppDNUrl = false;
                tempMsg = "앱이 설치 되어 있지 않으며, 다운로드 경로를 알 수 없습니다.\n문의 바랍니다.";
            }
            else
            {
                tempIsKnownAppDNUrl = true;
                tempMsg = "앱이 설치되어 있지 않았거나 앱 실행 거부로, 앱이 실행 되지 못했습니다. 다운로드 페이지로 이동 하시겠습니까?";
            }
            DispatchQueue.main.async {
                
                let alertController = UIAlertController(title: tempDic?["name"] as? String,
                                                        message: tempMsg,
                                                        preferredStyle: UIAlertController.Style.alert);
                
                if( true == tempIsKnownAppDNUrl )
                {
                    //tempDic!["itunes-id"]
                    
                    let tempId : String = tempDic!["itunes-id"] as! String;
                    
                    let okAction = UIAlertAction(title: "다운받기", style: UIAlertAction.Style.destructive){ (action: UIAlertAction) in
                        let tempUrl = "itms-apps://itunes.apple.com/app/\(tempId)?mt=8";
                        print("tempUrl \(tempUrl)")
                        self.handleScheme(requestedURL: NSURL.init(string: tempUrl)!);
                    }
                    let cancelButton = UIAlertAction(title: "닫기", style: UIAlertAction.Style.cancel, handler: nil);
                    alertController.addAction(okAction);
                    alertController.addAction(cancelButton);
                }
                else
                {
                    
                    let cancelButton = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil);
                    
                    alertController.addAction(cancelButton);
                }
                
                
                self.viewController?.present(alertController,animated: true,completion: nil);
                
            }
        }
        
    }

}
