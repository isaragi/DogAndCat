//
//  RootRouter.swift
//  DogAndCat
//
//  Created by isarag on 2019/12/08.
//  Copyright © 2019 isarag. All rights reserved.
//

import UIKit

class RootRouter {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func showFirstView() {
        let firstView = ThumbnailRouter.assembleModules()
        let navigationController = UINavigationController(rootViewController: firstView)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
