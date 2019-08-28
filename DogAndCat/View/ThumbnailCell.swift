//
//  ThumbnailCell.swift
//  DogAndCat
//
//  Created by isarag on 2019/12/15.
//  Copyright © 2019 isarag. All rights reserved.
//

import UIKit

class ThumbnailCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    func setConfigure(data: Data) {
        self.thumbnailImageView.image = UIImage(data: data)
    }
}
