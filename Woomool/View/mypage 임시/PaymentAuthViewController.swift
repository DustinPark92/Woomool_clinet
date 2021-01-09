//
//  PaymentAuthViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/12/13.
//  Copyright © 2020 Woomool. All rights reserved.
//


import UIKit
import WebKit

class PaymentAuthViewController: UIViewController, WKScriptMessageHandler {
    let config = WKWebViewConfiguration()
    
    let url : String
    let paramsValue : String
    let paramsKey : String
    
    init(url : String,paramsValue : String, paramsKey : String ) {
        self.url = url
        self.paramsValue = paramsValue
        self.paramsKey = paramsKey
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        print(url)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: "okaydanalpay")

        let myWebView:WKWebView = WKWebView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),configuration: configuration)
        myWebView.navigationDelegate = self
        myWebView.uiDelegate = self
        
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("com.woomool.ios", forHTTPHeaderField: "x-requested-with")
        
        let endcodingValue = paramsValue.addingPercentEncodingForQueryParameter()
        
        request.httpMethod = "POST"
        let params = [
            paramsKey :  endcodingValue!
        ] as [String : Any]

        let postString = self.getPostString(params: params)
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        

        
  
        myWebView.load(request)

        self.view.addSubview(myWebView)
        
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }

    
    func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
            
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    
    
}




extension PaymentAuthViewController: WKUIDelegate,WKNavigationDelegate {
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

    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message body: \(message.body)")
        print("message frameInfo: \(message.frameInfo)")
    }
    
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        if let url = urlSchemeTask.request.url, url.scheme == "okaydanalpay" {
            
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
    
    
    
}


extension String {
    public func addingPercentEncodingForQueryParameter() -> String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)

        return allowed
    }()
}
