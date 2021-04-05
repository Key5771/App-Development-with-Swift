//
//  PhotoWriter.swift
//  Combinestagram
//
//  Created by 김기현 on 2021/04/05.
//

import Foundation
import UIKit
import RxSwift
import Photos

class PhotoWriter {
    enum Errors: Error {
        case couldNotSavePhoto
    }
    
    static func save(_ image: UIImage) -> Observable<String> {
        return Observable.create { observer in
            var savedAssetId: String?
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                savedAssetId = request.placeholderForCreatedAsset?.localIdentifier
            }) { (success, error) in
                DispatchQueue.main.async {
                    if success, let id = savedAssetId {
                        observer.onNext(id)
                        observer.onCompleted()
                    } else {
                        observer.onError(error ?? Errors.couldNotSavePhoto)
                    }
                }
            }
            
            return Disposables.create()
        }
    }
}
