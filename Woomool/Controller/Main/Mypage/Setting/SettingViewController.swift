//
//  SettingViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SettingTableViewCell"

class SettingViewController: UITableViewController {
    
    let headerViewRequestInfo = SettingHeaderView()
    let headerViewMarketing = SettingHeaderView()
    let headerViewAccount = SettingHeaderView()
    let headerViewRequestCustomer = SettingHeaderView()
    
    let viewModel = SettingViewModel()
    

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
        let controller = OnBoardingViewController()
        
        UIApplication.shared.windows.first?.rootViewController = controller
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "")
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
            return 1
        case 1:
            return 3
        case 2:
            return 3
        case 3:
            return 3
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingTableViewCell
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
                delUserInfo()
                

            } else if indexPath.row == 2 {
                Request.shared.delUser { json in
                   

                    self.delUserInfo()
                } refreshSuccess: {
                    Request.shared.delUser { json in
       
                        self.delUserInfo()
                    } refreshSuccess: {
                        print("nil")
                    }
                }
            }
        default:
            break
        }
        
    }
    




}
