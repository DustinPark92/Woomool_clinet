//
//  LoginViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/08/26.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdetifier = "SignUpTableViewCell"




class LoginViewController: UITableViewController {
    
    let color = UIColor()
    let ViewModel = SignUpViewModel()
    var testCode = "Woomool"
    var SendButton: UIButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
    lazy var findPassWithLoginButtonView = Utilites().findPassWithLoginButton(findPassButton: findPassButton, loginButton: loginButton)
    let findPassButton = UIButton()
    let loginButton = UIButton()
    
    
    var viewUpSize = 1
    
    lazy var headerView : UIView = {
        let uv = UIView()
        return uv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));
        
        configureTV()
        configureUI()
        
        
        
        
        
    }
    
    
    func configureUI() {
        UIView.animate(withDuration: 1, animations: {
            self.SendButton.frame = CGRect(x: 0, y: -340, width: self.view.frame.width, height: 56)
        })
        
        UIView.animate(withDuration: 1, animations: {
            self.findPassWithLoginButtonView.frame = CGRect(x: 0, y: -340, width: self.view.frame.width, height: 56)
        })
        SendButton.backgroundColor = UIColor.blue500
        SendButton.setTitle("다음", for: .normal)
        SendButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        
        findPassButton.addTarget(self, action: #selector(handleFindPassButton), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = color.mainWhite
        view.backgroundColor = color.mainWhite
        tableView.backgroundColor = color.mainWhite
        title = "로그인"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "left_arrow"), style: .plain, target: self, action: #selector(handledismiss))
        
        navigationItem.leftBarButtonItem?.tintColor = .black900
        
    }
    

    
    func configureTV() {
        tableView.keyboardDismissMode = .onDrag
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        tableView.tableHeaderView = headerView
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(SignUpTableViewCell.self, forCellReuseIdentifier: reuseIdetifier)
        
        
    }
    
    //MARK: - 다음 버튼 클릭 시에 유효성 검사 성공 시
    func validCheckWithButton(listInsert : String , placeHolderInsert: String , textFieldSecureList : Bool,count : Int , newMessage : String) {
        ViewModel.subjectList.insert(listInsert, at: 0)
        ViewModel.placeholderList.insert(placeHolderInsert, at: 0)
        ViewModel.textFieldSecure.insert(textFieldSecureList, at: 0)
        ViewModel.subjectStarList.insert("*", at: 0)
        
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
    
    
    //MARK: - 다음 버튼 클릭 시에 유효성 검사 실패 시
    func inValidMessage(invalid:String,subject:String,at:Int) {
        ViewModel.invalidMessage.remove(at: at)
        ViewModel.subjectList.remove(at: at)
        ViewModel.subjectStarList.remove(at: at)
        ViewModel.subjectStarList.insert("", at: at)
        ViewModel.invalidMessage.insert(invalid, at: at)
        ViewModel.subjectList.insert(subject, at: at)
        tableView.reloadData()
    }
    
    func inValidMessage(at:Int) {
        
        ViewModel.warningMessage.remove(at: at)
        ViewModel.warningColor.remove(at: at)
        ViewModel.warningMessage.insert("", at: at)
        ViewModel.warningColor.insert(.blue, at: at)
        tableView.reloadData()
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        
        self.view.frame.origin.y = -CGFloat(viewUpSize) // Move view 150 points upward
        
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        
        self.view.frame.origin.y = 0 // Move view to original position
        
    }
    
    @objc func handleFindPassButton() {
        let controller = FindPassViewController()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    //MARK : - 로그인 버튼
    @objc func handleLoginButton() {
        if ViewModel.subjectList.count == 2 {

            
            APIRequest.shared.postUserToken(userInfoArray: ViewModel.textFieldContents) { json in
                print(json)
                
                UserDefaults.standard.setValue(json["access_token"].stringValue, forKey: "accessToken")
                UserDefaults.standard.setValue(json["refresh_token"].stringValue, forKey: "refreshToken")

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                    
                    APIRequest.shared.postUserLogin(userInfoArray : self.ViewModel.textFieldContents) { json in
                        let controller = MainTC()

                        UserDefaults.standard.setValue(json["userId"].stringValue, forKey: "userId")
                        UIApplication.shared.windows.first?.rootViewController = controller
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                    } fail: { error in
                        self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                            
                        }
                    }
                    
                }
                

                
                
            } fail: { error in
                self.showOkAlert(title: error, message: "") {
                    
                }
                
            }
            
            
        }
    }
    
    
    @objc func handleNext() {
        
        switch ViewModel.subjectList.count {

        case 1:
            if ViewModel.emailValid {
                validCheckWithButton(listInsert: "비밀번호", placeHolderInsert: "영문+숫자+특수문자 8~16자리 조합", textFieldSecureList: true,count: 1,newMessage: "")
                ViewModel.subjectList.remove(at: 1)
                ViewModel.subjectList.insert("이메일", at: 1)
                print(ViewModel.invalidMessage)
                print(ViewModel.subjectList)
            } else {
                _ = !ViewModel.emailValid ? inValidMessage(invalid: "유효하지 않은 이메일 형식입니다.", subject: "", at: 0) : inValidMessage(invalid: "", subject: "이메일", at: 0)
            }

        default:
            break
        }
    }
    
    @objc func handledismiss() {
        navigationController?.popViewController(animated: true)
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
        cell.requiredLabel.text = ViewModel.subjectStarList[indexPath.row]
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



extension LoginViewController : UITextFieldDelegate  {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        
        switch textField.tag {
        case 0:
            if ViewModel.emailValid {
                //첫번째 올라왔을때 로그인 버튼을 isEnable = false 하기 위해 체크를 한다.
                if text.count > 0 && ViewModel.passCheckValid {
                    loginButton.isEnabled = true
                    loginButton.backgroundColor = .blue500
                    
                } else {
                    ViewModel.passCheckValid = true
                    loginButton.isEnabled = false
                    loginButton.backgroundColor = .gray300
                }
            }
            ViewModel.validwithSwitch(tag: 0, text: text, testCode: testCode)
        case 1:
            ViewModel.validwithSwitch(tag: 1, text: text, testCode: testCode)
        default:
            break
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if ViewModel.emailValid {
            textField.inputAccessoryView = findPassWithLoginButtonView
        } else {
            textField.inputAccessoryView = self.SendButton
            
        }

    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            if ViewModel.subjectList.count == 2 {
                SendButton.setTitle("로그인", for: .normal)
            }
            viewUpSize = 0
        case 1:
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
