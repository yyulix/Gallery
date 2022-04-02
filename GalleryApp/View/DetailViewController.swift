//
//  DetailViewController.swift
//  GalleryApp
//
//  Created by Yulia Popova on 2/4/2022.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var photoService = PhotoService.shared
    
    var url : String?
    var date : Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureImage()
        configureDate()
        configureShareButton()
        configureBackButton()
        detailImage.enableScale()
        configureCollectionView()
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.fetchPhotos()
        }
    }
    
    func fetchPhotos() {
        photoService.fetchPhotos { (success: Bool) -> Void in
            if success {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.collectionView.isHidden = false
                }
            }
        }
    }
    
    func configureImage() {
        detailImage.layer.bounds.size.width = view.layer.bounds.width
        detailImage.layer.bounds.size.height = view.layer.bounds.width
        let photoURL = URL(string: url!)
        detailImage.kf.setImage(with: photoURL)
    }
    
    func configureDate() {
        let date = Date(timeIntervalSince1970: date!)
        let formater = DateFormatter()
        formater.dateFormat = "dd.MM.yyyy"
        self.title = formater.string(from: date)
    }
    
    func configureBackButton() {
        var backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(back))
        backButton.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = backButton
    }
    
    func configureShareButton() {
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(share))
        shareButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc func share() {
        let image = detailImage.image!
        presentActivityViewController(image: image)
    }
    
    @objc func back() {
        let galleryViewController : GalleryViewController = GalleryViewController(nibName: "GalleryViewController", bundle: nil)
        let controller = UINavigationController(rootViewController: galleryViewController)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false, completion: nil)
    }
    
    func presentActivityViewController(image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityViewController, animated: false, completion: nil)
    }
    
    func configureCollectionView() {
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: reusableCellId)
        collectionView.isHidden = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoURL = URL(string: photoService.photos[indexPath.row].optimalSizeImage.url)
        detailImage.kf.setImage(with: photoURL)
        date = photoService.photos[indexPath.row].date
        configureDate()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoService.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCellId, for: indexPath) as! GalleryCollectionViewCell
        let url = URL(string: photoService.photos[indexPath.row].optimalSizeImage.url)
        cell.imageView.kf.setImage(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 56, height: 56)
    }
}
