//
//  PrivateAuthControllerViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/11/24.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class PrivateAuthVC: UIViewController {
    
    let mainView = PrivateAuthView()
    let viewModel = TermsViewModel()
    var termsModel = [TermsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callRequest()
        configureUI()
        
    }
    
    func configureUI() {
        
        view.addSubview(mainView)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        mainView.backgroundColor = .white
        mainView.center(inView: view)
        mainView.anchor(left:view.leftAnchor,right: view.rightAnchor,paddingLeft:16 ,paddingRight: 16,height: 400)
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.separatorStyle = .none
        mainView.tableView.register(PrivateAuthCell.self, forCellReuseIdentifier: "PrivateAuthCell")
        mainView.tableView.allowsSelection = false
        mainView.allAgreeButton.addTarget(self, action: #selector(handleAllButton), for: .touchUpInside)
        mainView.confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
    }
    
    func callRequest() {
        Request.shared.getTerms { json in
            
            
            for item in json.array! {
                let termsItem = TermsModel(required: item["required"].stringValue, contents: item["contents"].stringValue, title: item["title"].stringValue, termsId: item["termsId"].stringValue)
                
                self.termsModel.append(termsItem)
                
            }
            
            self.viewModel.termsCountArray = Array<String>(repeating: "", count: self.termsModel.count)
            
            self.mainView.tableView.reloadData()
            
            
        }
    }
    
    @objc func handleChceckBox(sender : UIButton) {
        
        
        
        if viewModel.termsCountArray.contains(termsModel[sender.tag].termsId) {
            viewModel.termsCountArray.remove(at: sender.tag)
            viewModel.termsCountArray.insert("", at: sender.tag)
        } else {
            viewModel.termsCountArray.remove(at: sender.tag)
            viewModel.termsCountArray.insert(termsModel[sender.tag].termsId, at: sender.tag)
           
            print("어레이는? \(viewModel.termsCountArray)")
            if !viewModel.termsCountArray.contains(""){
                viewModel.allAuthValid = false
                mainView.allAgreeButton.setImage(viewModel.allButtonCliecked(), for: .normal)
                mainView.confirmButton.backgroundColor = viewModel.allButtonConfirmButton()
                mainView.confirmButton.isEnabled = viewModel.allButtonConfirmButtonIsEnable()
            }
        }
        
        
        
        mainView.tableView.reloadData()
        
    }
    
    @objc func handleDetail(sender : UIButton) {
        let realController = AuthDetailTableViewController()
        let controller = UINavigationController(rootViewController: realController)
        controller.modalPresentationStyle = .fullScreen
        realController.contentLabel = termsModel[sender.tag].contents
        realController.navTitle = termsModel[sender.tag].title
        realController.id = termsModel[sender.tag].termsId
        present(controller, animated:false, completion: nil)
    }
    
    @objc func handleAllButton(sender : UIButton) {
        
        sender.setImage(viewModel.allButtonCliecked(), for: .normal)
        
        mainView.confirmButton.backgroundColor = viewModel.allButtonConfirmButton()
        mainView.confirmButton.isEnabled = viewModel.allButtonConfirmButtonIsEnable()
        viewModel.termsCountArrayValid(termsModel: termsModel, count: termsModel.count)
        

        
        
        mainView.tableView.reloadData()
        
    }
    
    @objc func handleConfirm() {
        
        print("결과는? \(viewModel.termsCountArray)")
        
        weak var pvc = self.presentingViewController
        
        self.dismiss(animated: true, completion: {
            let vc = AuthPopUpViewController(termsIdArray: self.viewModel.termsCountArray)
            vc.modalPresentationStyle = .overCurrentContext
            pvc?.present(vc, animated: true, completion: nil)
        })
        
        
    }
    
    
    
    
}



extension PrivateAuthVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return termsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivateAuthCell", for: indexPath) as! PrivateAuthCell
        
        let item = termsModel[indexPath.row]
        
        cell.checkBoxButton.addTarget(self, action: #selector(handleChceckBox), for: .touchUpInside)
        cell.detailButton.addTarget(self, action: #selector(handleDetail), for: .touchUpInside)
        
        
        
        cell.detailButton.tag = indexPath.row
        cell.checkBoxButton.tag = indexPath.row
        cell.mainLabel.text = item.title
        
        
        if viewModel.allAuthValid {
            
            cell.checkBoxButton.setImage(UIImage(named: "list_check_active"), for: .normal)
        } else {
            
            cell.checkBoxButton.setImage(UIImage(named: "list_check_inactive"), for: .normal)
        }
        
        
        
        if viewModel.termsCountArray.contains(item.termsId) && !viewModel.allAuthValid {
            cell.checkBoxButton.setImage(UIImage(named: "list_check_active"), for: .normal)
        } 
        


        
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    
    
    
    
}
