//
//  SystemViewController.swift
//  EmojiDictionary
//
//  Created by 김기현 on 2021/03/22.
//

import UIKit

class SystemViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func shareButtomTapped(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        
        self.present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func safariButtomTapped(_ sender: Any) {
    }
    
    @IBAction func cameraButtomTapped(_ sender: Any) {
    }
    
    @IBAction func emailButtonTapped(_ sender: Any) {
    }
}
