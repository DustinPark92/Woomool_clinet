//
//  FindPassViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/11/13.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdetifier = "SignUpTableViewCell"

class FindPassViewController: UITableViewController {

    let color = UIColor()
    let ViewModel = SignUpViewModel()
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
        SendButton.setTitle("이메일 재설정 링크 보내기", for: .normal)
        SendButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = color.mainWhite
        tabBarController?.tabBar.isHidden = true
        
        view.backgroundColor = color.mainWhite
        tableView.backgroundColor = color.mainWhite
        title = "비밀 번호 찾기"
        ViewModel.subjectList.remove(at: 0)
        ViewModel.subjectList.insert("이메일", at: 0)
        ViewModel.placeholderList.remove(at: 0)
        ViewModel.placeholderList.insert("회원가입했던 이메일을 입력해주세요.", at: 0)
        addNavbackButton(selector: #selector(handledismiss))
        
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
    
    func inValidMessage(invalid:String,subject:String,at:Int) {
        ViewModel.invalidMessage.remove(at: at)
        ViewModel.subjectList.remove(at: at)
        ViewModel.invalidMessage.insert(invalid, at: at)
        ViewModel.subjectList.insert(subject, at: at)
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
               
                APIRequest.shared.getFindUserPassword(email: ViewModel.textFieldContents[0]) { json in
                    print(json)
                } fail: { error in
                    self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                        
                    }
                }

                
            } else {
            _ = !ViewModel.emailValid ? inValidMessage(invalid: "유효하지 않은 이메일", subject: "", at: 0) : inValidMessage(invalid: "", subject: "이메일", at: 0)
                
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
        cell.mainLabelInvalid.text = ViewModel.invalidMessage[indexPath.row]
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



extension FindPassViewController : UITextFieldDelegate  {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.isValidEmailAddress(email: text) {
            ViewModel.emailValid = true
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.inputAccessoryView = self.SendButton
        
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        return true
    }
}
