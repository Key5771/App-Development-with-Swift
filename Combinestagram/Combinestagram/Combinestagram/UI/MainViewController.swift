//
//  MainViewController.swift
//  Combinestagram
//
//  Created by 김기현 on 2021/03/30.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var itemAdd: UIBarButtonItem!
    
    private let disposeBag = DisposeBag()
    private let images = BehaviorRelay<[UIImage]>(value: [])
    private var imageCache = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        images.asObservable()
            .subscribe(onNext: { [weak self] photos in
                self?.updateUI(photos: photos)
            })
            .disposed(by: disposeBag)

        images
            .subscribe(onNext: { [weak imageView] photos in
                guard let preview = imageView else { return }
                
                preview.image = UIImage.collage(images: photos, size: preview.frame.size)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    private func updateUI(photos: [UIImage]) {
        saveButton.isEnabled = photos.count > 0 && photos.count % 2 == 0
        clearButton.isEnabled = photos.count > 0
        itemAdd.isEnabled = photos.count < 6
        title = photos.count > 0 ? "\(photos.count) photos" : "Collage"
    }

    @IBAction func actionAdd(_ sender: Any) {
//        let newImages = images.value + [UIImage(named: "sunset")!]
//        images.accept(newImages)
        
        guard let photosViewController = storyboard!.instantiateViewController(identifier: "PhotosViewController") as? PhotosViewController else { return }
        
        // share() 기능을 통해 subscribe을 공유할 수 있다.
        let newPhotos = photosViewController.selectedPhotos.share()
        
        newPhotos
            .take(while: { [weak self] image -> Bool in
                let count = self?.images.value.count ?? 0
                return count < 6                                        // 6장의 사진을 추가하면 더 이상 추가할 수 없도록 함. 그 전까지는 모든 입력을 받음.
            })
            .filter { newImage in
                return newImage.size.width > newImage.size.height       // 가로사진만 허용하도록 필터
            }
            .filter { [weak self] newImage in                           // 이미지 중복 저장을 피하기 위해 이미지 데이터의 길이를 바이트 단위로 저장하고 검색
                let len = newImage.pngData()?.count ?? 0
                guard self?.imageCache.contains(len) == false else {
                    return false                                        // imageCache에 동일한 값이 있다면 이미지가 이미 있다고 판단하고 false를 리턴
                }
                
                self?.imageCache.append(len)
                return true                                             // 이미지가 고유한 경우 해당 바이트 길이를 imageCache에 저장하고 true를 리턴
            }
            .subscribe { [weak self] newImage in
                guard let images = self?.images else { return }
                images.accept(images.value + [newImage])
            } onDisposed: {
                print("completed photo selection")
            }
            .disposed(by: disposeBag)
        
        newPhotos
            .ignoreElements()
            .subscribe(onCompleted: { [weak self] in
                self?.updateNavigationIcon()
            })
            .disposed(by: disposeBag)

        
        navigationController?.pushViewController(photosViewController, animated: true)
    }
    
    @IBAction func actionSave(_ sender: Any) {
        guard let image = imageView.image else { return }
        
        PhotoWriter.save(image)
            .asSingle()
            .subscribe { [weak self] (id) in
                self?.showMessage("Saved with ID: \(id)")
                self?.actionClear(sender)
            } onFailure: { [weak self] (error) in
                self?.showMessage("Error")
            } onDisposed: {
                print("Disposed")
            }.disposed(by: disposeBag)

        
    }
    
    @IBAction func actionClear(_ sender: Any) {
        images.accept([])
        imageCache = []                             // clear 버튼 클릭 시 imageCache에 있는 데이터를 삭제
    }
    
    func showMessage(_ message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        
        alertController.addAction(closeAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func updateNavigationIcon() {
        let icon = imageView.image?
            .scaled(CGSize(width: 22, height: 22))
            .withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: icon, style: .done, target: nil, action: nil)
    }
}
