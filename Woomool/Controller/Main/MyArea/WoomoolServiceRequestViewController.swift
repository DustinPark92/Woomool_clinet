//
//  WoomoolServiceRequestViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/18.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdentifier = "WoomoolServiceTableViewCell"

class WoomoolServiceRequestViewController: UITableViewController {
    
    let viewModel = MyWoomoolViewModel()
    let defaults = UserDefaults.standard
    
    let headerView = WoomoolServieceHeaderView()
    var SendButton: UIButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
    //woomoolServiceRequest
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()



    }
    

    func configureUI() {
        
        title = "우물 서비스 요청"
        addNavbackButton(selector: #selector(handleDismiss))
        tableView.register(WoomoolServiceTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        view.backgroundColor = .white
        
        
        UIView.animate(withDuration: 1, animations: {
            self.SendButton.frame = CGRect(x: 0, y: -340, width: self.view.frame.width, height: 50)
        })
        SendButton.backgroundColor = UIColor.blue500
        SendButton.setTitle("요청하기", for: .normal)
        SendButton.titleLabel?.font = UIFont.NotoBold18
        SendButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WoomoolService.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! WoomoolServiceTableViewCell
        let option = WoomoolService(rawValue: indexPath.row)
        cell.option = option
        cell.TextField.delegate = self
        cell.TextField.resignFirstResponder()
        cell.TextField.tag = indexPath.row
        cell.isUserInteractionEnabled = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
    @objc func keyboardWillShow(_ sender: Notification) {
        
        self.view.frame.origin.y = -CGFloat(300) //
        
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        
        self.view.frame.origin.y = 0 // Move view to original position
        
    }
    
    @objc func handleNext() {
        
        guard let userId = defaults.object(forKey: "userId") as? String else { return }
        
        let params = [
            "address": viewModel.woomoolServiceTfContents[1],
              "contact": viewModel.woomoolServiceTfContents[2],
              "name": viewModel.woomoolServiceTfContents[0],
              "userId": userId
        ]
        
        Request.shared.postStoreApply(parameters: params) { json in
            self.navigationController?.popViewController(animated: true)
        }
        
    }
 
    
}

extension WoomoolServiceRequestViewController : UITextFieldDelegate {
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        
        switch textField.tag {
        case 0:
            viewModel.woomoolServiceTfContents.insert(text, at: 0)
        case 1:
            viewModel.woomoolServiceTfContents.insert(text, at: 1)
        case 2:
            viewModel.woomoolServiceTfContents.insert(text, at: 2)
            
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
