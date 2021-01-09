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
            self.SendButton.frame = CGRect(x: 0, y: -340, width: self.view.frame.width, height: 50)
        })
        SendButton.backgroundColor = UIColor.blue500
        SendButton.setTitle("다음", for: .normal)
        SendButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        
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
    
    func validCheckWithButton(listInsert : String , placeHolderInsert: String , textFieldSecureList : Bool) {
        ViewModel.subjectList.insert(listInsert, at: 0)
        ViewModel.placeholderList.insert(placeHolderInsert, at: 0)
        ViewModel.textFieldSecure.insert(textFieldSecureList, at: 0)
        
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .bottom)
        tableView.reloadData()
    }
    
    func inValidMessage(message:String,color : UIColor,at:Int) {
        
        ViewModel.warningMessage.insert(message, at: at)
        ViewModel.warningColor.insert(color, at: at)
        tableView.reloadData()
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        
        self.view.frame.origin.y = -CGFloat(viewUpSize) // Move view 150 points upward
        
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        
        self.view.frame.origin.y = 0 // Move view to original position
        
    }
    
    
    
    @objc func handleNext() {
        
        switch ViewModel.subjectList.count {
        case 1:
            if ViewModel.emailValid {
                validCheckWithButton(listInsert: "비밀번호", placeHolderInsert: "영문과 숫자로 이루어진 6~12가지 조합", textFieldSecureList: true)
                ViewModel.warningMessage.insert("", at: 0)
                ViewModel.warningColor.insert(.blue, at: 0)
                SendButton.setTitle("로그인", for: .normal)
                
            } else {
                _ = !ViewModel.emailValid ? inValidMessage(message: "유요하지 않은 이메일 형식입니다.", color: .red, at: 0) : inValidMessage(message: "", color: .blue, at: 0)
                
            }
        case 2:
            let params = ["grant_type": "password",
                          "scope" : "read+write",
                          "username" : ViewModel.textFieldContents[0],
                          "password" : ViewModel.textFieldContents[1]]
            
            
            APIRequest.shared.postUserToken(parameters: params) { json in
                print(json)
  
                let params = [
                    "email": self.ViewModel.textFieldContents[0],
                    "password": self.ViewModel.textFieldContents[1]
                    
                ]
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                    
                    APIRequest.shared.postUserLogin(parameters: params) { json in
                        print(json)
                        let controller = MainTC()
                        
                        UserDefaults.standard.removeObject(forKey: "userId")
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
        cell.TextField.placeholder = ViewModel.placeholderList[indexPath.row]
        cell.TextField.isSecureTextEntry = ViewModel.textFieldSecure[indexPath.row]
        cell.TextField.delegate = self
        cell.bottomLabel.text = ViewModel.warningMessage[indexPath.row]
        cell.bottomLabel.textColor = ViewModel.warningColor[indexPath.row]
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
            ViewModel.validwithSwitch(tag: 0, text: text, testCode: testCode)
        case 1:
            ViewModel.validwithSwitch(tag: 1, text: text, testCode: testCode)
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
