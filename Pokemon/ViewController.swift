//
//  ViewController.swift
//  Pokemon
//
//  Created by Apple on 7/22/17.
//  Copyright © 2017 Jeremy. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var updateCount = 0
    
    
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
       
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
            
            
        }else {
            manager.requestWhenInUseAuthorization()
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        if updateCount < 3 {
            
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 1000, 1000)
            mapView.setRegion(region, animated: false)
            
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
        
    }

    @IBAction func compassTapped(_ sender: Any) {
    }


}

