//
//  ThumbnailViewController.swift
//  DogAndCat
//
//  Created by isarag on 2019/12/15.
//  Copyright © 2019 isarag. All rights reserved.
//

import UIKit
import Photos

protocol ThumbnailView: class {
    func insertItems(at indexPaths: [IndexPath])
    func showContentScreenAlert()
    func showNoContentScreenAlert()
    func showLoading()
    func hideLoading()
    func showDeniedAlert()
    func transitionToSettingsApp()
}

final class ThumbnailViewController: UIViewController {

    var presenter: ThumbnailViewPresentation!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
        libraryRequestAuthorization()
    }

    private func setupUI() {
        let flowLayout: UICollectionViewFlowLayout! = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 1, height: UIScreen.main.bounds.width / 3 - 1)
        flowLayout.sectionInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 2

        self.collectionView.collectionViewLayout = flowLayout
    }

    private func libraryRequestAuthorization() {
        PHPhotoLibrary.requestAuthorization({ [weak self] status in
            guard let self = self else { return }
            switch status {
            case .authorized:
                self.presenter.fetch()
            case .denied:
                self.presenter.authDenied()
            case .notDetermined:
                print("NotDetermined")
            case .restricted:
                print("Restricted")
            @unknown default:
                fatalError()
            }
        })
    }
}

extension ThumbnailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.thumbnails.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnailCell", for: indexPath) as? ThumbnailCell else {
            fatalError()
        }
        cell.setConfigure(data: self.presenter.thumbnails[indexPath.row].data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.showDetail(thumbnail: self.presenter.thumbnails[indexPath.row])
    }
}

extension ThumbnailViewController: ThumbnailView {
    func insertItems(at indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.collectionView.insertItems(at: indexPaths)
        }
    }
    
    func showContentScreenAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "完了", message: "✅", preferredStyle: .alert)
            self.present(alert, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func showNoContentScreenAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "エラー", message: "見つかりませんでした", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.indicator.startAnimating()
            self.indicator.isHidden = false
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
        }
    }
    
    func showDeniedAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "エラー",
                                          message: "「写真」へのアクセスが拒否されています。設定より変更してください。",
                                          preferredStyle: .alert)
            let cancel = UIAlertAction(title: "キャンセル",
                                       style: .cancel,
                                       handler: nil)
            let ok = UIAlertAction(title: "設定画面へ",
                                   style: .default,
                                   handler: { [weak self] (action) in
                                    self?.presenter.transitionToSettingsApp()
            })
            alert.addAction(cancel)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func transitionToSettingsApp() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension ThumbnailViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        self.presenter.fetch()
    }
}

