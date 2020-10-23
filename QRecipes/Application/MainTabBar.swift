//
//  MainTabBar.swift
//  QRecipes
//
//  Created by Kyo on 9/14/20.
//  Copyright © 2020 Kyo. All rights reserved.
//

import UIKit
import Firebase

class MainTabBar: UITabBarController {
    static let shared = MainTabBar()
    let qrButton = AuthenticationVM().logoView(logoSize: 60)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureUI()
    }
    
    // MARK: - configures
    func configureTabBar() {
        tabBar.barTintColor = .white
        tabBar.tintColor = .orange

        let homeTab = barTabView(view: HomeVC(), image: "home")
        let searchTab = barTabView(view: SearchVC(), image: "search")
        let middleTab = QRSacnVC()
        let favoriteTab = barTabView(view: FavoriteVC(), image: "favorite")
        let settingTab = barTabView(view: SettingVC(), image: "setting")
        
        viewControllers = [homeTab, searchTab, middleTab, favoriteTab, settingTab]
        tabBar.items?[2].isEnabled = false
    }
    
    func configureUI() {
        view.addSubview(qrButton)
        qrButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentQRScanVC)))
        qrButton.isUserInteractionEnabled = true
        qrButton.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }

    // MARK:- Helper
    func barTabView(view: UIViewController, image: String, width: CGFloat = 30, height: CGFloat = 30) -> UINavigationController {
        let tabView = UINavigationController(rootViewController: view)
        tabView.tabBarItem.image = UIImage(named: image)?.scaledDown(into: CGSize(width: width, height: height))
        tabView.navigationBar.isHidden = true
        return tabView
    }
    
    // MARK:- Selector
    @objc func presentQRScanVC() {
        let qrScanVC = QRSacnVC()
        qrScanVC.modalPresentationStyle = .popover
        present(qrScanVC, animated: true, completion: nil)
    }
    
    @objc func presentRestaurantOverviewVC() {
        let vc = RecipeInfoViewVC(isInPurchaseFlow: true)
        navigationController?.pushViewController(vc, animated: true)
    }
}
