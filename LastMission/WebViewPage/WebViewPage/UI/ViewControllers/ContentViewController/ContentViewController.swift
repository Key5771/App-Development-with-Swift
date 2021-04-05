//
//  ContentViewController.swift
//  WebViewPage
//
//  Created by 김기현 on 2021/04/02.
//

import UIKit
import AVFoundation
import SafariServices

class ContentViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var items: [DataModel] = []
    var imageArray: [(String, String)] = []
    var currentIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.isHidden = true
        loadImageView()
    }
    
    override func viewWillLayoutSubviews() {
        loadImageView()
    }
    
    func loadImageView() {
        activityIndicator.startAnimating()
        DispatchQueue.global().async {
            guard let index = self.currentIndex,
                  let url = URL(string: self.imageArray[index].0) else { return }
            let type = self.imageArray[index].1
            
            if type == "image" {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                        self.activityIndicator.stopAnimating()
                    }
                }
            } else {
                let asset = AVURLAsset(url: url)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                
                do {
                    let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                    let uiImage = UIImage(cgImage: cgImage)
                    
                    DispatchQueue.main.async {
                        self.playButton.isHidden = false
                        self.imageView.image = uiImage
                        self.activityIndicator.stopAnimating()
                    }
                } catch(let error) {
                    print("ERROR: \(error)")
                }
            }
        }
    }
    
    @IBAction func playClick(_ sender: Any) {
        guard let index = currentIndex,
              let url = URL(string: imageArray[index].0) else { return }
        let safariViewController = SFSafariViewController(url: url)
        self.present(safariViewController, animated: true, completion: nil)
    }
    
}
