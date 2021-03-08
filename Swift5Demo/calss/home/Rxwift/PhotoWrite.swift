//
//  PhotoWrite.swift
//  Swift5Demo
//
//  Created by 阿永 on 2021/2/22.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import RxSwift
import Photos

class PhotoWrite {

    enum Errors: Error {
        case couldNotSavePhoto
    }
    
    static func save(_ image: UIImage) -> Single<String> {
        return Single.create(subscribe: { observe in
            var savedAssetId: String?
            
            PHPhotoLibrary.shared().performChanges {
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                savedAssetId = request.placeholderForCreatedAsset?.localIdentifier
            } completionHandler: { (success, error) in
                DispatchQueue.main.async {
                    if success, let id = savedAssetId {
//                        observe.onNext(id)
//                        observe.onCompleted()
                        observe(.success(id))
                    } else {
                        observe(.error(error ?? Errors.couldNotSavePhoto))
                    }
                }
            }

            return Disposables.create()
        })
    }

}
