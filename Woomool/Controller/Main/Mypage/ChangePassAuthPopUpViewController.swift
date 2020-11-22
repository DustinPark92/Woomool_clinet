//
//  ChangePassAuthPopUpViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/09/10.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit

class ChangePassAuthPopUpViewController: UIViewController {
    let viewModel = MypageViewModel()
    lazy var mainView = viewModel.popUpView(centerlabel: centerLabel, confirmButton: confirmButton, cancelButton: cancelButton)
    
    lazy var centerLabel = UILabel()
    lazy var confirmButton = UIButton()
    lazy var cancelButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
       
    }
    
    func configureUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(mainView)
        mainView.center(inView: view)
        mainView.setDimensions(width: view.frame.width - 32, height: view.frame.height / 3)
        cancelButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    @objc func handleConfirm() {
        
    }

}
