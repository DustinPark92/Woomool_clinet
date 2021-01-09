//
//  UserDelViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/12/05.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class UserDelViewController: UIViewController {
    
    let headerView : UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        let mainLabel = UILabel()
        view.addSubview(mainLabel)
        mainLabel.text = "회원 탈퇴 시, 개인정보 및 적립 쿠폰과 남은 이용권 등의 혜택 정보가 모두 삭제됩니다. 추후 재 가입 하여도 해당 정보는 복구 되지 않습니다."
        mainLabel.textAlignment = .center
        mainLabel.textColor = .black400
        mainLabel.anchor(top:view.topAnchor,left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingTop: 16,paddingLeft: 16,paddingBottom: 16,paddingRight: 16)
        mainLabel.numberOfLines = 0
        return view
    }()
    
    
    let mainLabel : UILabel = {
        let lb = UILabel()
        lb.text = "탈퇴 사유"
        lb.textColor = .black
        lb.font = UIFont.NotoBold16
        
        return lb
    }()
    
    let textView : UITextView = {
        let tv = UITextView()
        tv.text = "탈퇴 사유를 입력해주세요."
        tv.textColor = .black400
        tv.makeAborderWidth(border: 1, color: UIColor.black400.cgColor)
        tv.makeAborder(radius: 4)
        return tv
    }()
    
    let sendButton : UIButton = {
        let bt = UIButton()
        bt.setTitle("탈퇴하기", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.backgroundColor = .blue500
        return bt
    }()
    
    let tableView = UITableView()
    
    var deleteUserReason = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addNavbackButton(selector: #selector(handleDismiss))
        title = "회원 탈퇴"
        view.addSubview(headerView)
        headerView.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,right: view.rightAnchor,width: view.frame.width,height: 102)
        
        view.addSubview(mainLabel)
        mainLabel.anchor(top:headerView.bottomAnchor,left: view.leftAnchor,paddingTop: 22,paddingLeft: 16)
        
        view.addSubview(tableView)
        tableView.anchor(top:mainLabel.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 20,height: 160)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UserDelReasonCell.self, forCellReuseIdentifier: "UserDelReasonCell")
        
        view.addSubview(textView)
        textView.anchor(top:tableView.bottomAnchor,left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingTop: 12,paddingLeft: 16,paddingBottom: 120,paddingRight: 16)
        
        
        view.addSubview(sendButton)
        sendButton.anchor(left:view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,width: view.frame.width,height: 56)
        sendButton.isHidden = true
        sendButton.addTarget(self, action: #selector(handleDeleteUser), for: .touchUpInside)
        
        textView.isEditable = false
        textView.delegate = self
       
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        
        self.view.frame.origin.y = -CGFloat(300) //
        
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        
        self.view.frame.origin.y = 0 // Move view to original position
        
    }
    
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleDeleteUser() {
        let controller = CustomAlertViewController2(beforeType: twoAlertContent.init(rawValue: 1)!.rawValue)
        controller.modalPresentationStyle = .overCurrentContext
        if textView.text != "탈퇴 사유를 입력해주세요." {
            controller.deleteUserReason = textView.text
        } else {
            controller.deleteUserReason = deleteUserReason
            
        }
        
        present(controller, animated: true, completion: nil)
        
    }


}

extension UserDelViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDelReason.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDelReasonCell", for: indexPath) as! UserDelReasonCell
        let option = userDelReason(rawValue: indexPath.row)
        cell.option = option
        cell.selectionStyle = .none

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            switch indexPath.row {
            case 0,1,2 :
                self.deleteUserReason = userDelReason.init(rawValue: indexPath.row)!.description
                sendButton.isHidden = false
                textView.isEditable = false
            case 3:
                sendButton.isHidden = false
                textView.isEditable = true
            default:
                break
            }
            
        
    }
    
    
    
}


extension UserDelViewController {

    // usually i can use this code to remove keyboard if we touch other area
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }

}



extension UserDelViewController : UITextViewDelegate {
    
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let text = textView.text else {
            return
        }

    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
              
        
        if textView.textColor == UIColor.black400 {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.text = nil
            textView.textColor = UIColor.black
           
            textView.text = nil
            textView.textColor = UIColor.black
            textView.text = nil
            textView.textColor = UIColor.black
           
           
        }
   
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "탈퇴 사유를 입력해주세요."
            textView.textColor = UIColor.black400
            
           
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            
            return true
        
    }
    
    
}
