//
//  PrivateUserInfoAuthViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/04.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

protocol PrivateUserInfoAuthViewControllerDelegate {
    func showSignUpView()
}

class PrivateUserInfoAuthViewController: UIViewController {
    
    var termsModel = [TermsModel]()
    var termsViewModel = TermsViewModel()
    let defaults = UserDefaults.standard
    
    
    let viewModel = SignUpViewModel()
    lazy var allAgreeButton = viewModel.allAgreeButton()
    lazy var serviceButton = viewModel.listButton(setTitle: "ㅇㅁ너리ㅓㅁㄴ아ㅣ러마ㅣㄴㅇ;ㅓㄹㅁ이나;러ㅏㅁㅇㄴ;ㅣㄹ")
    lazy var privateInfoButton = viewModel.listButton()
    lazy var locationButton = viewModel.listButton()
    lazy var marketingButton = viewModel.listButton()
    lazy var emailButton = viewModel.listButton()
    lazy var smsButton = viewModel.listButton()
    lazy var pushButton = viewModel.listButton()
    lazy var serviceDetail = viewModel.attributedButton("보기")
    lazy var privateDetail = viewModel.attributedButton("보기")
    lazy var locationDetail = viewModel.attributedButton("보기")
    lazy var confirmButton = viewModel.buttonUI(setTitle: "동의하기")
    
    lazy var mainView = viewModel.privatePopUpView(allAgreeButton: allAgreeButton, serviceButton: serviceButton, privateInfoButton: privateInfoButton, locationButton: locationButton, marketingButton: marketingButton, emailButton: emailButton, smsButton: smsButton, pushButton: pushButton,serviceDetail: serviceDetail, privateDetail: privateDetail,locationDetail: locationDetail, comfirmButton: confirmButton)
    
    var delegate : PrivateUserInfoAuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callRequest()
        configureUI()
        configureAction()
        NotificationCenter.default.addObserver(self, selector: #selector(dissmissView(noti:)), name: NSNotification.Name("dismissView"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if termsViewModel.termList.count > 0 {
            termsViewModel.serviceAuth ?
                serviceButton.setImage(UIImage(named: "list_check_active"), for: .normal) :
                serviceButton.setImage(UIImage(named: "list_check_inactive"), for: .normal)
            termsViewModel.privacyAuth ?
                privateInfoButton.setImage(UIImage(named: "list_check_active"), for: .normal) :
                privateInfoButton.setImage(UIImage(named: "list_check_inactive"), for: .normal)
            termsViewModel.locationAuth ?
                locationButton.setImage(UIImage(named: "list_check_active"), for: .normal) :
                locationButton.setImage(UIImage(named: "list_check_inactive"), for: .normal)
        }
        
        
        
    }
    
    
    
    
    
    
    func callRequest() {
        Request.shared.getTerms { json in
            
            
            for item in json.array! {
                let termsItem = TermsModel()
                termsItem.title = item["title"].stringValue
                termsItem.contents = item["contents"].stringValue
                termsItem.termsId = item["termsId"].stringValue
                self.defaults.setValue(false, forKey: item["termsId"].stringValue)
                self.termsViewModel.termList.append(termsItem)
                self.termsModel.append(termsItem)
            }
            
            
        }
        print("모델은? \(termsModel)")
        
    }
    
    func configureUI() {
        
        view.addSubview(mainView)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        mainView.center(inView: view)
        mainView.setDimensions(width: view.frame.width - 16, height: 400)
        
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
    }
    
    func configureAction() {
        serviceDetail.addTarget(self, action: #selector(handleServiceDetail), for: .touchUpInside)
        privateDetail.addTarget(self, action: #selector(handlePrivateDetail), for: .touchUpInside)
        locationDetail.addTarget(self, action: #selector(handleLocationDetail), for: .touchUpInside)
        serviceButton.addTarget(self, action: #selector(handleServiceButton), for: .touchUpInside)
        privateInfoButton.addTarget(self, action: #selector(handlePrivacyButton), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(handleLocationButton), for: .touchUpInside)
        allAgreeButton.addTarget(self, action: #selector(handleAllAgreeButton), for: .touchUpInside)
        
    }
    
    @objc func handleConfirm() {
        
        weak var pvc = self.presentingViewController
        
        self.dismiss(animated: true, completion: {
            let vc = AuthPopUpViewController()
            vc.modalPresentationStyle = .overCurrentContext
            pvc?.present(vc, animated: true, completion: nil)
        })
        
        
    }
    
    @objc func dissmissView(noti : NSNotification)  {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleServiceDetail() {
        let realController = AuthDetailTableViewController()
        let controller = UINavigationController(rootViewController: realController)
        controller.modalPresentationStyle = .fullScreen
        realController.contentLabel = termsModel[0].contents
        realController.navTitle = termsModel[0].title
        realController.id = termsModel[0].termsId
        present(controller, animated:false, completion: nil)
    }
    
    @objc func handlePrivateDetail() {
        let realController = AuthDetailTableViewController()
        let controller = UINavigationController(rootViewController: realController)
        controller.modalPresentationStyle = .fullScreen
        realController.contentLabel = termsModel[1].contents
        realController.navTitle = termsModel[1].title
        realController.id = termsModel[1].termsId
        present(controller, animated:false, completion: nil)
    }
    
    @objc func handleLocationDetail() {
        let realController = AuthDetailTableViewController()
        let controller = UINavigationController(rootViewController: realController)
        controller.modalPresentationStyle = .fullScreen
        realController.contentLabel = termsModel[2].contents
        realController.navTitle = termsModel[2].title
        realController.id = termsModel[2].termsId
        present(controller, animated:false, completion: nil)
    }
    
    @objc func handleServiceButton(sender : UIButton) {
        
        if termsViewModel.serviceAuth {
            defaults.setValue(false, forKey: termsModel[0].termsId)
            serviceButton.setImage(UIImage(named: "list_check_inactive"), for: .normal)
        } else {
            defaults.setValue(true, forKey: termsModel[0].termsId)
            serviceButton.setImage(UIImage(named: "list_check_active"), for: .normal)
        }
    }
    
    @objc func handlePrivacyButton(sender : UIButton) {
        if termsViewModel.privacyAuth {
            defaults.setValue(false, forKey: termsModel[1].termsId)
            privateInfoButton.setImage(UIImage(named: "list_check_inactive"), for: .normal)
        } else {
            defaults.setValue(true, forKey: termsModel[1].termsId)
            privateInfoButton.setImage(UIImage(named: "list_check_active"), for: .normal)
        }

    }
    @objc func handleLocationButton(sender : UIButton) {
        if termsViewModel.locationAuth {
            defaults.setValue(false, forKey: termsModel[2].termsId)
            locationButton.setImage(UIImage(named: "list_check_inactive"), for: .normal)
        } else {
            defaults.setValue(true, forKey: termsModel[2].termsId)
            locationButton.setImage(UIImage(named: "list_check_active"), for: .normal)
        }

    }
    
    @objc func handleAllAgreeButton() {
        if !termsViewModel.allAuth {
            allAgreeButton.setImage(UIImage(named: "check_active"), for: .normal)
        } else {
            allAgreeButton.setImage(UIImage(named: "check_inactive"), for: .normal)
        }
        
        
        
    }
    
    
    
    
    
}
