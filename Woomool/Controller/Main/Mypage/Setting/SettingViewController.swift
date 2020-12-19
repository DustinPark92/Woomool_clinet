//
//  SettingViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
import NaverThirdPartyLogin
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn

private let reuseIdentifier = "SettingTableViewCell"

class SettingViewController: UITableViewController {
    
    let headerViewRequestInfo = SettingHeaderView()
    let headerViewMarketing = SettingHeaderView()
    let headerViewAccount = SettingHeaderView()
    let headerViewRequestCustomer = SettingHeaderView()
    
    let viewModel = SettingViewModel()
    
    var userLogintype = ""
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTV()
        configureUI()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = false
        addNavbackButton(selector: #selector(handleDismiss))
        title = "설정"
    }
    
    func configureTV()  {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.isDirectionalLockEnabled = false
        tableView.isSpringLoaded = false
        tableView.showsVerticalScrollIndicator = false
        
        
        
    }
    
    func delUserInfo() {
        

        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "")
        
        let controller = OnBoardingViewController()
        let nav = UINavigationController(rootViewController: controller)
        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()


    }
    
    func snsTypesLogOut() {
        switch userLogintype {
        case "A":
            print("Apple")
            self.delUserInfo()
        case "G":
            print("google")
            self.delUserInfo()
        case "K":
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("logout() success.")
                    self.delUserInfo()
                }
            }
        case "N":
         loginInstance?.requestDeleteToken()
            self.delUserInfo()
        default:
            self.delUserInfo()
        }
        
        
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return viewModel.userRequest.count
        case 1:
            return viewModel.clauseInfo.count
        case 2:
            return viewModel.marketingInfo.count
        case 3:
            return viewModel.accountSetting.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingTableViewCell
        
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            cell.mainLabel.text = viewModel.userRequest[indexPath.row]
        case 1:
            cell.mainLabel.text = viewModel.clauseInfo[indexPath.row]
        case 2:
            cell.mainLabel.text = viewModel.marketingInfo[indexPath.row]
            cell.toggleSwitch.isHidden = false
        case 3:
            cell.mainLabel.text = viewModel.accountSetting[indexPath.row]
            if indexPath.row == 0 {
                cell.versionLabel.isHidden = false
            }
        default:
            break
        }
        
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            headerViewRequestCustomer.mainLabel.text = "문의하기"
            headerViewRequestCustomer.mainImage.image = UIImage(named: "setting_service")
            return headerViewRequestCustomer
        case 1:
            headerViewRequestInfo.mainLabel.text = "약관정보"
            headerViewRequestInfo.mainImage.image = UIImage(named: "setting_paper")
            return headerViewRequestInfo
        case 2:
            headerViewMarketing.mainLabel.text = "마케팅 정보 수신 설정"
            headerViewMarketing.mainImage.image = UIImage(named: "setting_bell")
            return headerViewMarketing
        case 3:
            headerViewAccount.mainLabel.text = "계정 설정"
            headerViewAccount.mainImage.image = UIImage(named: "setting_my")
            return headerViewAccount
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 48
        }
        return 62
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            
                let controller = UserRequestViewController()
                navigationController?.pushViewController(controller, animated: true)
        case 1:
            print("약관 정보")
        case 2:
            print("이메일 정보 수신 설정")
        case 3:
            if indexPath.row == 0 {

            } else if indexPath.row == 1 {
                let controller = CustomAlertViewController2(beforeType: twoAlertContent.init(rawValue: 0)!.rawValue)
                controller.modalPresentationStyle = .overCurrentContext
                present(controller, animated: true, completion: nil)
                
                self.snsTypesLogOut()
                

            } else if indexPath.row == 2 {
                
                let controller = UserDelViewController()
                navigationController?.pushViewController(controller, animated: true)
                
                
//                let controller = CustomAlertViewController2(beforeType: twoAlertContent.init(rawValue: 1)!.rawValue)
//                controller.modalPresentationStyle = .overCurrentContext
//                present(controller, animated: true, completion: nil)
//
//                APIRequest.shared.delUser { json in
//                    self.snsTypesLogOut()
//                }
            }
        default:
            break
        }
        
    }
    




}





extension SettingViewController: ASAuthorizationControllerPresentationContextProviding,ASAuthorizationControllerDelegate {
    
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
     
    }
    
}
}

extension SettingViewController: NaverThirdPartyLoginConnectionDelegate {
  // 로그인 버튼을 눌렀을 경우 열게 될 브라우저
  func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {

  }
  
  // 로그인에 성공했을 경우 호출
  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    print("[Success] : Success Naver Login")
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


extension SettingViewController : GIDSignInDelegate {
    
    // 연동을 시도 했을때 불러오는 메소드
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

    }
        
    // 구글 로그인 연동 해제했을때 불러오는 메소드
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Disconnect")
    }
    
}


