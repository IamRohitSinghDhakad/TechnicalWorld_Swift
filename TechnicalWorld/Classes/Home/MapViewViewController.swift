//
//  MapViewViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 12/04/21.
//

import UIKit
import MapKit
import CoreLocation

protocol GetLocationDelegate {

    func getSelectedLocation(dictLocation: [String:Any]) // used in file option
    
}

class MapViewViewController: UIViewController {
    
    @IBOutlet weak var MapKitView: MKMapView!
    @IBOutlet weak var lblLocation: UILabel!
    
    var locationManager:CLLocationManager!
    var latitude = ""
    var longitude = ""
    
    var delegateOfLocation: GetLocationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationSetup()
    }
    
    func locationSetup(){
        locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()

            if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
            }
    }
    

    @IBAction func btnOnContinue(_ sender: Any) {
        
        var dict = [String:Any]()
        dict["latitude"] = self.latitude
        dict["longitude"] = self.longitude
        dict["Address"] = self.lblLocation.text
        
        self.delegateOfLocation?.getSelectedLocation(dictLocation: dict)
        
        onBackPressed()
    }
    

}

extension MapViewViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation

        self.locationManager.stopUpdatingLocation()
        
        self.latitude = "\(userLocation.coordinate.latitude)"
        self.longitude = "\(userLocation.coordinate.longitude)"
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                self.lblLocation.text = "Current Location not detected."
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality ?? "")
                print(placemark.administrativeArea ?? "")
                print(placemark.country ?? "")

                self.lblLocation.text = "\(placemark.locality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.country ?? "")"
               
                
            }
        }

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}
