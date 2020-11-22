//
//  PhoneAuthViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/14.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class PhoneAuthViewController: UITableViewController {
    
    var SendButton: UIButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
    
    var submitButton: UIButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
    
    var cellCount = 1
    
    var userCountry = "내국인"
    var wireAgency = "KT"
    
    
    var secondIdentifierTextField = UITextField()
    var firstIdentifierTextField = UITextField()
    var nameTextField = UITextField()
    var phoneNumberTextField = UITextField()
    var phoneAuthNumberTextField = UITextField()
    
    let viewModel = PhoneAuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        
    }
    
    
    func configureUI() {
        title = "본인 인증"
        addNavbackButton(selector: #selector(handleDismiss))
        tableView.register(PhoneAuthAgreeTableViewCell.self, forCellReuseIdentifier: "PhoneAuthAgreeTableViewCell")
        tableView.register(PhoneAuthNameTableViewCell.self, forCellReuseIdentifier: "PhoneAuthNameTableViewCell")
        tableView.register(PhoneUserIdentifierTableViewCell.self, forCellReuseIdentifier: "PhoneUserIdentifierTableViewCell")
        tableView.register(PhoneAuthCellPhoneInfoTableViewCell.self, forCellReuseIdentifier: "PhoneAuthCellPhoneInfoTableViewCell")
        tableView.register(PhoneAuthNumberTableViewCell.self, forCellReuseIdentifier: "PhoneAuthNumberTableViewCell")
        UIView.animate(withDuration: 1, animations: {
            self.SendButton.frame = CGRect(x: 0, y: -340, width: self.view.frame.width, height: 50)
        })
        SendButton.backgroundColor = UIColor.blue500
        SendButton.setTitle("다음", for: .normal)
        SendButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    
    @objc func handleDismiss() {
        
        
    }
    
    @objc func handleNext() {
        cellCount += 1
        
        if cellCount == 2 {
            nameTextField.resignFirstResponder()
            
        } else if cellCount == 3 {
            SendButton.isHidden = true
            secondIdentifierTextField.resignFirstResponder()
        }
        
        
        let indexPath = IndexPath(row: 0, section: 1)
        tableView.insertRows(at: [indexPath], with: .bottom)
        tableView.reloadRows(at: [indexPath], with: .none)
        
        
    }
    
    @objc func handleSelectCountry() {
        let alert = UIAlertController(title: nil, message:  nil, preferredStyle: .actionSheet)
        
        //2. 얼럿 버튼 생성 ( 클릭 버튼)
        let korean = UIAlertAction(title: "내국인", style: .default) { _ in
            self.userCountry = "내국인"
            let indexPath = IndexPath(row: self.cellCount - 1, section: 1)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        let foreingner = UIAlertAction(title: "외국인", style: .default) { _ in
            self.userCountry = "외국인"
            let indexPath = IndexPath(row: self.cellCount - 1, section: 1)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        let cancel =  UIAlertAction(title: "취소", style: .cancel, handler: nil )
        
        //3. 1 + 2
        alert.addAction(korean)
        alert.addAction(foreingner)
        alert.addAction(cancel)
        
        //4. 사용자에게 보여주기
        present(alert, animated: true , completion: nil)
    }
    
    @objc func handleWireAgency() {
        
        let alert = UIAlertController(title: nil, message:  nil, preferredStyle: .actionSheet)
        
        //2. 얼럿 버튼 생성 ( 클릭 버튼)
        let KT = UIAlertAction(title: "KT", style: .default) { _ in
            self.wireAgency = "KT"
            let indexPath = IndexPath(row: self.cellCount - 3, section: 1)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        let SKT = UIAlertAction(title: "SKT", style: .default) { _ in
            self.wireAgency = "SKT"
            let indexPath = IndexPath(row: self.cellCount - 3, section: 1)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        let LGU = UIAlertAction(title: "LG U+", style: .default) { _ in
            self.wireAgency = "LG U+"
            let indexPath = IndexPath(row: self.cellCount - 3, section: 1)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        let extra = UIAlertAction(title: "알뜰폰", style: .default) { _ in
            self.wireAgency = "알뜰폰"
            let indexPath = IndexPath(row: self.cellCount - 3, section: 1)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        let cancel =  UIAlertAction(title: "취소", style: .cancel, handler: nil )
        
        //3. 1 + 2
        alert.addAction(KT)
        alert.addAction(SKT)
        alert.addAction(LGU)
        alert.addAction(extra)
        alert.addAction(cancel)
        
        //4. 사용자에게 보여주기
        present(alert, animated: true , completion: nil)
        
        
    }
    
    @objc func handleAuth() {
        if cellCount == 3 {
            cellCount = 4
            phoneNumberTextField.resignFirstResponder()
            viewModel.phoneAuthSend = true
            
            UIView.animate(withDuration: 1, animations: {
                self.submitButton.frame = CGRect(x: 0, y: -340, width: self.view.frame.width, height: 50)
            })
            submitButton.backgroundColor = UIColor.blue500
            submitButton.setTitle("회원가입 완료", for: .normal)
            submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
            
            let indexPath = IndexPath(row: 0, section: 1)
            let indexPath2 = IndexPath(row: cellCount - 3, section: 1)
            tableView.insertRows(at: [indexPath], with: .bottom)
            tableView.reloadRows(at: [indexPath,indexPath2], with: .none)
        } else {
            print("재발송")
        }
        
    }
    
    @objc func handleSubmit() {
        let controller = MainTC()
        UIApplication.shared.windows.first?.rootViewController = controller
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return cellCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneAuthAgreeTableViewCell", for: indexPath) as! PhoneAuthAgreeTableViewCell
            return cell
        case 1:
            switch indexPath.row {
            case cellCount - 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneAuthNameTableViewCell", for: indexPath) as! PhoneAuthNameTableViewCell
                cell.nameTextField.delegate = self
                cell.selectButton.addTarget(self, action: #selector(handleSelectCountry), for: .touchUpInside)
                cell.countryLabel.text = userCountry
                nameTextField.delegate = self
                nameTextField = cell.nameTextField
                if cellCount == 1 {
                    nameTextField.becomeFirstResponder()
                }
                return cell
                
            case cellCount - 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneUserIdentifierTableViewCell", for: indexPath) as! PhoneUserIdentifierTableViewCell
                cell.firstIdetifierTextField.delegate = self
                cell.secondIdentifierTextField.delegate = self
                cell.firstIdetifierTextField.tag = 2
                cell.secondIdentifierTextField.tag = 3
                secondIdentifierTextField = cell.secondIdentifierTextField
                firstIdentifierTextField = cell.firstIdetifierTextField
                secondIdentifierTextField.delegate = self
                firstIdentifierTextField.delegate = self
                firstIdentifierTextField.becomeFirstResponder()
                
                
                return cell
            case cellCount - 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneAuthCellPhoneInfoTableViewCell", for: indexPath) as! PhoneAuthCellPhoneInfoTableViewCell
                cell.selectButton.addTarget(self, action: #selector(handleWireAgency), for: .touchUpInside)
                cell.phoneAuthButton.addTarget(self, action: #selector(handleAuth), for: .touchUpInside)
                cell.wireAgencyLabel.text = wireAgency
                cell.PhoneNumberTextField.delegate = self
                cell.PhoneNumberTextField.tag = 4
                
                phoneNumberTextField = cell.PhoneNumberTextField
                if cellCount == 3 {
                    phoneNumberTextField.becomeFirstResponder()
                }
                
                if viewModel.phoneAuthSend {
                    cell.phoneAuthButton.setTitle("재발송", for: .normal)
                    cell.phoneAuthButton.setTitleColor(.blue500, for: .normal)
                    cell.phoneAuthButton.makeAborderWidth(border: 1, color: UIColor.blue500.cgColor)
                    cell.phoneAuthButton.backgroundColor = .white
                }
                
                return cell
                
            case cellCount - 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneAuthNumberTableViewCell", for: indexPath) as! PhoneAuthNumberTableViewCell
                phoneAuthNumberTextField = cell.phoneAuthNumberTextField
                
                cell.phoneAuthNumberTextField.delegate = self
                
                cell.phoneAuthNumberTextField.tag = 5
                phoneAuthNumberTextField.delegate = self
                phoneAuthNumberTextField.becomeFirstResponder()
                return cell
            default:
                break
            }
            
            
            
        default:
            break;
        }
        
        
        return UITableViewCell()
        
    }
    
    
    
}


extension PhoneAuthViewController : UITextFieldDelegate {
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        switch textField.tag {
        case 1:
            print(text)
        case 2:
            if ((textField.text?.count)! == 6){
                if textField == firstIdentifierTextField {
                    secondIdentifierTextField.becomeFirstResponder()
                }
            }
        case 3:
            if ((textField.text?.count)! == 0){
                if textField == secondIdentifierTextField {
                    firstIdentifierTextField.becomeFirstResponder()
                }
            }
            
        default:
            break
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // On inputing value to textfield
        
        
        
        return true
        
    }
    
    
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 5 {
            textField.inputAccessoryView = self.submitButton
        } else {
            textField.inputAccessoryView = self.SendButton
        }
    }
    
    
    
}
