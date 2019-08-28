//
//  AnimalDetailWireframe.swift
//  Kuri
//
//  Created by isarag on 2019/12/15.
//  Copyright © 2019 isarag. All rights reserved.
//

import UIKit

protocol AnimalDetailWireframe: class {}


class AnimalDetailRouter: AnimalDetailWireframe {
    private weak var viewController: UIViewController!
    private let thumbnail: ThumbnailEntity
    
    private init(thumbnail: ThumbnailEntity) {
        self.thumbnail = thumbnail
    }

    static func assembleModules(thumbnail: ThumbnailEntity) -> UIViewController {
        let view = AnimalDetailRouter.instantiateViewController()
        let router = AnimalDetailRouter(thumbnail: thumbnail)
        let presenter = AnimalDetailPresenter(view: view, wireframe: router, thumnail: thumbnail)
        view.inject(presenter: presenter)
        return view
    }
    
    static func  instantiateViewController() -> AnimalDetailViewController {
        let storyboard = UIStoryboard(name: "AnimalDetailViewController", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? AnimalDetailViewController else {
            fatalError()
        }
        return viewController
    }
}
