//
//  File.swift
//  WebViewPage
//
//  Created by 김기현 on 2021/04/02.
//

import Foundation

struct DataModel: Codable {
    let id: String?
    let type: String?
    let url: String?
}

protocol GalleryDataSource {
    func passData(id: String, type: String, url: String)
}
