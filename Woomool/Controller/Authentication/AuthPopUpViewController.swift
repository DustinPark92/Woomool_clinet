//
//  AuthPopUpViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/04.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NaverThirdPartyLogin
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn

class AuthPopUpViewController: UIViewController {
    
    let viewModel = SignUpViewModel()
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    lazy var mainView = SignUpViewModel().popUpView(naverButton: naverButton, googleButton: googleButton, kakaoButton: kakaoButton, appleButton: appleButton, emailButton: emailBUtton, mainLabel: mainLabel, subLabel: subLabel,findPassButton: findPassButton,signUpButton: signUpButton, sv: sv)
    
    lazy var naverButton = viewModel.oAuthButton(setImage: UIImage(named: "sns_naver")!)
    lazy var googleButton = viewModel.oAuthButton(setImage: UIImage(named: "sns_google")!)

    
    
    lazy var kakaoButton = viewModel.oAuthButton(setImage: UIImage(named: "sns_kakao")!)
    lazy var appleButton = viewModel.oAuthButton(setImage: UIImage(named: "sns_apple")!)
    lazy var emailBUtton = viewModel.buttonUI(setTitle: emailButtonTitle )
    lazy var mainLabel = viewModel.labelUI(setTitle: titleLabel, setFont: UIFont.NotoMedium26!, setColor: .black900)
    lazy var subLabel = viewModel.labelUI(setTitle: "간편 하게 시작하기", setFont: UIFont.NotoRegular16!, setColor: .black400)
    
    lazy var findPassButton : UIButton = {
        let bt = UIButton()
        bt.setTitle("비밀번호 찾기", for: .normal)
        bt.titleLabel?.font = UIFont.NotoRegular16
        bt.setTitleColor(.black400, for: .normal)
        
        return bt
    }()
    
    lazy var sv = UIView()
    
    lazy var signUpButton : UIButton = {
        let bt = UIButton()
        bt.setTitle("회원가입", for: .normal)
        bt.titleLabel?.font = UIFont.NotoRegular16
        bt.setTitleColor(.black400, for: .normal)
        return bt
    }()
    var titleLabel = "회원가입"
    var emailButtonTitle = "이메일로 시작하기"
    let termsIdArray : Array<String>
    
    init(termsIdArray : Array<String>) {
        self.termsIdArray = termsIdArray
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

        
        let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
        
        //googleButtonTest.style = .iconOnly
        NotificationCenter.default.post(name: NSNotification.Name("dismissView"), object: nil)
    }
    
