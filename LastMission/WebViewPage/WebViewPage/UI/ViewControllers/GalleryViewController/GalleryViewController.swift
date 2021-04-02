//
//  GalleryViewController.swift
//  WebViewPage
//
//  Created by 김기현 on 2021/03/31.
//

import UIKit

class GalleryViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var defaultURL: String = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var items: [DataModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        items = appDelegate.galleryData
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("items: \(items)")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.invalidateLayout()
        }
    }
}

extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as? GalleryCollectionViewCell else {
            print("RETURN")
            return UICollectionViewCell()
        }
        
        guard let baseURL = items[indexPath.row].defaultURL,
              let query = items[indexPath.row].url else {
            fatalError("URL is nil")
        }
        
        print("BaseURL: \(baseURL)")
        print("query: \(query)")
        
        guard let url = URL(string: baseURL + query) else {
            fatalError("URL is nil222")
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.thumbnailImageView.image = image
                }
            }
        }
        
        return cell
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.orientation.isLandscape {
            return collectionView.getCellSize(numberOFItemsRowAt: 4)
        } else {
            return collectionView.getCellSize(numberOFItemsRowAt: 4)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5, left: 8, bottom: 5, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension UICollectionView {
    func getCellSize(numberOFItemsRowAt: Int) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        
        let cellWidth =  screenWidth / CGFloat(numberOFItemsRowAt)
        let cellHeight = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
