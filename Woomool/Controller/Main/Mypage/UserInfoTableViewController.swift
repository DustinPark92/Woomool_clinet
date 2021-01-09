//
//  UserInfoTableViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/03.
//  Copyright © 2020 Woomool. All rights reserved.
//




import UIKit

private let reuseIdentifier = "UserInfoTableViewCell"

class UserInfoTableViewController: UITableViewController {
    
    let userPrivacyModel = UserPrivacy()
    
    var userPrivacyDateArr : Array<String> = []
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationController?.navigationBar.isHidden = false
        title = "회원정보"
        tableView.register(UserInfoTableViewCell.self, forCellReuseIdentifier: "UserInfoTableViewCell")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "left_arrow"), style: .plain, target: self, action: #selector(handledismiss))
              
              navigationItem.leftBarButtonItem?.tintColor = .black900

    }
    
    func settingUserPrivacySex(sex : String) -> String {
        switch sex {
        case "M":
            return "남성"
        case "F":
            return "여성"
        default:
            return "성별을 확인 할 수 없습니다."
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userPrivacyDateArr.removeAll()
        
        APIRequest.shared.getUserPrivacy { json in
            
            self.userPrivacyDateArr.append(json["name"].stringValue)
            self.userPrivacyDateArr.append(json["birth"].stringValue)
            self.userPrivacyDateArr.append(self.settingUserPrivacySex(sex: json["sex"].stringValue))
            self.userPrivacyDateArr.append(json["email"].stringValue)
            self.userPrivacyDateArr.append(json["nickname"].stringValue)
            self.userPrivacyDateArr.append("비밀 번호 변경")
            
            self.tableView.reloadData()
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
        }
        tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: - objc
    
    @objc func handledismiss() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return userPrivacyDateArr.count
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        as! UserInfoTableViewCell
        
        cell.selectionStyle = .none
        let option = userInfoType(rawValue: indexPath.row)
         
        cell.option = option
        cell.textField.text = userPrivacyDateArr[indexPath.row]
        cell.textField.textColor = .black400
        
        if indexPath.row > 3 {
            cell.editButton.isHidden = false
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 4:
            let controller = ChagneNicknameViewController()
            navigationController?.pushViewController(controller, animated: true)
        case 5:
            let controller = ChangePasswordViewController()
            navigationController?.pushViewController(controller, animated: true)
        default:
            break;
        }
    }
    
    


}
