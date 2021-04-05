//
//  GalleryViewController.swift
//  WebViewPage
//
//  Created by 김기현 on 2021/03/31.
//

import UIKit
import AVFoundation

class GalleryViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var defaultURL: String = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var items: [DataModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        items = appDelegate.galleryData
        
        self.title = "Gallery"
        
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

// MARK: - UICollectionViewDelegate
extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let viewController = storyboard?.instantiateViewController(identifier: "ContentPageViewController") as? ContentPageViewController else { return }
        viewController.items = self.items
        viewController.currentIndex = indexPath.row
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as? GalleryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let baseURL = items[indexPath.row].defaultURL,
              let query = items[indexPath.row].url,
              let type = items[indexPath.row].type else {
            fatalError("The Data is nil")
        }
        
        guard let url = URL(string: baseURL + query) else {
            fatalError("URL is nil")
        }
        
        DispatchQueue.global().async {
            if type == "image" {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.thumbnailImageView.image = image
                    }
                }
            } else {
                let asset = AVURLAsset(url: url)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                do {
                    let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                    let uiImage = UIImage(cgImage: cgImage)
                    
                    DispatchQueue.main.async {
                        cell.thumbnailImageView.image = uiImage
                    }
                } catch(let error) {
                    print("ERROR: \(error)")
                }
                
            }
            
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.getCellSize(numberOfItemsRowAt: 3)
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
    func getCellSize(numberOfItemsRowAt: Int) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        
        let cellWidth =  screenWidth / CGFloat(numberOfItemsRowAt + 1)
        let cellHeight = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
