//
//  AnimalDetailPresenter.swift
//  Kuri
//
//  Created by isarag on 2019/12/15.
//  Copyright © 2019 isarag. All rights reserved.
//

import Foundation

protocol AnimalDetailPresentation: class {
    func viewDidLoad()
}


class AnimalDetailPresenter: AnimalDetailPresentation {
    private weak var view: AnimalDetailView!
    private let wireframe: AnimalDetailWireframe
    private let thumnail: ThumbnailEntity
    
    init(view: AnimalDetailView, wireframe: AnimalDetailWireframe, thumnail: ThumbnailEntity) {
        self.view = view
        self.wireframe = wireframe
        self.thumnail = thumnail
    }
    
    func viewDidLoad() {
        self.view.setImage(data: self.thumnail.data)
        self.view.setDetectionLabel(detection: self.thumnail.detection)
    }
}
