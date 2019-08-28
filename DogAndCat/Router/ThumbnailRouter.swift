//
//  ThumbnailRouter.swift
//  DogAndCat
//
//  Created by isarag on 2019/12/08.
//  Copyright © 2019 isarag. All rights reserved.
//

import UIKit

protocol ThumbnailWireframe: AnyObject {
    func showThumbnailDetail(_ thumbnail: ThumbnailEntity)
}

final class ThumbnailRouter {
    private unowned let viewController: UIViewController

    private init(viewController: UIViewController) {
        self.viewController = viewController
    }

    static func assembleModules() -> UIViewController {
        let view = ThumbnailRouter.instantiateViewController()
        let router = ThumbnailRouter(viewController: view)
        let searchThumbnailInteractor = SearchThumbnailInteractor()
        let imageDataInteractor = ImageDataInteractor()
        let presenter = ThumbnailViewPresenter(view: view,
                                               router: router,
                                               searchThumbnailInteractor: searchThumbnailInteractor,
                                               imageDataInteractor: imageDataInteractor)
        view.presenter = presenter
        searchThumbnailInteractor.output = presenter
        imageDataInteractor.output = presenter
        return view
    }
    
    static func  instantiateViewController() -> ThumbnailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? ThumbnailViewController else {
            fatalError()
        }
        return viewController
    }
}

extension ThumbnailRouter: ThumbnailWireframe {
    func showThumbnailDetail(_ thumbnail: ThumbnailEntity) {
        let detailView = AnimalDetailRouter.assembleModules(thumbnail: thumbnail)
        viewController.navigationController?.pushViewController(detailView, animated: true)
    }
}
