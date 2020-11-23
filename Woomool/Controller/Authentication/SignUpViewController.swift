//
//  SignUpViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/08/26.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdetifier = "SignUpTableViewCell"


class SignUpViewController: UITableViewController {
    
    let color = UIColor()
    let ViewModel = SignUpViewModel()
    var testCode = "Woomool"
    var SendButton: UIButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
    var viewUpSize = 1
    
    lazy var headerView : UIView = {
        let uv = UIView()
        return uv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTV()
        configureUI()
    }
    
    
    func configureUI() {
        UIView.animate(withDuration: 1, animations: {
            self.SendButton.frame = CGRect(x: 0, y: -340, width: self.view.frame.width, height: 50)
        })
        SendButton.backgroundColor = UIColor.blue500
        SendButton.setTitle("다음", for: .normal)
        SendButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = color.mainWhite
        view.backgroundColor = color.mainWhite
        tableView.backgroundColor = color.mainWhite
        title = "회원가입"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "left_arrow"), style: .plain, target: self, action: #selector(handledismiss))
        
        navigationItem.leftBarButtonItem?.tintColor = .black900
        
        
    }
    
    func addKeyboardToolbar(tf: UITextField)  {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 56))
        
        button.backgroundColor = UIColor.blue500
        button.setTitle("다음", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        tf.inputAccessoryView = button
        
    }
    
    func configureTV() {
        tableView.keyboardDismissMode = .onDrag
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        tableView.tableHeaderView = headerView
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(SignUpTableViewCell.self, forCellReuseIdentifier: reuseIdetifier)
        
    }
    
    func callRequest() {
        let params : [String : Any] =
            [
                "email": ViewModel.textFieldContents[0],
                "inviteCd": "",
                "nickname": ViewModel.textFieldContents[3],
                "password": ViewModel.textFieldContents[2],
                "terms":
                    [
                        ["status": "Y",
                         "termsId": "TM20201110233345997"]
                        ,["status": "Y",
                          "termsId": "TM20201110233345998"]
                        ,["status": "Y",
                          "termsId": "TM20201110233345999"]
                    ]
                
            ]
        Request.shared.postUserSignUp(parameters: params) { json in
            let params = ["grant_type": "password",
                          "scope" : "read+write",
                          "username" : self.ViewModel.textFieldContents[0],
                          "password" : self.ViewModel.textFieldContents[1]]

            
            
            
            Request.shared.postUserToken(parameters: params) { json in
                print(json)

                        let controller = MainTC()
                        UIApplication.shared.windows.first?.rootViewController = controller
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                
                
            }
        }
        
    }
    
    func validCheckWithButton(listInsert : String , placeHolderInsert: String , textFieldSecureList : Bool,count : Int , newMessage : String) {
        ViewModel.subjectList.insert(listInsert, at: 0)
        ViewModel.placeholderList.insert(placeHolderInsert, at: 0)
        ViewModel.textFieldSecure.insert(textFieldSecureList, at: 0)
        
        ViewModel.warningMessage.insert(newMessage, at: 0)
        ViewModel.warningColor.insert(.blue, at: 0)
        ViewModel.invalidMessage.insert("", at: 0)
        
        for item in 1...count {
            ViewModel.invalidMessage[item] = ""
        }
        
        
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .bottom)
        tableView.reloadData()
    }
    
    func inValidMessage(invalid:String,subject:String,at:Int) {
        ViewModel.invalidMessage.remove(at: at)
        ViewModel.subjectList.remove(at: at)
        ViewModel.invalidMessage.insert(invalid, at: at)
        ViewModel.subjectList.insert(subject, at: at)
        tableView.reloadData()
    }
    
    func svColorChanged(range: Int) {
        
        ViewModel.svBackgroundColor.remove(at: range)
        ViewModel.svBackgroundColor.insert(.blue500, at: range)
        
        for i in 0...4 {
            if i != range {
                ViewModel.svBackgroundColor.remove(at: i)
                ViewModel.svBackgroundColor.insert(.gray300, at: i)
            }
        }
        let index = IndexPath(row: range, section: 0)
        tableView.reloadRows(at: [index], with: .none)
        
    }
    
    
    @objc func keyboardWillShow(_ sender: Notification) {
        
        self.view.frame.origin.y = -CGFloat(viewUpSize) // Move view 150 points upward
        
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        
        self.view.frame.origin.y = 0 // Move view to original position
        
    }
    
    @objc func handledismiss() {
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func handleNext() {
        
        switch ViewModel.subjectList.count {
        case 1:
            if ViewModel.emailValid {
                validCheckWithButton(listInsert: "비밀번호", placeHolderInsert: "영문과 숫자로 이루어진 6~12가지 조합", textFieldSecureList: true,count: 1,newMessage: "")
                ViewModel.subjectList.remove(at: 1)
                ViewModel.subjectList.insert("이메일", at: 1)
                print(ViewModel.invalidMessage)
                print(ViewModel.subjectList)
            } else {
                _ = !ViewModel.emailValid ? inValidMessage(invalid: "유요하지 않은 이메일 형식입니다.", subject: "", at: 0) : inValidMessage(invalid: "", subject: "이메일", at: 0)
            }
        case 2:
            if  ViewModel.passValid && ViewModel.emailValid{
                validCheckWithButton(listInsert: "비밀번호 확인", placeHolderInsert: "영문과 숫자로 이루어진 6~12가지 조합", textFieldSecureList: true,count: 2,newMessage: "")
                ViewModel.subjectList.remove(at: 1)
                ViewModel.subjectList.insert("비밀번호", at: 1)
                ViewModel.subjectList.remove(at: 2)
                ViewModel.subjectList.insert("이메일", at: 2)
            } else {
                
                _ = !ViewModel.emailValid ? inValidMessage(invalid: "유요하지 않은 이메일 형식입니다.", subject: "", at: 1) : inValidMessage(invalid: "", subject: "이메일", at: 1)
                _ = !ViewModel.passValid ? inValidMessage(invalid: "유요하지 않은 비밀번호", subject: "", at: 0) : inValidMessage(invalid: "", subject: "비밀번호", at: 0)
            }
        case 3:
            if  ViewModel.passCheckValid && ViewModel.emailValid && ViewModel.passValid{
                validCheckWithButton(listInsert: "닉네임", placeHolderInsert: "부적절한 단어는 사용에 제한을 받습니다.", textFieldSecureList: false,count: 3,newMessage: "8자 미만")
                ViewModel.subjectList.remove(at: 1)
                ViewModel.subjectList.insert("비밀번호 확인", at: 1)
                ViewModel.subjectList.remove(at: 2)
                ViewModel.subjectList.insert("비밀번호", at: 2)
                ViewModel.subjectList.remove(at: 3)
                ViewModel.subjectList.insert("이메일", at: 3)
            } else {
                _ = !ViewModel.emailValid ? inValidMessage(invalid: "유요하지 않은 이메일 형식입니다.", subject: "", at: 2) : inValidMessage(invalid: "", subject: "이메일", at: 2)
                _ = !ViewModel.passValid ? inValidMessage(invalid: "유요하지 않은 비밀번호", subject: "", at: 1) : inValidMessage(invalid: "", subject: "비밀번호", at: 1)
                _ = !ViewModel.passCheckValid ? inValidMessage(invalid: "비밀번호가 맞지 않습니다.", subject: "", at: 0) : inValidMessage(invalid: "", subject: "비밀번호 확인", at: 0)
            }
            
        case 4:
            if  ViewModel.nickNameValid && ViewModel.passCheckValid && ViewModel.emailValid && ViewModel.passValid{
                validCheckWithButton(listInsert: "초대코드", placeHolderInsert: "초대코드", textFieldSecureList: false,count: 4,newMessage: "유효한 초대코드를 입력해 주세요."
                )
                ViewModel.subjectList.remove(at: 1)
                ViewModel.subjectList.insert("닉네임", at: 1)
                ViewModel.subjectList.remove(at: 2)
                ViewModel.subjectList.insert("비밀번호 확인", at: 2)
                ViewModel.subjectList.remove(at: 3)
                ViewModel.subjectList.insert("비밀번호", at: 3)
                ViewModel.subjectList.remove(at: 4)
                ViewModel.subjectList.insert("이메일", at: 4)
                SendButton.setTitle("본인 인증 하러 가기", for: .normal)
            } else {
                
                
                _ = !ViewModel.emailValid ? inValidMessage(invalid: "유요하지 않은 이메일 형식입니다.", subject: "", at: 3) : inValidMessage(invalid: "", subject: "이메일", at: 3)
                _ = !ViewModel.passValid ? inValidMessage(invalid: "유요하지 않은 비밀번호", subject: "", at: 2) : inValidMessage(invalid: "", subject: "비밀번호", at: 2)
                _ = !ViewModel.passCheckValid ? inValidMessage(invalid: "비밀번호가 맞지 않습니다.", subject: "", at: 1) : inValidMessage(invalid: "", subject: "비밀번호 확인", at: 1)
                _ = !ViewModel.nickNameValid ? inValidMessage(invalid: "유효하지 않은 닉네임", subject: "", at: 0) : inValidMessage(invalid: "", subject: "닉네임", at: 0)
            }
            
        case 5:
            if  ViewModel.nickNameValid && ViewModel.passCheckValid && ViewModel.emailValid && ViewModel.passValid {
                callRequest()
                
                
            } else {
                
                _ = !ViewModel.emailValid ? inValidMessage(invalid: "유요하지 않은 이메일 형식입니다.", subject: "", at: 4) : inValidMessage(invalid: "", subject: "이메일", at: 4)
                _ = !ViewModel.passValid ? inValidMessage(invalid: "유요하지 않은 비밀번호", subject: "", at: 3) : inValidMessage(invalid: "", subject: "비밀번호", at: 3)
                _ = !ViewModel.passCheckValid ? inValidMessage(invalid: "비밀번호가 맞지 않습니다.", subject: "", at: 2) : inValidMessage(invalid: "", subject: "비밀번호 확인", at: 2)
                _ = !ViewModel.nickNameValid ? inValidMessage(invalid: "유효하지 않은 닉네임", subject: "", at: 1) : inValidMessage(invalid: "", subject: "닉네임", at: 1)
            }
            
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewModel.subjectList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdetifier, for: indexPath) as! SignUpTableViewCell
        
        
        
        cell.backgroundColor = color.mainWhite
        cell.mainLabel.text = ViewModel.subjectList[indexPath.row]
        cell.mainLabelInvalid.text = ViewModel.invalidMessage[indexPath.row]
        cell.TextField.placeholder = ViewModel.placeholderList[indexPath.row]
        cell.TextField.isSecureTextEntry = ViewModel.textFieldSecure[indexPath.row]
        cell.TextField.delegate = self
        cell.bottomLabel.text = ViewModel.warningMessage[indexPath.row]
        cell.bottomLabel.textColor = ViewModel.warningColor[indexPath.row]
        cell.sv.backgroundColor = ViewModel.svBackgroundColor[indexPath.row]
        cell.TextField.tag = indexPath.row
        if cell.TextField.text == "" {
            cell.TextField.becomeFirstResponder()
            
        }
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    
    
}



extension SignUpViewController : UITextFieldDelegate  {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        
        switch textField.tag {
        case 0:
            ViewModel.validwithSwitch(tag: 0, text: text, testCode: testCode)
        case 1:
            ViewModel.validwithSwitch(tag: 1, text: text, testCode: testCode)
        case 2:
            ViewModel.validwithSwitch(tag: 2, text: text, testCode: testCode)
        case 3:
            ViewModel.validwithSwitch(tag: 3, text: text, testCode: testCode)
        case 4:
            ViewModel.validwithSwitch(tag: 4, text: text, testCode: testCode)
        default:
            break
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.inputAccessoryView = self.SendButton
        
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            viewUpSize = 0
            if ViewModel.subjectList.count == 5 {
                SendButton.setTitle("본인 인증 하러 가기", for: .normal)
            } else {
                SendButton.setTitle("확인", for: .normal)
            }
        case 1:
            viewUpSize = 50
            SendButton.setTitle("확인", for: .normal)
        case 2:
            viewUpSize = 50
            SendButton.setTitle("확인", for: .normal)
        case 3:
            viewUpSize = 50
            SendButton.setTitle("확인", for: .normal)
        case 4:
            viewUpSize = 50
            SendButton.setTitle("확인", for: .normal)
        default:
            break
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        return true
    }
}




