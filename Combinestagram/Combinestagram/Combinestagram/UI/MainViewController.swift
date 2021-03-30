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
    
    private let disposeBag = DisposeBag()
    private let images = BehaviorRelay<[UIImage]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        images
            .subscribe(onNext: { [weak imageView] photos in
                guard let preview = imageView else { return }
                
                preview.image = UIImage.collage(images: photos, size: preview.frame.size)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func actionAdd(_ sender: Any) {
        let newImages = images.value + [UIImage(named: "sunset")!]
        images.accept(newImages)
    }
    
    @IBAction func actionClear(_ sender: Any) {
        images.accept([])
    }
}
