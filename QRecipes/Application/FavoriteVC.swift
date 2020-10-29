//
//  FavoriteVC.swift
//  QRecipes
//
//  Created by Kyo on 9/14/20.
//  Copyright © 2020 Kyo. All rights reserved.
//

import UIKit
import SnapKit

class FavoriteVC: UIViewController, UIGestureRecognizerDelegate {
    //MARK:- Properties
    let columns: CGFloat = 2.0
    let inset: CGFloat = 15.0

    var favoriteRecipes = [Recipe]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorites"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(FavoriteCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    } ()

    //MARK:- LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureUI()
        fetchFavorites()
    }
    
    //MARK:- Helpers
    private func configure() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view).offset(12)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    private func fetchFavorites() {
        API.fetchFavoriteRecipes{ recipes in
            self.favoriteRecipes = recipes
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("Selected Row \(indexPath.row)")
        let vc = RecipeInfoViewVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // Delete an item from collection view
    @objc func deleteItem(sender: UIButton!) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        self.collectionView.deleteItems(at: [indexPath])
        self.collectionView.reloadData()
    }
}

//MARK:- Collection view data source
extension FavoriteVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FavoriteCell
        
        cell.recipe = favoriteRecipes[indexPath.row]
        //cell.favoriteButton.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        
        return cell
    }
}

//MARK:- Collection view layout
extension FavoriteVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / columns) - (inset*1.5)
        return CGSize(width: width, height: width*1.2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return inset
    }
}
