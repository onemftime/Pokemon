//
//  ViewController.swift
//  Pokemon
//
//  Created by Apple on 7/22/17.
//  Copyright © 2017 Jeremy. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var updateCount = 0
    
    
    var manager = CLLocationManager()
    

    
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            setUP()
            
        }else {
            manager.requestWhenInUseAuthorization()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            
            setUP()
            
        }
    }
    
    func setUP() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            
            let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
            if let coord = self.manager.location?.coordinate {
                let anno = PokeAnnotation(coord: coord, pokemon: pokemon)
                let randoLat = (Double (arc4random_uniform(200)) - 100.0)/50000.0
                let randoLon = (Double (arc4random_uniform(200)) - 100.0)/50000.0
                anno.coordinate.latitude += randoLat
                anno.coordinate.longitude += randoLon
                self.mapView.addAnnotation(anno)
            }
        })
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annoView.image = UIImage(named: "player")
            
            var frame = annoView.frame
            frame.size.height = 50
            frame.size.width = 50
            annoView.frame = frame
            
            return annoView        }
        
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        let pokemon = (annotation as! PokeAnnotation).pokemon
        annoView.image = UIImage(named: pokemon.image!)
        
        var frame = annoView.frame
        frame.size.height = 50
        frame.size.width = 50
        annoView.frame = frame
        
        return annoView
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        if view.annotation! is MKUserLocation {
            return
        }
        
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {(timer) in
            
            
            if let coord = self.manager.location?.coordinate {
                
              let pokemon = (view.annotation as! PokeAnnotation).pokemon
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    
                    pokemon.caught = true
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    mapView.removeAnnotation(view.annotation!)
                    
                    
                    
                    let alertVC = UIAlertController(title: "Congrats", message: "You caught a \(String(describing: pokemon.name!))", preferredStyle: .alert)
                    
                    let pokeDexAction = UIAlertAction(title: "PokeDex", style: .default, handler:{(action) in
                        self.performSegue(withIdentifier: "pokeDex", sender: nil)
                      })
                    
                    alertVC.addAction(pokeDexAction)
                    self.present(alertVC, animated: true, completion: nil)
                    let OKaction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertVC.addAction(OKaction)
                
                
            }else {
                    let alertVC = UIAlertController(title: "Uh Oh", message: "You're too far away. Move closer to catch \(String(describing: pokemon.name))", preferredStyle: .alert)
                    
                    let OKaction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                }
        
       
                
            }
        }
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if updateCount < 3 {
            
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200, 200)
            mapView.setRegion(region, animated: false)
            
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
        
    }
    
    @IBAction func compassTapped(_ sender: Any) {
        
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
            mapView.setRegion(region, animated: true)
            
        }
    }
    
    
}


