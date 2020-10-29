//  SettingVC.swift
//  QRecipes

//  Created by kyo on 9/14/20.
//  Copyright © 2020 Kyo. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class SettingVC: UIViewController,UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    let tableView = UITableView()
    
    let columns: CGFloat = 3.0
    let inset: CGFloat = 8.0
    
    lazy var containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .orange
        return view
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image =  #imageLiteral(resourceName: "avatar")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    let messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage( #imageLiteral(resourceName: "envelope").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleService), for: .touchUpInside)
        return button
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage( #imageLiteral(resourceName: "logout-512").withRenderingMode(.alwaysOriginal), for: .normal)
        //button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    //init -> -> -> selecors objc -> values func view didload
    
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
    // MARK: - Lifecycle
//    lazy var dayExpireLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Days"
//        label.textColor = .black
//        label.font = UIFont.boldSystemFont(ofSize: 28)
//        return label
//    }()
    let expirationDayButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureUI()
        fetchUser()
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
            make.top.equalToSuperview().offset(88)
            make.height.equalTo(100)
            make.width.equalTo(100)
            
            make.centerX.equalToSuperview()
            make.centerY.equalTo(containerView)
            
            profileImageView.layer.cornerRadius = 100 / 2
        }
        view.addSubview(messageButton)
        messageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64)
            make.height.equalTo(32)
            make.width.equalTo(32)
            make.left.equalToSuperview().offset(32)
        }
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64)
            make.height.equalTo(32)
            make.width.equalTo(32)
            make.right.equalToSuperview().offset(-32)
        }
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            //make.left.right.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
        }
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(50)
            //make.left.right.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom)
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
    
    @objc func handleService() {
        print("Contact to the customer service here..")
    }

    @objc func handleLogout() {
        print("Logging out..")
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
        
        return 27
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SettingCollectionViewCell
        
        //cell.dayExpireLabel.text = "ExpireDay"
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
