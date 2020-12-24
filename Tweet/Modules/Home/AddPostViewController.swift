//
//  AddPostViewController.swift
//  Tweet
//
//  Created by Maiqui Cedeño on 3/11/20.
//  Copyright © 2020 Poseto Studio. All rights reserved.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift
import FirebaseStorage
import AVFoundation
import AVKit
import MobileCoreServices
import CoreLocation

class AddPostViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func addPostAction() {
        
        if currentVideoURL != nil {
            
            uploadVideoToFirebase()
            
            return
        }
        
        if previewImageView.image != nil {
            
            uploadPhotoToFirebase()
            
            return
        }
            
        //openVideoCamera()
    
        savePost(imageUrl: nil, videoUrl: nil)
    }
    
    @IBAction func openCameraAction() {
        
        let alert = UIAlertController(title: "Camera",
                                      message: "Choose option",
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo", style: .default, handler: { _ in
            
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Video", style: .default, handler: { _ in
            
            self.openVideoCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func dismissAction() {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openPreviewAction() {
        
        guard let currentVideoURL = currentVideoURL else {
            return
        }
        
        //Capture video
        let avPLayer = AVPlayer(url: currentVideoURL)
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPLayer
        
        present(avPlayerController, animated: true) {
            
            //Start the video automatically
            avPlayerController.player?.play()
        }
    }
    
    // MARK: - Properties
    private var imagePicker: UIImagePickerController?
    private var currentVideoURL: URL?
    private var locationManager: CLLocationManager?
    private var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        requestLocation()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        
        videoButton.isHidden = true
    }
    
    private func openVideoCamera() {
        
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.mediaTypes = [kUTTypeMovie as String]
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .video
        imagePicker?.videoQuality = .typeMedium
        imagePicker?.videoMaximumDuration = TimeInterval(5)
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            return
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func openCamera() {
        
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .photo
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            return
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func uploadVideoToFirebase() {
        
        guard
            let currentVideoSavedURL = currentVideoURL,
            let videoData: Data = try? Data(contentsOf: currentVideoSavedURL) else {
            
            return
        }
        
        //Show load Indicator
        SVProgressHUD.show()
        
        //Save video in Firebase
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "video/MP4"
        
        let storage = Storage.storage()
        let videoName = Int.random(in: 1001...10000)
        let folderReference = storage.reference(withPath: "videos-tweets/\(videoName).mp4")
        
        //Secundary thread
        DispatchQueue.global(qos: .background).async {
            
            folderReference.putData(videoData, metadata: metaDataConfig) { (metadata: StorageMetadata?, error: Error?) in
                
                //Main thread
                DispatchQueue.main.async {
                    
                    //dismiss load indicator
                    SVProgressHUD.dismiss()
                    
                    if let error = error {
                        NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
                    }
                    
                    folderReference.downloadURL { (url: URL?, error: Error?) in
                        
                        let downloadUrl = url?.absoluteString ?? ""
                        self.savePost(imageUrl: nil, videoUrl: downloadUrl)
                    }
                }
            }
        }
    }
    
    
    private func uploadPhotoToFirebase() {
        
        //Do we get a image?
        guard let imageSaved = previewImageView.image,
              let imageSavedData: Data = imageSaved.jpegData(compressionQuality: 0.1) else{
            return
        }
        
        SVProgressHUD.show()
        
        //Save photo in Firebase
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        
        let storage = Storage.storage()
        let imageName = Int.random(in: 100...1000)
        let folderReferences = storage.reference(withPath: "photos-tweets/\(imageName).jpg")
        
        //Secundary thread
        DispatchQueue.global(qos: .background).async {
            
            folderReferences.putData(imageSavedData, metadata: metaDataConfig) {(metaData: StorageMetadata?, error: Error?) in
                
                //Main thread
                DispatchQueue.main.async {
                    
                    SVProgressHUD.dismiss()
                    
                    if let error = error {
                        NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
                        return
                    }
                    
                    folderReferences.downloadURL { (url: URL?, error: Error?) in
                        
                        let downloadUrl = url?.absoluteString ?? ""
                        self.savePost(imageUrl: downloadUrl, videoUrl: nil)
                    }
                    
                }
            }
        }
    }
    
    private func savePost(imageUrl: String?, videoUrl: String?) {
        
        //Location Request
        var postLocation: PostRequestLocation?
        
        if let userLocation = userLocation {
            
            postLocation = PostRequestLocation(latitude: userLocation.coordinate.latitude,
                                               longitud: userLocation.coordinate.longitude)
        }
        
        //Do request
        let request = PostRequest(text: postTextView.text,
                                  imageUrl: imageUrl,
                                  videoUrl: videoUrl,
                                  location: nil)
        
        //load indicator
        SVProgressHUD.show()
        
        //Post services
        SN.post(endpoint: EndPoints.post, model: request) { (response: SNResultWithEntity<Post, ErrorResponse>) in
            
            //dismiss load indicator
            SVProgressHUD.dismiss()
            
            switch response {
            
            case .success:
                
                self.dismiss(animated: true, completion: nil)
                
            case .error(let error):
                
                NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
                
            case .errorResult(let entity):
                
                NotificationBanner(title: "Error", subtitle: entity.error, style: .warning).show()
            }
        }
    }
    
    private func requestLocation() {
        
        //Are location services enable?
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Close the camera
        imagePicker?.dismiss(animated: true, completion: nil)
        
        //If we have an image...
        if info.keys.contains(.originalImage) {
            
            previewImageView.isHidden = false
            
            //Get the image
            previewImageView.image = info[.originalImage] as? UIImage
        }
        
        //if We have a video URL..
        if info.keys.contains(.mediaURL), let recordedVideoUrl = (info[.mediaURL] as? URL)?.absoluteURL {
            
            videoButton.isHidden = false
            currentVideoURL = recordedVideoUrl
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension AddPostViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Get the last user location
        guard let bestLocation = locations.last else {
            return
        }
        
        userLocation = bestLocation
    }
}
