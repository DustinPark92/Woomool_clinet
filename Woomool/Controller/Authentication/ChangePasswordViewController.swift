//
//  ChangePasswordViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdetifier = "SignUpTableViewCell"

class ChangePasswordViewController: UITableViewController {


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
                navigationController?.navigationBar.barTintColor = .white
                tabBarController?.tabBar.isHidden = true
                
                view.backgroundColor = .white
                tableView.backgroundColor = .white
                title = "비밀 번호 변경"
                ViewModel.subjectList.remove(at: 0)
                ViewModel.subjectList.insert("가존 비밀번호", at: 0)
                ViewModel.placeholderList.remove(at: 0)
                ViewModel.placeholderList.insert("기존 비밀번호를 입력해 주세요.", at: 0)
                ViewModel.textFieldSecure.remove(at: 0)
                ViewModel.textFieldSecure.insert(true, at: 0)
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
    
    func validwithSwitch(tag : Int , text : String, testCode : String ) {
        switch ViewModel.subjectList.count {
        case 1 + tag:
            if text.validatePassword(){
                ViewModel.ValidCheck(at: 0, to: text)
                ViewModel.passValid = true
                print("내용은 \(ViewModel.textFieldContents)")
            } else {
                ViewModel.ValidCheck(at: 0, to: "기존 비밀 번호")
                ViewModel.passValid = false
                print("내용은 \(ViewModel.textFieldContents)")
            }
        case 2 + tag:
            if (text.validatePassword()) {
                ViewModel.ValidCheck(at: 1, to: text)
                ViewModel.passValidOneMore = true
                print("내용은 \(ViewModel.textFieldContents)")
            } else {
                ViewModel.ValidCheck(at: 1, to:  " 새비밀번호")
                ViewModel.passValidOneMore = false
               
            }
        case 3 + tag:
            if (text.validatePassword()) && text == ViewModel.textFieldContents[1] {
                ViewModel.ValidCheck(at: 2, to: text)
                ViewModel.passCheckValid = true
           
            } else {
                ViewModel.ValidCheck(at: 2, to: " 새 비밀번호확인")
                ViewModel.passCheckValid = false
                print("내용은 \(ViewModel.textFieldContents)")
            }
       
        default:
            break
        }
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
                    if ViewModel.passValid {
                        validCheckWithButton(listInsert: "새 비밀번호", placeHolderInsert: "영문과 숫자로 이루어진 6~12가지 조합", textFieldSecureList: true,count: 1,newMessage: "")
                        ViewModel.subjectList.remove(at: 1)
                        ViewModel.subjectList.insert("기존 비밀 번호", at: 1)
                    } else {
                        _ = !ViewModel.passValid ? inValidMessage(invalid: "유효하지 않은 비밀 번호", subject: "", at: 0) : inValidMessage(invalid: "", subject: "기존 비밀 번호", at: 0)
                    }
                case 2:
                    if  ViewModel.passValidOneMore && ViewModel.passValid{
                        validCheckWithButton(listInsert: "새 비밀 번호 확인", placeHolderInsert: "영문과 숫자로 이루어진 6~12가지 조합", textFieldSecureList: true,count: 2,newMessage: "")
                        ViewModel.subjectList.remove(at: 1)
                        ViewModel.subjectList.insert("새 비밀 번호", at: 1)
                        ViewModel.subjectList.remove(at: 2)
                        ViewModel.subjectList.insert("기존 비밀 번호", at: 2)
                    } else {
                        
                        _ = !ViewModel.passValid ? inValidMessage(invalid: "유효하지 않은 비밀 번호", subject: "", at: 1) : inValidMessage(invalid: "", subject: "기존 비밀 번호", at: 1)
                        _ = !ViewModel.passValidOneMore ? inValidMessage(invalid: "유요하지 않은 비밀번호", subject: "", at: 0) : inValidMessage(invalid: "", subject: "비밀번호", at: 0)
                    }
                case 3:
                    if  ViewModel.passCheckValid && ViewModel.passValid && ViewModel.passValidOneMore{
                        
                        APIRequest.shared.putChangeUserInfo(newPassword: ViewModel.textFieldContents[1], nickname: "", oldPassword: ViewModel.textFieldContents[0]) { json in
                            print(json)
                        }
                       
             
                    } else {
                        _ = !ViewModel.passValid ? inValidMessage(invalid: "유효하지 않은 비밀 번호", subject: "", at: 2) : inValidMessage(invalid: "", subject: "기존 비밀 번호", at: 2)
                        _ = !ViewModel.passValidOneMore ? inValidMessage(invalid: "유요하지 않은 비밀번호", subject: "", at: 1) : inValidMessage(invalid: "", subject: "비밀번호", at: 1)
                        
                        _ = !ViewModel.passCheckValid ? inValidMessage(invalid: "비밀 번호가 일치하지 않습니다.", subject: "", at: 0) : inValidMessage(invalid: "", subject: "비밀번호", at: 0)
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
                
                
                
                cell.backgroundColor = .white
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



        extension ChangePasswordViewController : UITextFieldDelegate  {
            
            func textFieldDidChangeSelection(_ textField: UITextField) {
                guard let text = textField.text else { return }
                switch textField.tag {
                case 0:
                  validwithSwitch(tag: 0, text: text, testCode: testCode)
                case 1:
                    validwithSwitch(tag: 1, text: text, testCode: testCode)
                case 2:
                    validwithSwitch(tag: 2, text: text, testCode: testCode)
                default:
                    break
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



