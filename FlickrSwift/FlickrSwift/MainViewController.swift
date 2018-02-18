//  MainViewController.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 9/29/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import UIKit

var gSelectedItemIndex:Int = 0

class MainViewController: UIViewController {
    var photos:PhotoStuff?
    var downloadItems = [ImageDownloadItem]()
    var itemID = 0
    let searchText = "Shark"
    let searchTag = "[shark, ocean]"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFlickrPhoto(searchText, tags: searchTag)
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Sea Life"
    }
    
    // -----------------------------------------------------------------------------------------------------
    // MARK: - Refresh Control
    
    private func setupRefreshControl() {
        let refreshControl =  UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh Data")
        refreshControl.tintColor = .red
        refreshControl.backgroundColor = .white
        let hook = UIImage.init(named: "Hook")
        let hookImageView = UIImageView(image:hook)
        let fish = UIImage.init(named: "Fish")
        let fishImageView = UIImageView(image: fish)
        
        let stackView = UIStackView(arrangedSubviews: [hookImageView, fishImageView])
        stackView.axis = .vertical
        stackView.spacing = 10.0
        refreshControl.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let container = refreshControl.layoutMarginsGuide
        stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 1.0).isActive = true
        let width = refreshControl.bounds.size.width
        stackView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: width/2.0).isActive = true
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    
    @objc func handleRefresh(sender: UIRefreshControl) {
        fetchFlickrPhoto(searchText, tags: searchTag)
        sender.endRefreshing()
    }
    
    // -----------------------------------------------------------------------------------------------------
    // MARK: - NSURLSesson
    
    
    private func fetchFlickrPhoto(_ searchString:String, tags:String) {
        guard let url = getURLForString(searchString, tags: tags) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if nil == error, let data = data {
                self.dessiminateData(photoItems: self.disseminateJSON(data: data)?.photo)
                DispatchQueue.main.async(execute: {
                    self.collectionView.isHidden = false
                    self.collectionView.reloadData()
                })
            } else {
                let controller = UIAlertController(title: "No Wi-Fi", message: "Wi-Fi needs to be restored before continuing.", preferredStyle: .alert)
                let myAlertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                controller.addAction(myAlertAction)
                self.present(controller, animated:true, completion:nil)
            }
        }
        task.resume()
    }
    
    // -----------------------------------------------------------------------------------------------------
    
    private func dessiminateData(photoItems: [PhotoInfo]? = nil) {
        guard let photoItems = photoItems else {
            return
        }
        photoItems.forEach { (photoInfo) in
            let imageDownloadItem = ImageDownloadItem(photoInfo: photoInfo)
            self.downloadItems.append(imageDownloadItem)
        }
        return
    }
    
    // =======================================================================================================================
    // MARK: - Action Methods
    
    @IBAction func exitAction(_ sender: AnyObject) {
        exit(0)
    }
}

// =======================================================================================================================
// MARK: - Extensions

extension MainViewController: UICollectionViewDataSource {
    
    // -----------------------------------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return downloadItems.count
    }
    
    // -----------------------------------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for:indexPath)
        guard let photoImageView = cell.viewWithTag(1) as? UIImageView else {
            print("*** WARNING: Unable to cast subview to UIImageView. ***")
            return cell
        }
        downloadItems[indexPath.item].itemID = indexPath.item
        
        if let image = downloadItems[indexPath.item].image {
            photoImageView.image = image
        } else if let urlSQ = downloadItems[indexPath.item].photoInfo?.url_sq {
            let url = URL(string:urlSQ)
            self.downloadImageAtURL(url!, completion: {(image:UIImage?, error:NSError?) in
                if let myImage = image {
                    photoImageView.image = myImage
                    self.downloadItems[indexPath.item].image = myImage
                } else if let myError = error {
                    print("*** ERROR in cell: \(myError.userInfo)")
                }
            }) // ...end completion.
        }
        cell.tag = indexPath.item
        return cell
    }
}

// -----------------------------------------------------------------------------------------------------

extension MainViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UICollectionViewCell else {
            return
        }
        itemID = cell.tag
        if segue.identifier == "showDetail" {
            let destinationViewController = segue.destination as? DetailViewController
            destinationViewController?.mainViewController = self
        }
    }
}








