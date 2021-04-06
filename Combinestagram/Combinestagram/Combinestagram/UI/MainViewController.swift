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
            .filter { newImage in
                return newImage.size.width > newImage.size.height       // 가로사진만 허용하도록 필터
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
