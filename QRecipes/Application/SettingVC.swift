//  SettingVC.swift
//  QRecipes

//  Created by kyo on 9/14/20.
//  Copyright © 2020 Kyo. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import Firebase

class SettingVC: UIViewController,UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    let tableView = UITableView()
    let containerView = UIView()
    
    let columns: CGFloat = 3.0
    let inset: CGFloat = 8.0
    
    var purchasedRecipes = [Recipe]() {
        didSet {
            collectionView.reloadData()
        }
    }

    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "avatar")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    let messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "envelope").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleService), for: .touchUpInside)
        return button
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "logout-512").withRenderingMode(.alwaysOriginal), for: .normal)
        //button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Dan Zhao"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "zhaodan618@gmail.com"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .backgroundGray
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(SettingCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    } ()

    let expirationDayButton: UIButton = {
        let button = UIButton()
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUser()
        fetchPurchasedRecipes()
    }
    
    private func configure() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func configureUI(){
        view.backgroundColor = .orange
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(view.frame.height * 0.35)
        }
        
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(containerView)
            profileImageView.layer.cornerRadius = 100 / 2
        }
        
        view.addSubview(messageButton)
        messageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.height.width.equalTo(32)
            make.left.equalToSuperview().offset(20)
        }
        
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.height.width.equalTo(32)
            make.right.equalToSuperview().offset(-20)
        }
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    func fetchUser() {
        if User.shared.profileImage != nil &&
           User.shared.firstName != "" &&
           User.shared.lastName != "" &&
           User.shared.email != "" {
            profileImageView.sd_setImage(with: User.shared.profileImage, completed: nil)
            nameLabel.text = "\(User.shared.firstName) \(User.shared.lastName)"
            emailLabel.text = User.shared.email
        }
    }
    
    func fetchPurchasedRecipes() {
        API.fetchPurchasedRecipes { recipes in
            self.purchasedRecipes = recipes
        }
    }
    
    @objc func handleService() {
        print("Contact to the customer service here..")
        MainTabBar.shared.tabBarController?.selectedIndex = 0
    }

    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            User.shared.clear()
            DispatchQueue.main.async {
                let navigation = UINavigationController(rootViewController: AuthenticationVC())
                navigation.modalPresentationStyle = .fullScreen
                navigation.navigationBar.isHidden = true
                
                self.present(navigation, animated: false)
            }
        } catch let error {
            print("------failed to sing out \(error.localizedDescription)")
        }
    }

    // Navigation
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Row \(indexPath.row)")
        let vc = RecipeDetailVC()
        vc.recipe = purchasedRecipes[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- Collection view data source
extension SettingVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return purchasedRecipes.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SettingCollectionViewCell
        
        //cell.dayExpireLabel.text = "ExpireDay"
        cell.recipe = purchasedRecipes[indexPath.row]
        return cell
    }
}

//MARK:- Collection view layout
extension SettingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / columns) - (inset*1.5)
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return inset
    }
}
