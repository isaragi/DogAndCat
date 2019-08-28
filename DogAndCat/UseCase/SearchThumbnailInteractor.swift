//
//  SearchThumbnailInteractor.swift
//  DogAndCat
//
//  Created by isarag on 2019/12/08.
//  Copyright © 2019 isarag. All rights reserved.
//

import Foundation
import Vision
import UIKit

protocol SearchThumbnailInteractorInterface: class {
    func search(with datas: [Data])
    var dataSouce: [ThumbnailEntity] { get }
}

final class SearchThumbnailInteractor {
    weak var output: ThumbnailInteractorOutputInterface!
    private(set) var thumbnails = [ThumbnailEntity]()

    init() {
    }
    
    private func searchAnimals(with datas: [Data], completion: @escaping () -> (Void)) {
        let group = DispatchGroup()
        let lock = NSLock()
        var searchIndex = 0
        
        let animalRecognitionRequest = VNRecognizeAnimalsRequest { [weak self] (request, error) in
            DispatchQueue.global(qos: .userInitiated).async {
                defer { lock.unlock() }
                guard let results = request.results as? [VNRecognizedObjectObservation], results.count > 0 else {
                    return
                }
                var detectionString = ""
                var animalCount = 0
                
                for result in results {
                    let animals = result.labels
                    for animal in animals {
                        animalCount = animalCount + 1
                        let animalLabel = animal.identifier == VNAnimalIdentifier.cat.rawValue ? "😸" : "🐶"
                        let string = "#\(animalCount) \(animal.identifier) \(animalLabel) confidence is \(animal.confidence)\n"
                        detectionString = detectionString + string
                    }
                }
                guard let self = self else { return }
                self.thumbnails.append(ThumbnailEntity(data: datas[searchIndex], detection: detectionString))
                self.output.insertItem(at: self.thumbnails.count - 1)
            }
        }
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        for (i, data) in datas.enumerated() {
            group.enter()
            queue.async(group: group) {
                defer { group.leave() }
                lock.lock()
                guard let image = UIImage(data: data), let cgImage = image.cgImage else { return }
                searchIndex = i
                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                try? requestHandler.perform([animalRecognitionRequest])
            }
        }

        group.notify(queue: .main) {
            completion()
        }
    }
}

extension SearchThumbnailInteractor :SearchThumbnailInteractorInterface {
    var dataSouce: [ThumbnailEntity] {
        return self.thumbnails
    }
    
    func search(with datas: [Data]) {
        self.searchAnimals(with: datas) { [weak self] in
            self?.output.searched()
        }
    }
}
