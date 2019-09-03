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
    
    fileprivate func addAnotationOfPoint(){
    
        let annotation = MKPointAnnotation()
       // annotation.coordinate = CLLocationCoordinate2D(latitude: 30.7326622, longitude: 31.7195459)
       annotation.title = "iOS developers"
        annotation.subtitle = "learning iOS"
        annotation.coordinate = mapView.userLocation.coordinate
        mapView.addAnnotation(annotation)
    
    }
   
    
    fileprivate func focusOnUserOnTheMap(){
        
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
    
    fileprivate func setUpAnnotationSnapShot(annotation:MKAnnotationView){
        
        let options = MKMapSnapshotter.Options()
        options.size = CGSize(width: 200, height: 200)
        options.mapType = .satelliteFlyover
        
        let center  = annotation.annotation?.coordinate
        
        options.camera = MKMapCamera(lookingAtCenter: center!, fromDistance: 150, pitch: 60, heading: 0)
      
        let snapShotter = MKMapSnapshotter(options: options)
        
        snapShotter.start { (snapShotter, err) in
            
            if let err = err{
                
                print(err.localizedDescription)
            }
            
            if let snapShot = snapShotter{
                
                let snapImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
                
                snapImage.image = snapShot.image
                
                annotation.detailCalloutAccessoryView = snapImage
            }
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        
        let center = CLLocationCoordinate2D(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        
        let region  = MKCoordinateRegion(center: center, latitudinalMeters: 10, longitudinalMeters: 10)
        
        mapView.setRegion(region, animated: true)
        addAnotationOfPoint()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {return nil}
        
        let marker  = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        
        marker.glyphText = "Learn iOS"
        marker.canShowCallout = true
        marker.leftCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "pin"))
        marker.rightCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "chevron"))
        
        setUpAnnotationSnapShot(annotation: marker)
        return marker
    }
    
}
