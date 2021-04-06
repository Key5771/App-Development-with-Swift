//
//  PhotosViewController.swift
//  Combinestagram
//
//  Created by 김기현 on 2021/03/30.
//

import UIKit
import Photos
import RxSwift

private let reuseIdentifier = "Cell"

class PhotosViewController: UICollectionViewController {
    
    // MARK: - Setting
    private lazy var photos = PhotosViewController.loadPhotos()
    private lazy var imageManager = PHCachingImageManager()
    
    fileprivate let selectedPhotosSubject = PublishSubject<UIImage>()
    var selectedPhotos: Observable<UIImage> {
        return selectedPhotosSubject.asObserver()
    }
    
    let disposeBag = DisposeBag()
    
    private lazy var thumbnailSize: CGSize = {
        let cellSize = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        return CGSize(width: cellSize.width * UIScreen.main.scale,
                      height: cellSize.height * UIScreen.main.scale)
    }()
    
    static func loadPhotos() -> PHFetchResult<PHAsset> {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return PHAsset.fetchAssets(with: allPhotosOptions)
    }
    
    private func errorMessage() {
        alert(title: "No access to Camera Roll",
              text: "You can grant access to Combinestagram from the Settings app")
            .subscribe(onCompleted: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
                _ = self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func alert(title: String, text: String) -> Completable {
        return Completable.create { [weak self] completable in
            let alertViewController = UIAlertController(title: title, message: text, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                completable(.completed)
            }
            
            alertViewController.addAction(okAction)
            self?.present(alertViewController, animated: true, completion: nil)
            
            return Disposables.create()
        }
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authorized = PHPhotoLibrary.authorized.share()  // 사용자의 접근 요청에 대한 결과 값(Observable<Bool>)을 공유하는 변수
        authorized
            .skip(while: { $0 == false })                   // return 값이 false 인 경우 skip
            .take(1)                                        // return 값 하나만 가져오므로 take(1)
            .subscribe { [weak self] _ in
                self?.photos = PhotosViewController.loadPhotos()
                // PHPhotoLibrary+Rx.swift 내의 requestAuthorization(_:)은 completionHandler가 실행될 스레드를 보장하지 않으므로 백그라운드 스레드에 있을 수 있다.
                // 백그라운드 스레드에 있을 경우 UIKit 코드는 충돌을 일으키므로 main 스레드에서 실행해야 한다.
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
            .disposed(by: disposeBag)
        
        authorized
            .skip(1)
            .takeLast(1)
            .filter { $0 == false }
            .subscribe { [weak self] _ in
                guard let errorMessage = self?.errorMessage else { return }
                DispatchQueue.main.async(execute: errorMessage)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        selectedPhotosSubject.onCompleted()
    }
    
    // MARK: - UICollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = photos.object(at: indexPath.item)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil) { (image, _) in
            cell.imageView.image = image
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = photos.object(at: indexPath.item)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            cell.flash()
        }
        
        imageManager.requestImage(for: asset, targetSize: view.frame.size, contentMode: .aspectFill, options: nil) { [weak self] image, info in
            guard let image = image, let info = info else { return }
            if let isThumbnail = info[PHImageResultIsDegradedKey as NSString] as? Bool, !isThumbnail {
                self?.selectedPhotosSubject.onNext(image)
            }
        }
    }
}
