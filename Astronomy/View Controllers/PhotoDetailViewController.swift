//
//  PhotoDetailViewController.swift
//  Astronomy
//
//  Created by Andrew R Madsen on 9/9/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import Photos

class PhotoDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else { return }
      
      PHPhotoLibrary.requestAuthorization { (status) in
        if status == .authorized {
          PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
          }, completionHandler: { (success, error) in
            if let error = error {
              NSLog("Error saving photo: \(error)")
              return
            }
          })
        } else {
          DispatchQueue.main.async {
            let alert = UIAlertController(title: "Saving Image", message: "Can't save the image", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
          }
        }
      }
      
      
        
    }
    
    // MARK: - Private
    
  private func updateViews() {
    guard let photo = photo, isViewLoaded,
      let photoUrl = photo.imageURL.usingHTTPS
      else { return }
    
    let dateString = dateFormatter.string(from: photo.earthDate)
    title = dateString
    detailLabel.text = "Taken by \(photo.camera.roverId) on \(dateString) (Sol \(photo.sol))"
    cameraLabel.text = photo.camera.fullName
    
    do {
      let data = try Data(contentsOf: photoUrl)
      imageView.image = UIImage(data: data)
      
    } catch {
      NSLog("Error setting up views on detail view controller: \(error)")
    }
  }
    
    // MARK: - Properties
    
    var photo: MarsPhotoReference? {
        didSet {
            updateViews()
        }
    }
    
    lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var cameraLabel: UILabel!
    
}
