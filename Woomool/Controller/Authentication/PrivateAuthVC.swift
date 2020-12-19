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
    
    
    let termsArray : Array<TermsModel>
    
    init(termsArray : Array<TermsModel>) {
        self.termsArray = termsArray
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
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

            
            self.viewModel.termsCountArray = Array<String>(repeating: "", count: self.termsArray.count)
            
            self.mainView.tableView.reloadData()
            
            
        
    }
    
    @objc func handleChceckBox(sender : UIButton) {
        
        
        
        if viewModel.termsCountArray.contains(termsArray[sender.tag].termsId) {
            viewModel.termsCountArray.remove(at: sender.tag)
            viewModel.termsCountArray.insert("", at: sender.tag)
        } else {
            viewModel.termsCountArray.remove(at: sender.tag)
            viewModel.termsCountArray.insert(termsArray[sender.tag].termsId, at: sender.tag)
           
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
        realController.contentLabel = termsArray[sender.tag].contents
        realController.navTitle = termsArray[sender.tag].title
        realController.id = termsArray[sender.tag].termsId
        present(controller, animated:false, completion: nil)
    }
    
    @objc func handleAllButton(sender : UIButton) {
        
        sender.setImage(viewModel.allButtonCliecked(), for: .normal)
        
        mainView.confirmButton.backgroundColor = viewModel.allButtonConfirmButton()
        mainView.confirmButton.isEnabled = viewModel.allButtonConfirmButtonIsEnable()
        viewModel.termsCountArrayValid(termsModel: termsArray, count: termsArray.count)
        

        
        
        mainView.tableView.reloadData()
        
    }
    
    @objc func handleConfirm() {
        
        APIRequest.shared.postTerms(termsIdArray: viewModel.termsCountArray) { json in
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: NSNotification.Name("privacyAuthAgree"), object: nil)
            }
        }
        

        
        
    }
    
    
    
    
}



extension PrivateAuthVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return termsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivateAuthCell", for: indexPath) as! PrivateAuthCell
        
        let item = termsArray[indexPath.row]
        
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
