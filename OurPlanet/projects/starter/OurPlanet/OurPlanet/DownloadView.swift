//
//  DownloadView.swift
//  OurPlanet
//
//  Created by 김기현 on 2021/04/12.
//  Copyright © 2021 Ray Wenderlich. All rights reserved.
//

import UIKit

class DownloadView: UIStackView {
  let label = UILabel()
  let progress = UIProgressView()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    translatesAutoresizingMaskIntoConstraints = false
    
    axis = .horizontal
    spacing = 0
    distribution = .fillEqually
    
    if let superView = superview {
      backgroundColor = .white
      bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
      leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
      rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
      heightAnchor.constraint(equalToConstant: 38).isActive = true
      
      label.text = "Download"
      label.translatesAutoresizingMaskIntoConstraints = false
      label.backgroundColor = .lightGray
      label.textAlignment = .center
      
      progress.translatesAutoresizingMaskIntoConstraints = false
      
      let progressWrap = UIView()
      progressWrap.translatesAutoresizingMaskIntoConstraints = false
      progressWrap.backgroundColor = .lightGray
      progressWrap.addSubview(progress)
      
      progress.leftAnchor.constraint(equalTo: progressWrap.leftAnchor).isActive = true
      progress.rightAnchor.constraint(equalTo: progressWrap.rightAnchor, constant: -10).isActive = true
      progress.heightAnchor.constraint(equalToConstant: 4).isActive = true
      progress.centerYAnchor.constraint(equalTo: progressWrap.centerYAnchor).isActive = true
      
      addArrangedSubview(label)
      addArrangedSubview(progressWrap)
    }
  }

}
