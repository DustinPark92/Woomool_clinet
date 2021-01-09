//
//  SocialLoginAdditionalDataVC.swift
//  Woomool
//
//  Created by Dustin on 2021/01/02.
//  Copyright © 2021 Woomool. All rights reserved.
//

import UIKit
import SwiftyJSON

class SocialLoginAdditionalDataVC: UIViewController {
    let viewModel = SocialLoginAddtionalViewModel()
    let tableView = UITableView()
    var SendButton: UIButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
    let json : JSON
    
    init(json : JSON) {
        self.json = json
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        hideKeyboardWhenTappedAround()
        
        print("제이슨은 \(json)")
        
    }
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = false
        addNavbackButton(selector: #selector(handleDismiss))
        title = "회원가입"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SocialLoginAdditionalDataCell.self, forCellReuseIdentifier: "SocialLoginAdditionalDataCell")
        tableView.showsVerticalScrollIndicator = false
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,right: view.rightAnchor)
       
        view.addSubview(SendButton)
        SendButton.anchor(top:tableView.bottomAnchor,left:view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,height: 80)
        SendButton.backgroundColor = UIColor.blue500
        SendButton.setTitle("완료", for: .normal)
        SendButton.titleLabel?.font = UIFont.NotoBold18
        SendButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        
        //이름,생년월일,성별,초대코드
        
        if json["name"].stringValue.count > 2 {
            viewModel.nameValid = true
        }
        if json["birth"].stringValue.count == 8 {
            viewModel.birthValid = true
        }
        if json["sex"].stringValue != "" {
            viewModel.genderValid = true
        }
        
        
        viewModel.addtionalDataContents.remove(at: 0)
        viewModel.addtionalDataContents.insert(json["name"].stringValue, at: 0)
        viewModel.addtionalDataContents.remove(at: 1)
        viewModel.addtionalDataContents.insert(json["birth"].stringValue, at: 1)
        viewModel.addtionalDataContents.remove(at: 2)
        viewModel.addtionalDataContents.insert(json["sex"].stringValue, at: 2)
        
        
        
        
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleNext() {
        viewModel.firstValidBefore = true
        
        
        if viewModel.nameValid && viewModel.genderValid && viewModel.birthValid {
            
            APIRequest.shared.postSNSUserSignUp(transData: json["transData"].stringValue, addtionalDataContents: viewModel.addtionalDataContents) { json in
                
                UserDefaults.standard.setValue(json["access_token"].stringValue, forKey: "accessToken")
                UserDefaults.standard.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")
                UserDefaults.standard.setValue(json["userId"].stringValue, forKey: "userId")
                
                let controller = MainTC()
                controller.selectedIndex = 0
                UIApplication.shared.windows.first?.rootViewController = controller
                UIApplication.shared.windows.first?.makeKeyAndVisible()
                
                
                self.showOkAlert(title: "이름 : \(self.viewModel.addtionalDataContents[0]),생년월일 : \(self.viewModel.addtionalDataContents[1])성별 : \(self.viewModel.addtionalDataContents[2]),초대코드 : \(self.viewModel.addtionalDataContents[3])", message: "") {
 
                }
            } fail: { error in

                self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                        
                }
                
            }

        } else {
            tableView.reloadData()
        }
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        
        self.view.frame.origin.y = -CGFloat(300) //
        
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        
        self.view.frame.origin.y = 0 // Move view to original position
        
    }
    
    @objc func handleGenderButton(sender : UIButton) {
        viewModel.genderName = sender.currentTitle!
        viewModel.genderValid = true
        
        if viewModel.genderName == "남" {
            viewModel.addtionalDataContents.remove(at: 2)
            viewModel.addtionalDataContents.insert("M", at: 2)
        } else {
            viewModel.addtionalDataContents.remove(at: 2)
            viewModel.addtionalDataContents.insert("F", at: 2)
        }

        
        tableView.reloadData()
    }
    

    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }



    

    



}


extension SocialLoginAdditionalDataVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SocialLoginAdditionalDataCell", for: indexPath) as! SocialLoginAdditionalDataCell
        
        cell.birthTextField.delegate = self
        cell.nameTextField.delegate = self
        cell.inviteTextField.delegate = self
        cell.nameTextField.tag = 0
        cell.birthTextField.tag = 1
        cell.inviteTextField.tag = 2
        
        

        
        if json["sex"].stringValue == "M" {
            cell.manButton.setImage(UIImage(named: "activeGender"), for: .normal)
        } else if json["sex"].stringValue == "F" {
            cell.womanButton.setImage(UIImage(named: "activeGender"), for: .normal)
        }
        
        
        cell.manButton.addTarget(self, action: #selector(handleGenderButton), for: .touchUpInside)
        cell.womanButton.addTarget(self, action: #selector(handleGenderButton), for: .touchUpInside)
        
        if viewModel.genderName == "남" {
            cell.manButton.setImage(UIImage(named: "activeGender"), for: .normal)
            cell.womanButton.setImage(UIImage(named: "inactiveGender"), for: .normal)
        } else if viewModel.genderName == "여" {
            cell.womanButton.setImage(UIImage(named: "activeGender"), for: .normal)
            cell.manButton.setImage(UIImage(named: "inactiveGender"), for: .normal)
            
        }
        
        
        if viewModel.firstCommingAddtionalPage {
            cell.nameTextField.text = json["name"].stringValue
            cell.birthTextField.text = json["birth"].stringValue
            viewModel.firstCommingAddtionalPage = false
        }
        

        
        if !viewModel.nameValid && viewModel.firstValidBefore {
            cell.nameWarningLabel.text = "2자 이상의 실명을 입력해주세요."
        } else {
            cell.nameWarningLabel.text = ""
        }
        
        if !viewModel.birthValid && viewModel.firstValidBefore {
            cell.birthWarningLabel.text = "8자리 입력 ex)YYYYMMDD"
        } else {
            cell.birthWarningLabel.text = ""
        }
        
        
        
        
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height - 100
    }
    
    
    
    
    
}


extension SocialLoginAdditionalDataVC : UITextFieldDelegate {
    
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        guard let text = textField.text else {
            return
        }
        
        switch textField.tag {
        case 0:
            if text.count >= 2 {
                viewModel.nameValid = true
                viewModel.addtionalDataContents.remove(at: 0)
                viewModel.addtionalDataContents.insert(text, at: 0)
            } else {
                viewModel.nameValid = false
            }
        case 1:
            if text.count == 8 {
                viewModel.birthValid = true
                viewModel.addtionalDataContents.remove(at: 1)
                viewModel.addtionalDataContents.insert(text, at: 1)
            } else {
                viewModel.birthValid = false
            }
        case 2:
            viewModel.addtionalDataContents.remove(at: 4)
            viewModel.addtionalDataContents.insert(text, at: 4)
        default:
            break
        }
        

        
        
        print("추가 데이터는? \(viewModel.addtionalDataContents)")

        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
 
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
