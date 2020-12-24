//
//  MapViewController.swift
//  Tweet
//
//  Created by Maiqui Cedeño on 14/12/20.
//  Copyright © 2020 Poseto Studio. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var mapContainer: UIView!
    
    //MARK: - Properties
    var post = [Post]()
    private var map: MKMapView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupMap()
    }
    
    //MARK: - Private Methods
    private func setupMap() {
        
        map = MKMapView(frame: mapContainer.bounds)
        
        //UIView() is an empty view
        mapContainer?.addSubview(map ?? UIView())
        
        setupMarkers()
        
    }
    
    private func setupMarkers() {
        
        post.forEach { item in
            
            let marker = MKPointAnnotation()
            marker.coordinate = CLLocationCoordinate2D(latitude: item.location.latitude, longitude: item.location.longitude)
            
            marker.title = item.text
            marker.subtitle = item.author.names
            
            map?.addAnnotation(marker)
            
            //Initial position map.
            guard let lastPost = post.first else {
                return
            }
            
            let lastPostLocation = CLLocationCoordinate2D(latitude: lastPost.location.latitude, longitude: lastPost.location.longitude)
            
            guard let heading = CLLocationDirection(exactly: 12) else {
                return
            }
            
        
            map?.camera = MKMapCamera(lookingAtCenter: lastPostLocation, fromDistance: 100000, pitch: .zero, heading: heading)
        }
    }
    
}
