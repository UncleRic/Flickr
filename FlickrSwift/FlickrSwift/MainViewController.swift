//  MainViewController.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 9/29/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import UIKit

var gSelectedItemIndex: Int = 0

class MainViewController: UIViewController {
    var photos: PhotoStuff?
    var downloadItems = [ImageDownloadItem]()
    var itemID = 0
    let searchText = "Shark"
    let searchTag = "[shark, ocean]"

    @IBOutlet var collectionView: UICollectionView!

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
        title = "Sea Life"
    }

    // -----------------------------------------------------------------------------------------------------

    // MARK: - Refresh Control

    private func setupRefreshControl() {
        // Refresh Control:
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        let refreshControlContainer = view.layoutMarginsGuide
        refreshControl.topAnchor.constraint(equalTo: refreshControlContainer.topAnchor, constant: 1.0).isActive = true
        refreshControl.heightAnchor.constraint(equalToConstant: 300.0).isActive = true

        refreshControl.leftAnchor.constraint(equalTo: refreshControlContainer.leftAnchor, constant: 1.0).isActive = true
        refreshControl.rightAnchor.constraint(equalTo: refreshControlContainer.rightAnchor, constant: 1.0).isActive = true

        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh Data")
        refreshControl.tintColor = .red
        refreshControl.backgroundColor = .white

        // StackView members:
        let hook = UIImage(named: "Hook")
        let hookImageView = UIImageView(image: hook)
        let fish = UIImage(named: "Fish")
        let fishImageView = UIImageView(image: fish)

        // StackView:
        let stackView = UIStackView(arrangedSubviews: [hookImageView, fishImageView])
        stackView.axis = .vertical
        stackView.spacing = 10.0
        refreshControl.addSubview(stackView)

        // Positioning StackView within its container:
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let container = refreshControl.layoutMarginsGuide
        stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 1.0).isActive = true
        let width = refreshControl.bounds.size.width
        stackView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: width / 2.0).isActive = true

        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    @objc func handleRefresh(sender: UIRefreshControl) {
        fetchFlickrPhoto(searchText, tags: searchTag)
        sender.endRefreshing()
    }

    // -----------------------------------------------------------------------------------------------------

    // MARK: - NSURLSesson

    private func fetchFlickrPhoto(_ searchString: String, tags: String) {
        guard let url = getURLForString(searchString, tags: tags) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if error == nil, let data = data {
                    self.dessiminateData(photoItems: self.disseminateJSON(data: data)?.photo)
                    self.collectionView.isHidden = false
                    self.collectionView.reloadData()
                } else {
                    let controller = UIAlertController(title: "No Wi-Fi", message: "Wi-Fi needs to be restored before continuing.", preferredStyle: .alert)
                    let myAlertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    controller.addAction(myAlertAction)
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }

    // -----------------------------------------------------------------------------------------------------

    private func dessiminateData(photoItems: [PhotoInfo]? = nil) {
        guard let photoItems = photoItems else {
            return
        }
        photoItems.forEach { photoInfo in
            let imageDownloadItem = ImageDownloadItem(photoInfo: photoInfo)
            self.downloadItems.append(imageDownloadItem)
        }
        return
    }

    // =======================================================================================================================

    // MARK: - Action Methods

    @IBAction func exitAction(_: AnyObject) {
        exit(0)
    }
}

// =======================================================================================================================

// MARK: - Extensions

extension MainViewController: UICollectionViewDataSource {
    // -----------------------------------------------------------------------------------------------------

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return downloadItems.count
    }

    // -----------------------------------------------------------------------------------------------------

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)
        guard let photoImageView = cell.viewWithTag(1) as? UIImageView else {
            return cell
        }
        downloadItems[indexPath.item].itemID = indexPath.item

        if let image = downloadItems[indexPath.item].image {
            photoImageView.image = image
        } else if let urlSQ = downloadItems[indexPath.item].photoInfo?.url_sq {
            let url = URL(string: urlSQ)
            downloadImageAtURL(url!, completion: { (image: UIImage?, error: NSError?) in
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
