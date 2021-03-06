//
//  TinderLikeViewController.swift
//  Layouts
//
//  Created by Krzysztof Kapitan on 01.05.2017.
//  Copyright © 2017 CappSoft. All rights reserved.
//

import UIKit
import Kingfisher

final class TinderViewController: UIViewController, UICollectionViewDataSource {
    
    fileprivate let collectionViewLayout: TinderLayout = {
        let layout = TinderLayout()
        
        return layout
    }()
    
    fileprivate var items: [TinderItem] = {
        return (1...16).map { _ in .random() }
    }()
    
    fileprivate var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.registerClass(TinderCell.self)
        
        collectionView.dataSource = self
        collectionView.backgroundColor = .alzarin
        
        collectionViewLayout.delegate = self
        
        view.addSubview(collectionView)
        LayoutBuilder().pin(collectionView, to: view)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = items[indexPath.row]
        let cell: TinderCell = collectionView.dequeue(for: indexPath)
        
        let resource = ImageResource(downloadURL: item.imageURL, cacheKey: "Cell-\(indexPath.row)-\(indexPath.section)")
        
        cell.nameLabel.text = item.title
        cell.pictureImageView.kf.setImage(with: resource)
        
        cell.acceptButton.addTarget(self, action: #selector(acceptAction), for: .touchUpInside)
        cell.declineButton.addTarget(self, action: #selector(declineAction), for: .touchUpInside)
        
        return cell
    }
    
    func acceptAction() {
        collectionViewLayout.move(.right)
    }
    
    func declineAction() {
        collectionViewLayout.move(.left)
    }
}

extension TinderViewController: TinderLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, didMoveItem at: IndexPath, to: TinderLayout.Direction) {
        items.remove(at: at.row)
        collectionView.deleteItems(at: [at])
    }
}
