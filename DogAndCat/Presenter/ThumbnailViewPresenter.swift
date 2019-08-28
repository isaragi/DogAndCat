//
//  ThumbnailViewPresenter.swift
//  DogAndCat
//
//  Created by isarag on 2019/12/08.
//  Copyright © 2019 isarag. All rights reserved.
//

import Foundation

protocol ThumbnailViewPresentation: class {
    func fetch()
    func authDenied()
    func transitionToSettingsApp()
    var thumbnails: [ThumbnailEntity] { get }
    func showDetail(thumbnail: ThumbnailEntity)
}

protocol ImageManagerInteractorOutputInterface: class {
    func responseImageData(_ datas: [Data])
}

protocol ThumbnailInteractorOutputInterface: class {
    func searched()
    func insertItem(at index: Int)
}

final class ThumbnailViewPresenter {
    private weak var view: ThumbnailView!
    private let router: ThumbnailWireframe
    private let searchThumbnailInteractor: SearchThumbnailInteractorInterface
    private let imageDataInteractor: ImageDataInteractorInterface
    
    var thumbnails: [ThumbnailEntity] {
        return self.searchThumbnailInteractor.dataSouce
    }
    
    init(view: ThumbnailView, router: ThumbnailWireframe,
         searchThumbnailInteractor: SearchThumbnailInteractorInterface,
         imageDataInteractor: ImageDataInteractorInterface) {
        self.view = view
        self.router = router
        self.searchThumbnailInteractor = searchThumbnailInteractor
        self.imageDataInteractor = imageDataInteractor
    }
}

extension ThumbnailViewPresenter: ImageManagerInteractorOutputInterface {
    func responseImageData(_ datas: [Data]) {
        datas.count > 0 ? self.searchThumbnailInteractor.search(with: datas) : self.view.showNoContentScreenAlert()
    }
}

extension ThumbnailViewPresenter: ThumbnailInteractorOutputInterface {
    func insertItem(at index: Int) {
        self.view.insertItems(at: [IndexPath(item: index, section: 0)])
    }
    
    func searched() {
        self.view.hideLoading()
        self.thumbnails.count > 0 ? self.view.showContentScreenAlert() : self.view.showNoContentScreenAlert()
    }
}

extension ThumbnailViewPresenter: ThumbnailViewPresentation {
    func fetch() {
        if self.thumbnails.count == 0 {
            self.view.showLoading()
            self.imageDataInteractor.requestImageData()
        }
    }
    
    func authDenied() {
        self.view.hideLoading()
        self.view.showDeniedAlert()
    }
    
    func transitionToSettingsApp() {
        self.view.hideLoading()
        self.view.transitionToSettingsApp()
    }
    
    func  showDetail(thumbnail: ThumbnailEntity) {
        self.router.showThumbnailDetail(thumbnail)
    }
}
