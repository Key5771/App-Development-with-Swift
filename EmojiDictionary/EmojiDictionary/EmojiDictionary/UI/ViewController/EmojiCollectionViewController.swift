//
//  EmojiCollectionViewController.swift
//  EmojiDictionary
//
//  Created by 김기현 on 2021/03/22.
//

import UIKit

class EmojiCollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

extension EmojiCollectionViewController: UICollectionViewDelegate {
    
}

extension EmojiCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EmojiCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = .blue
        
        return cell
    }
}
