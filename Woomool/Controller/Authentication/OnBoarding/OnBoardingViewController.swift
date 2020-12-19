//
//  OnBoardingViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/08/29.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit


private let reuseIdentifier = "OnBoardingCollectionViewCell"


class OnBoardingViewController: UIViewController {
    

//    private let loginLabel : UILabel = {
//        let lb = UILabel()
//        lb.text = "이미 가입하셨나요?"
//        lb.font = UIFont.NotoRegular16
//        lb.textColor = .black400
//        return lb
//    }()
//
//    private let loginButton : UIButton = OnBoardingModel().attributedButton("로그인 하기")
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.alwaysBounceHorizontal = false
        cv.bounces = false
        layout.scrollDirection = .horizontal
        return cv
    }()
    
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 1
        pc.numberOfPages = ImageModel().onboardingImageList.count // 백엔드에서 동적으로 페이지 갯수 받아오기.
        pc.currentPageIndicatorTintColor = .black
        pc.pageIndicatorTintColor = .lightGray
        pc.isEnabled = false
        return pc
    }()
    
    let startButton : UIButton = OnBoardingModel().buttonUI(setTitle: "시작하기")
    
    let layout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(pushViewPhoneAuth(noti:)), name: NSNotification.Name("pushViewPhoneAuth"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushViewLogin(noti:)), name: NSNotification.Name("pushLogin"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushFindPass(noti:)), name: NSNotification.Name("pushFindPass"), object: nil)
        

        configureUI()
        configureCV()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(startButton)
//        view.addSubview(loginLabel)
//        view.addSubview(loginButton)
        
        startButton.isHidden = true
//        loginButton.isHidden = true
//        loginLabel.isHidden = true
        
        

        collectionView.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: view.frame.height / 13,width: view.frame.width,height: view.frame.height/2.13)
        pageControl.anchor(top:collectionView.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 10,paddingLeft: 37,paddingRight: 38)
        startButton.anchor(top:pageControl.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 46,paddingLeft:37,paddingRight:38)
        
//        loginLabel.centerX(inView: view, topAnchor: loginButton.topAnchor, paddingTop: -20)
//        loginButton.anchor(bottom:view.safeAreaLayoutGuide.bottomAnchor ,paddingBottom: view.frame.height/13)
//        loginButton.centerX(inView: view)
//        loginButton.addTarget(self, action: #selector(handleLoginView), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(handleSignUpView), for: .touchUpInside)
    }
    
    func configureCV() {
        
        collectionView.register(OnBoardingCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
    }
    
    
    
    //MARK: - objc
    
    @objc func handleLoginView() {
        let controller = AuthPopUpViewController(termsIdArray: [])
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .coverVertical
        controller.titleLabel = "로그인"
        controller.emailButtonTitle = "이메일로 로그인하기"
        present(controller, animated: true, completion: nil)

    }
    
    @objc func handleSignUpView() {
        let controller = AuthPopUpViewController(termsIdArray: [])
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .coverVertical
        controller.titleLabel = "로그인"
        controller.emailButtonTitle = "이메일로 로그인하기"
        present(controller, animated: true, completion: nil)
//        let controller = PrivateAuthVC()
//        controller.modalPresentationStyle = .overCurrentContext
//        controller.modalTransitionStyle = .coverVertical
//        present(controller, animated: true, completion: nil)
    }
    
    @objc func pushViewPhoneAuth(noti : NSNotification) {
//        let controller = MainTC()
//        UIApplication.shared.windows.first?.rootViewController = controller
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
//        guard let termsIdArray = noti.object else {
//            return
//        }
        
        let controller = PhoneAuthViewController()
        navigationController?.pushViewController(controller, animated: true)
      }
    
    @objc func pushViewLogin(noti : NSNotification) {
        let controller = LoginViewController()
        navigationController?.pushViewController(controller, animated: true)
      }
    
    
    @objc func pushFindPass(noti : NSNotification) {
        let controller = FindPassViewController()
        present(controller, animated: true, completion: nil)
      }

    
    

    
}

//MARK: - UICollectionViewDelegate, UICollectionviewDataSource

extension OnBoardingViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let page = Int(targetContentOffset.pointee.x / collectionView.frame.width)
        self.pageControl.currentPage = page
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageModel().onboardingImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! OnBoardingCollectionViewCell
        cell.mainLabel.text = OnBoardingModel().onBoardingTitle[indexPath.row]
        cell.onBoardingImgView.image = UIImage(named: ImageModel().onboardingImageList[indexPath.row])
        cell.backgroundColor = .white
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        if indexPath.row == 2 {
            UIView.animate(withDuration: 3.0) {
                self.startButton.isHidden = false
            }
            
        } else {
            startButton.isHidden = true
        }
    }
    
    
    
}

extension OnBoardingViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    
    
}
