//
//  ViewController.swift
//  DemoMapApp
//
//  Created by Mohamed on 9/2/19.
//  Copyright © 2019 Mohamed74. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var segmentedControll: UISegmentedControl!
    
    // define MKMapView component
    
    @IBOutlet weak var mapView: MKMapView!
    
    // Mark:- make constant from CLLocationManger class to start use map services
    
    fileprivate let locationManger = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControll.selectedSegmentIndex = 0
        //Mark:- conform locationManger delegate
        locationManger.delegate = self
        
        //Mark:- must conform MKMapView
        mapView.delegate = self
        
        // request authorization while app in foregrounf
        locationManger.requestWhenInUseAuthorization()
        
        // accuracy of location data
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManger.distanceFilter = kCLDistanceFilterNone
        
        // update user location
        locationManger.startUpdatingLocation()
        
        // show user location on the map by blue point
        mapView.showsUserLocation = true
    
        focusOnUserOnTheMap()
        
        segmentedControll.addTarget(self, action: #selector(changeMapViewType), for: .valueChanged)
        
    }
    
   
    
    func focusOnUserOnTheMap(){
        
        if let location = locationManger.location?.coordinate{
            
            let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let region = MKCoordinateRegion(center: center , latitudinalMeters: 10000, longitudinalMeters: 10000)
            
            mapView.setRegion(region, animated: true)
            
        }
        
    }
    
    @objc func changeMapViewType(){
        
        if segmentedControll.selectedSegmentIndex == 0 {
            
            mapView.mapType = .standard
        }else if segmentedControll.selectedSegmentIndex == 1 {
            
            mapView.mapType = .satellite
        }else{
            
            mapView.mapType = .hybrid
        }
        
    }


}

// extension to use CLLocationMangerDelegate

extension ViewController : CLLocationManagerDelegate {
    
    //Mark:- optional method to update user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    //Mark:- authoraization change
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
}
extension ViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        
        let center = CLLocationCoordinate2D(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        
        let region  = MKCoordinateRegion(center: center, latitudinalMeters: 10, longitudinalMeters: 10)
        
        mapView.setRegion(region, animated: true)
    }
    
}
