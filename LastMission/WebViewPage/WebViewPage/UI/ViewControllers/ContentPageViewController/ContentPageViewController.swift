//
//  ContentPageViewController.swift
//  WebViewPage
//
//  Created by 김기현 on 2021/04/05.
//

import UIKit

class ContentPageViewController: UIPageViewController {

    var items: [DataModel] = []
    var imageArray: [String] = []
    var currentIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for element in items {
            guard let baseURL = element.defaultURL,
                  let query = element.url else { return }
            
            imageArray.append(baseURL + query)
        }
        
        print("imageArray: \(imageArray)")
        
        dataSource = self
        
        if let viewController = viewPhotoController(currentIndex ?? 0) {
            let viewControllers = [viewController]
            
            setViewControllers(viewControllers,
                               direction: .forward,
                               animated: false,
                               completion: nil)
        }
    }
    
    func viewPhotoController(_ index: Int) -> ContentViewController? {
        guard let storyboard = storyboard,
              let page = storyboard.instantiateViewController(identifier: "ContentViewController") as? ContentViewController else { return nil }
        
        page.currentIndex = index
        page.imageArray = imageArray
        
        return page
    }
}

extension ContentPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? ContentViewController,
           let index = viewController.currentIndex,
           index > 0 {
            return viewPhotoController(index - 1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? ContentViewController,
           let index = viewController.currentIndex,
           index + 1 < imageArray.count {
            return viewPhotoController(index + 1)
        }
        
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return imageArray.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex ?? 0
    }
}
