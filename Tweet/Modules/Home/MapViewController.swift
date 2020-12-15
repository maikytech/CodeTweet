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
    var map: MKMapView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
    }
    
    func setupMap() {
        
        map = MKMapView(frame: mapContainer!.bounds)
        
        //UIView() is an empty view
        mapContainer?.addSubview(map ?? UIView())
        
        
        
        
    }
}
