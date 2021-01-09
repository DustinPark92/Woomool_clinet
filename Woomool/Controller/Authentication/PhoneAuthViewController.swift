//
//  PhoneAuthViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/12/12.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
import WebKit

class PhoneAuthViewController: UIViewController, WKScriptMessageHandler {
    let config = WKWebViewConfiguration()
    var myWebView = WKWebView()
    var transData = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(okaydanaluas(noti:)), name: NSNotification.Name("okaydanaluas"), object: nil)
        callCert()
    }
    

    func callCert() {
        APIRequest.shared.postCertUser { json in
            

             let url = json["url"].stringValue
            let endcodingValue = json["paramsValue"].stringValue.addingPercentEncodingForQueryParameter()
            self.transData = json["transData"].stringValue
            let configuration = WKWebViewConfiguration()
            configuration.userContentController.add(self, name: "okaydanaluas")
 
            self.myWebView = WKWebView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),configuration: configuration)
            self.myWebView.navigationDelegate = self
            self.myWebView.uiDelegate = self
            
            var request = URLRequest(url: URL(string: url)!)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("com.woomool.ios", forHTTPHeaderField: "x-requested-with")
            request.httpMethod = "POST"
            
            print(json)
            let params = [
                json["paramsKey"].stringValue :  endcodingValue!
            ] 
            
            /*
             "transData" : "eyJ1c2VySWQiOiI4MzA5MWJlOWU4Y2M0NjI5OGY0ZTJiYmZhNmNhYTEzZSJ9",
             "paramsValue" : "eyJJc0NhcnJpZXIiOiIiLCJJc0NoYXJTZXQiOiJFVUMtS1IiLCJCZ0NvbG9yIjoiMDAiLCJJc0RzdEFkZHIiOiIiLCJCeVBhc3NWYWx1ZSI6IiIsIlRJRCI6IkNNMTA2NDA4STUiLCJCYWNrVVJMIjoiaHR0cDovLzIxMS4yNTAuMjEzLjU6MjExMDAvd2ViL3ZpZXdzL2NhbmNlbCIsIlVSTCI6Imh0dHBzOi8vd2F1dGgudGVsZWRpdC5jb20vRGFuYWwvV2ViQXV0aC9Nb2JpbGUvU3RhcnQucGhwIn0=",
             "url" : "http:\/\/211.250.213.5:21100\/web\/views\/cert\/ready",
             "paramsKey" : "PARAMS"
             */
            
            let postString = self.getPostString(params: params)
            request.httpBody = postString.data(using: .utf8)
            self.myWebView.load(request)
            
            self.view.addSubview(self.myWebView)
            

        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
        }
        
        
    }
    
    func getPostString(params:[String:String]) -> String
        {
            var data = [String]()
            for(key, value) in params
            {
                data.append(key + "=\(value)")

            }
            return data.map { String($0) }.joined(separator: "&")
        }
    
    
    @objc func okaydanaluas(noti : Notification) {
        self.myWebView.window?.rootViewController?.dismiss(animated: true, completion: {
            let controller = SignUpViewController(transData: self.transData)
            self.navigationController?.pushViewController(controller, animated: true)
        })
        
    }
    
    

}




extension PhoneAuthViewController: WKUIDelegate,WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish")
      
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Set the indicator everytime webView started loading
      //  showLoader(true)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //showLoader(false)
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        let controller = SignUpViewController(transData: self.transData)
       navigationController?.pushViewController(controller, animated: true)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
       print("message body: \(message.body)")
       print("message frameInfo: \(message.frameInfo)")
     }
    
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
      if let url = urlSchemeTask.request.url, url.scheme == "okaydanaluas" {
        
      }
    }
    
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void)
    {
        let url = navigationAction.request.url as! URL;
        let tempWhiteListSchemeHandler = WhiteListSchemeHandler.init(vc: self);
        if( self.isItuensUrl(url: url.absoluteString ) == true )
        {
            if( true == tempWhiteListSchemeHandler.openScheme(requestedURL: url as NSURL) )
            {
                tempWhiteListSchemeHandler.handleScheme(requestedURL: url as NSURL);
                decisionHandler(WKNavigationActionPolicy.cancel);
            }
            else
            {
                decisionHandler(WKNavigationActionPolicy.allow);
            }
            return;
        }
        else if( false == (true == url.scheme?.elementsEqual("http") ||
                            true == url.scheme?.elementsEqual("https") ||
                            true == url.scheme?.elementsEqual("about")) )
        {
            if( true == tempWhiteListSchemeHandler.openScheme(requestedURL: url as NSURL) )
            {
                tempWhiteListSchemeHandler.handleScheme(requestedURL: url as NSURL);
                
            }
            else
            {
                /*
                 앱이 호출 불가능 합니다.
                 URL Scheme 정보를 정확하게 입력 하거나,
                 URL Scheme 에 해당 하는 앱이 설치 될 수 있도록 유도 되어야 합니다.
                 */
                // app url shceme 값이 info.plist white list에 정상 등록 되어있으며
                // app url shceme 값에 해당하는 다운로드 페이지 정보 값이 pay_app_urls.plist 파일에 정상 등록 되어있으면
                // 아래 호출로, 다운로드 페이지로 이동하게 된다.
                tempWhiteListSchemeHandler.handleScheme(requestedURL: url as NSURL);
            }
            decisionHandler(WKNavigationActionPolicy.cancel);
            return;
        }
        decisionHandler(WKNavigationActionPolicy.allow);
    }
    
    func isMatch( url: String, pattern: String) -> Bool
    {
        
        do {
            let regex = try NSRegularExpression.init(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0));
            
            let res : [NSTextCheckingResult] = regex.matches(in: url, options:  NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, url.count));
            
            return res.count != 0;
        }
        catch {
            return false;
        }
        
        
    }
    
    func isItuensUrl(url:String) -> Bool
    {
        return self.isMatch(url: url, pattern: "\\/\\/itunes\\.apple\\.com\\/");
    }
    
    
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void))  {
//
//       print("webView:\(webView) decidePolicyForNavigationAction:\(navigationAction) decisionHandler:\(decisionHandler)")
//
//       if let url = navigationAction.request.url {
//        let requestedURL = url
//        let receivedLink = requestedURL.absoluteString
//        if receivedLink.contains("teleditapp:Result:") {
//            let result = receivedLink.removingPercentEncoding
//
//
//            self.showOkAlert(title: "알림", message: result!) {
//                print(result!)
//            }
//
//
//        }
//
//        if receivedLink.contains("woomooldanalcancel:window.close") {
//            dismiss(animated: true)
//        }
//
//       }
//
//
//
//       decisionHandler(.allow)
//   }
    


    
}

