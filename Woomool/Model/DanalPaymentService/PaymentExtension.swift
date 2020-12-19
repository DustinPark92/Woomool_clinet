//
//  PaymentExtensionViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/12/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
import WebKit

class PaymentExtension: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var wkWebView : WKWebView?;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.createWKWebView();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    func createWKWebView()
    {
        let strOrderUrl = Define.PAY_SERVER_URL;
        
        self.wkWebView = WKWebView.init();
        self.wkWebView?.navigationDelegate = self;
        self.wkWebView?.uiDelegate = self;
        self.wkWebView?.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(self.wkWebView!);
        
        if #available(iOS 11.0, *)
        {
            let tempSafeArea = self.view.safeAreaLayoutGuide;
            self.wkWebView?.leadingAnchor.constraint(equalTo: tempSafeArea.leadingAnchor).isActive = true;
            self.wkWebView?.topAnchor.constraint(equalTo: tempSafeArea.topAnchor).isActive = true;
            self.wkWebView?.trailingAnchor.constraint(equalTo: tempSafeArea.trailingAnchor).isActive = true;
            self.wkWebView?.bottomAnchor.constraint(equalTo: tempSafeArea.bottomAnchor).isActive = true;
        }
        else
        {
            self.wkWebView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
            self.wkWebView?.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true;
            self.wkWebView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
            self.wkWebView?.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true;
        }
        
        let nsurl : URL = URL.init(string: strOrderUrl)!;
        let nsRequest : URLRequest = URLRequest.init(url: nsurl);
        self.wkWebView?.load(nsRequest);
    }
    
    
    // MARK: - WKNavigationDelegate
    /**
     * 웹페이지 탐색 접근을 허용 할지 취소 할지 결정 한다.
     *   decisionHandler 블록을 통해 의사결정을 전달 하여 처리 된다.
     *      전달 할 인자 값
     *          WKNavigationActionPolicy.allow == 탐색 혀용
     *          WKNavigationActionPolicy.cancel == 탐색 취소
     *  참조(objc) : https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455641-webview?language=objc
     *  참조(swift) : https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455641-webview?language=swift
     */
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void)
    {
        
        let url = navigationAction.request.url!;
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
    
    // MARK: - WKUIDelegate
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void)
    {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            completionHandler()
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void)
    {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView?
    {
        
        let tempWhiteListSchemeHandler = WhiteListSchemeHandler.init(vc: self);
        if( true == tempWhiteListSchemeHandler.openScheme(requestedURL: navigationAction.request.url! as NSURL) )
        {
            tempWhiteListSchemeHandler.handleScheme(requestedURL: navigationAction.request.url! as NSURL);
        }
        
        return nil;
    }
    
    
    
    /*
     
     */
    
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
