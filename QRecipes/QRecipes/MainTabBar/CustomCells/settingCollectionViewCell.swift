//  SettingCollectionViewCell.swift
//  QRecipes
//
//  Created by Dannyyyyyyy Zhao on 10/12/20.
//  Copyright © 2020 Kyo. All rights reserved.
//

import UIKit

class SettingCollectionViewCell: UICollectionViewCell {
    
    var recipe: Recipe? {
        didSet {
            imageView.sd_setImage(with: recipe?.recipeImageUrl, completed: nil)
            updateExpDateLabel()
        }
    }
    

    //MARK:- Properties
    let imageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 8
        img.image = UIImage(named: "pasta")
        return img
    }()
    
//    let dayExpireLabel: UILabel = {
//       let label = UILabel()
//       label.font = UIFont.boldSystemFont(ofSize: 14)
//       label.textColor = .white
//       return label
//   }()
        let expirationDayButton: UIButton = {
           let button = UIButton()
            
            button.backgroundColor = .white
            button.layer.cornerRadius = 10
            button.setTitle("Expiration", for: .normal)
            //button.backgroundColor = .primeOrange
            //button.frame = CGRect(x: 20, y: 20, width: 30, height: 15)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            button.setTitleColor(.primeOrange, for: .normal)
            
            return button
       }()
    
    //MARK:- Init
    override init(frame: CGRect){
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Helper
    private func configureCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 6

        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in

            make.left.right.top.bottom.equalToSuperview()

            
        }
//        contentView.addSubview(dayExpireLabel)
//        dayExpireLabel.snp.makeConstraints { make in
//            //make.top.equalTo(imageView.snp.center).offset(10)
//            make.left.equalTo(contentView).offset(20)
//            make.right.equalTo(contentView).offset(-20)
//            make.centerY.equalTo(imageView)
//            //make.width.height.equalTo(30)
//        }
        contentView.addSubview(expirationDayButton)
                expirationDayButton.snp.makeConstraints { make in
                    //make.top.equalTo(imageView.snp.center).offset(10)
                    
                    make.left.equalTo(contentView).offset(20)
                    make.right.equalTo(contentView).offset(-20)
                    make.centerY.equalTo(imageView)
                    make.width.height.equalTo(30)
                }
    
    }
    
    private func updateExpDateLabel() {
        var date = Date()
        let purchaseds = User.shared.purchased
        for purchased in purchaseds {
            if purchased[0] == recipe?.uid {
                date = Date().stringToDate(String: purchased[1])
            }
        }
        let leftDays = Int(date.timeIntervalSince(Date()) / 86400)
        dayExpireLabel.text = "\(leftDays) days"
    }
}
