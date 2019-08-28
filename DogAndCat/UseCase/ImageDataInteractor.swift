//
//  ImageManagerInteractor.swift
//  DogAndCat
//
//  Created by 五十嵐淳 on 2019/12/16.
//

import Foundation
import Photos

protocol ImageDataInteractorInterface: class {
    func requestImageData()
}

final class ImageDataInteractor: ImageDataInteractorInterface {
    weak var output: ImageManagerInteractorOutputInterface!
    private typealias DataHandler = ([Data]) -> Void
    
    init() {
    }
    
    func requestImageData() {
        self.request { [weak self] (datas) in
            self?.output.responseImageData(datas)
        }
    }
    
    private func request(_ completion: @escaping DataHandler) {
        let assets = PHAsset.fetchAssets(with: .image, options: nil)
        guard assets.count > 0 else { return completion([]) }
        
        let group = DispatchGroup()
        let manager = PHImageManager.default()
        var datas = [Data]()
        
        for i in 0..<assets.count {
            group.enter()
            let asset = assets.object(at: i)
            manager.requestImageDataAndOrientation(for: asset, options: .allowNetworkAccess) { (data, string, orientation, info) in
                guard let data = data else {
                    group.leave()
                    return
                }
                datas.append(data)
                group.leave()
            }
        }
        group.wait()
        completion(datas)
    }
}

extension PHImageRequestOptions {
    fileprivate static let allowNetworkAccess: PHImageRequestOptions = {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isNetworkAccessAllowed = true
        return requestOptions
    }()
}
