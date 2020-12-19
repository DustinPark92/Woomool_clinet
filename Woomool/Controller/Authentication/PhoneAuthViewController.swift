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
    var params = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        callCert()
    }
    

    func callCert() {
        APIRequest.shared.postCertUser { json in

             let url = json["url"].stringValue
            self.params = json["params"].stringValue
            let configuration = WKWebViewConfiguration()
            configuration.userContentController.add(self, name: "closewebview")
 
            let myWebView:WKWebView = WKWebView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),configuration: configuration)
            myWebView.navigationDelegate = self
            myWebView.uiDelegate = self
            
            var request = URLRequest(url: URL(string: url)!)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("com.woomool.ios", forHTTPHeaderField: "x-requested-with")
            request.httpMethod = "POST"
            
            
            
            let params = [
                "params":  json["params"].stringValue
             ]
            
            let postString = self.getPostString(params: params)
            request.httpBody = postString.data(using: .utf8)
            

            
      
            myWebView.load(request)
            
            self.view.addSubview(myWebView)
            

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
        let controller = SignUpViewController(params: params)
       navigationController?.pushViewController(controller, animated: true)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
       print("message body: \(message.body)")
       print("message frameInfo: \(message.frameInfo)")
     }
    
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
      if let url = urlSchemeTask.request.url, url.scheme == "closewebview" {
        
      }
    }
    

    
}

