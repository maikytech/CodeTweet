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

class AddPostViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func addPostAction() {
        
        //uploadPhotoToFirebase()
        openVideoCamera()
    }
    
    @IBAction func openCameraAction() {
        
        openCamera()
        
    }
    @IBAction func dismissAction() {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openPreviewAction() {
        
        
    }
    // MARK: - Properties
    private var imagePicker: UIImagePickerController?
    private var currentVideoUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Private Methods
    
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
                        self.savePost(imageUrl: downloadUrl)
                    }
                    
                }
            }
        }
    }
    
    private func savePost(imageUrl: String?) {
        
        //Do request
        let request = PostRequest(text: postTextView.text, imageUrl: imageUrl, videoUrl: nil, location: nil)
        
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
        
        //Capture video
        if info.keys.contains(.mediaURL), let recordedVideoUrl = (info[.mediaURL] as? URL)?.absoluteURL {
            
            let avPlayer = AVPlayer(url: recordedVideoUrl)
            
            let avPlayerController = AVPlayerViewController()
            avPlayerController.player = avPlayer
            
            present(avPlayerController, animated: true) {
                
                avPlayerController.player?.play()   
            }
        }
    }
}
