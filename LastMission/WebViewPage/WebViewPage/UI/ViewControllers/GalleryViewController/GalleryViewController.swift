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
