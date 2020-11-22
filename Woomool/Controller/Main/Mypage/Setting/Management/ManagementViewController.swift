//
//  ManagementViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/06.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ManagementTableViewCell"

class ManagementViewController: UIViewController {
    
    let headerView = ManagementHeaderView()
    let tableView = UITableView()
    var storeFindModel = [StoreFindModel]()

    override func viewDidLoad() {
        super.viewDidLoad()



        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        title = "수질관리 요청"
        tableView.register(ManagementTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        view.addSubview(headerView)
        
        headerView.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,right: view.rightAnchor,width: view.frame.width,height: 176)
        headerView.textField.delegate = self
        tableView.anchor(top:headerView.bottomAnchor,left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor)

        
        addNavbackButton(selector: #selector(handleDismiss))
        tableView.tableFooterView = UIView()

        
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ManagementViewController : UITableViewDelegate,UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeFindModel.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ManagementTableViewCell
        let item = storeFindModel[indexPath.row]
        cell.selectionStyle = .none
        cell.cafeNameLabel.text = item.name
        cell.cafeAdressLabel.text = item.address
        
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = storeFindModel[indexPath.row]
        let controller = ManagementWrtieViewController()
        controller.cafeName = item.name
        controller.cafeAddress = item.address
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    
}





extension ManagementViewController : UITextFieldDelegate {
    
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        storeFindModel.removeAll()
        
        guard let text = textField.text else { return }
        
//        Request.shared.getFindStoreList(inputStoreName: text) { json in
//
//            for item in json.array! {
//                let storeFindItem = StoreFindModel(storeId: item["storeId"].stringValue, name: item["name"].stringValue, address: item["address"].stringValue)
//
//
//                self.storeFindModel.append(storeFindItem)
//            }
//
//            self.tableView.reloadData()
//
//        }


    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.headerView.searchContainerView.alpha = 0.5
        } completion: { _ in
            self.headerView.searchContainerView.alpha = 1.0
            self.headerView.cancelButton.isHidden = false
        }

        
        storeFindModel.removeAll()
        self.tableView.reloadData()

    }
    
}
