//
//  ManagementWrtieViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/12.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIentifier = "ManagementTableViewCell"
private let writeCell = "ManagementWriteTableViewCell"

class ManagementWrtieViewController: UIViewController {
    
    let viewModel = ManagementViewModel()
    
    var SendButton: UIButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
    
    var cafeName = ""
    var cafeAddress = ""
    var storeId = ""
    var contents = ""

    
    let mainLabel : UILabel = {
        let lb = UILabel()
        lb.text = "더 나은 우물 서비스 이용을 위해 수질 관리 요청을 받고 있습니다. \n 모든 내용은 익명으로 처리됩니다."
        lb.font = UIFont.NotoMedium12
        lb.textColor = .black400
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    let sepeartorView : UIView = {
        let uv = UIView()
        uv.backgroundColor = .gray300
        return uv
    }()
    

    
    let tableView = UITableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(popWoomoolManagement(noti:)), name: NSNotification.Name("popWoomoolManagement"), object: nil)
       
    }
    
    @objc func popWoomoolManagement(noti : NSNotification) {
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: UserRequestViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
      }
    
    
    func configureUI() {
        title = "수질관리 요청"
        view.addSubview(mainLabel)
        
        view.backgroundColor = .white
        mainLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 24)
        view.addSubview(sepeartorView)
        sepeartorView.anchor(top:mainLabel.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 24,width: view.frame.width,height: 1)
        
        
        view.addSubview(tableView)
        tableView.anchor(top:sepeartorView.bottomAnchor,left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor)

        addNavbackButton(selector: #selector(handleDismiss))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ManagementTableViewCell.self, forCellReuseIdentifier: reuseIentifier)
        tableView.register(ManagementWriteTableViewCell.self, forCellReuseIdentifier: writeCell)
        
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
    
    @objc func handleNext() {
        LoadingHUD.show()
        APIRequest.shared.postStoreComplain(storeId: storeId, contents: contents) { json in
            print(json)
            LoadingHUD.hide()
            let controller = CustomAlertViewController(beforeType: singleAlertContent.woomoolManagement.rawValue)
            controller.modalPresentationStyle = .overCurrentContext
            self.present(controller, animated: true, completion: nil)
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
        }

        
    }
}

extension ManagementWrtieViewController : UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIentifier, for: indexPath) as! ManagementTableViewCell
            cell.selectionStyle = .none
            cell.cafeNameLabel.text = cafeName
            cell.cafeAdressLabel.text = cafeAddress
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: writeCell, for: indexPath) as! ManagementWriteTableViewCell
        cell.textView.delegate = self
        cell.textView.text = "선택하신 우물의 이용경험을 들려주세요."
        cell.textView.textColor = .black400
        cell.textView.inputAccessoryView = SendButton
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        return view.frame.height - 96
        
    }
    

    

    
    
    
}

extension ManagementWrtieViewController : UITextViewDelegate {
    
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let text = textView.text else {
            return
        }
        
        contents = text
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
            textView.text = "선택하신 우물의 이용경험을 들려주세요."
            textView.textColor = UIColor.black400
            
           
        }
    }
    
    
}
