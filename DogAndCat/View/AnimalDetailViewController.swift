//
//  AnimalDetailViewController.swift
//  Kuri
//
//  Created by isarag on 2019/12/15.
//  Copyright © 2019 isarag. All rights reserved.
//

import UIKit

protocol AnimalDetailView: class {
    func setImage(data: Data)
    func setDetectionLabel(detection: String)
}


class AnimalDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detectionLabel: UILabel!
    
    private(set) var presenter: AnimalDetailPresentation!
    
    func inject(presenter: AnimalDetailPresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
    }
}

extension AnimalDetailViewController: AnimalDetailView {
    func setImage(data: Data) {
        self.imageView.image = UIImage(data: data)
    }
    
    func setDetectionLabel(detection: String) {
        self.detectionLabel.text = detection
    }
}