    func configureUI() {
        view.addSubview(mainView)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        mainView.center(inView: view)
        mainView.setDimensions(width: view.frame.width - 32, height: 400)
        emailBUtton.addTarget(self, action: #selector(handleEmailButton), for: .touchUpInside)
        
        if titleLabel == "회원가입" {
            findPassButton.isHidden = true
            signUpButton.isHidden = true
            sv.isHidden = true
        }
        
        findPassButton.addTarget(self, action: #selector(handleFindPass), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        naverButton.addTarget(self, action: #selector(handleNaverLogin), for: .touchUpInside)
        kakaoButton.addTarget(self, action: #selector(handleKakaoLogin), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        appleButton.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
        

    }
    
    func requestSNSConnect(type: String,snsToken : String, Success: @escaping(JSON) -> ()) {
        
        Request.shared.postSNSUserLogin(type: type, snsToken: snsToken) { json in
            Success(json)
        }
        
        
    }
    @objc func handleAppleLogin() {

            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        
        
    }
    @objc private func handleNaverLogin(_ sender: UIButton) {
        
        loginInstance?.delegate = self
        loginInstance?.requestThirdPartyLogin()
                
    }
    
    @objc func handleKakaoLogin() {
//        let controller = MainTC()
//
//        UserDefaults.standard.removeObject(forKey: "userId")
//        UserDefaults.standard.setValue(json["userId"].stringValue, forKey: "userId")
//        UIApplication.shared.windows.first?.rootViewController = controller
//        UIApplication.shared.windows.first?.makeKeyAndVisible()

        if (AuthApi.isKakaoTalkLoginAvailable()) {
            AuthApi.shared.loginWithKakaoTalk { [self](oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    
                    guard let accessToken = oauthToken?.accessToken else {
                        return
                    }
                    print("loginWithKakaoTalk() success.")
                    print("토큰은? \(accessToken)")
                    requestSNSConnect(type: "K", snsToken: accessToken) { json in
                        print(json)
                    }
                    //do something
                   
                }
            }
        }
    }
    
    @objc func handleGoogleLogin() {
       // loginInstance?.requestDeleteToken()

//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
//        GIDSignIn.sharedInstance().signIn()
       
    }
    
    
    
    
    @objc func handleFindPass() {
        dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name("dismissView"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("pushSignUp"), object: nil)
        }
    }
    
    @objc func handleSignUp() {
        
        weak var pvc = self.presentingViewController
        
        self.dismiss(animated: true, completion: {
            let vc = PrivateAuthVC()
            vc.modalPresentationStyle = .overCurrentContext
            pvc?.present(vc, animated: true, completion: nil)
        })
        
        
    }
    
    
    
    @objc func handleEmailButton() {
        switch emailButtonTitle {
        case "이메일로 시작하기":
            dismiss(animated: true) {
                NotificationCenter.default.post(name: NSNotification.Name("dismissView"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("pushSignUp"), object: self.termsIdArray)
            }
            
        case "이메일로 로그인하기":
            dismiss(animated: true) {
                NotificationCenter.default.post(name: NSNotification.Name("pushLogin"), object: nil)
            }
        default:
            break
        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        dismiss(animated: true, completion: nil)
    }
    
    private func getNaverInfo() {
      guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
      
      if !isValidAccessToken {
        return
      }
      
      guard let tokenType = loginInstance?.tokenType else { return }
      guard let accessToken = loginInstance?.accessToken else { return }
        
        guard let refreshToken = loginInstance?.refreshToken else { return }
      let urlStr = "https://openapi.naver.com/v1/nid/me"
        requestSNSConnect(type: "N", snsToken: accessToken) { json in
            print(json)
        }

    }

}


extension AuthPopUpViewController: ASAuthorizationControllerPresentationContextProviding,ASAuthorizationControllerDelegate {
    
    // For present window
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }

    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Get user data with Apple ID credentitial
            let userId = appleIDCredential.user
            let userFirstName = appleIDCredential.fullName?.givenName
            let userLastName = appleIDCredential.fullName?.familyName
            let userEmail = appleIDCredential.email
            print("User ID: \(userId)")
            print("User First Name: \(userFirstName ?? "")")
            print("User Last Name: \(userLastName ?? "")")
            print("User Email: \(userEmail ?? "")")
            // Write your code here
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Get user data using an existing iCloud Keychain credential
            let appleUsername = passwordCredential.user
            let applePassword = passwordCredential.password
            // Write your code here
        }
    }
    
}

extension AuthPopUpViewController: NaverThirdPartyLoginConnectionDelegate {
  // 로그인 버튼을 눌렀을 경우 열게 될 브라우저
  func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
//     let naverSignInVC = NLoginThirdPartyOAuth20InAppBrowserViewController(request: request)!
//     naverSignInVC.parentOrientation = UIInterfaceOrientation(rawValue: UIDevice.current.orientation.rawValue)!
//     present(naverSignInVC, animated: false, completion: nil)
    
    // UPDATE: 2019. 10. 11 (금)
    // UIWebView가 제거되면서 NLoginThirdPartyOAuth20InAppBrowserViewController가 있는 헤더가 삭제되었습니다.
    // 해당 코드 없이도 로그인 화면이 잘 열리는 것을 확인했습니다.
  }
  
  // 로그인에 성공했을 경우 호출
  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    print("[Success] : Success Naver Login")
    getNaverInfo()
  }
  
  // 접근 토큰 갱신
  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    
  }
  
  // 로그아웃 할 경우 호출(토큰 삭제)
  func oauth20ConnectionDidFinishDeleteToken() {
    loginInstance?.requestDeleteToken()
  }
  
  // 모든 Error
  func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
    print("[Error] :", error.localizedDescription)
  }
}

extension AuthPopUpViewController : GIDSignInDelegate
{
    
    // 연동을 시도 했을때 불러오는 메소드
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
            
        // 사용자 정보 가져오기
        if let userId = user.userID,                  // For client-side use only!
            let idToken = user.authentication.idToken, // Safe to send to the server
            let fullName = user.profile.name,
            let givenName = user.profile.givenName,
            let familyName = user.profile.familyName,
            let email = user.profile.email {
            
            print("Token : \(idToken)")
            print("User ID : \(userId)")
            print("User Email : \(email)")
            print("User Name : \((fullName))")
     
        } else {
            print("Error : User Data Not Found")
        }
    }
        
    // 구글 로그인 연동 해제했을때 불러오는 메소드
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Disconnect")
    }
    
}
