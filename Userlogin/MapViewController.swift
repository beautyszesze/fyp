//
//  MapViewController.swift
//  Userlogin
//
//  Created by Valerie Wai Sze Ng on 7/1/2020.
//  Copyright © 2020 Valerie Wai Sze Ng. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
   //timestamp
    //loop (firebaase
    //rules safety
    @IBOutlet weak var MapView: MKMapView!
    class CustomPointAnnotation: MKPointAnnotation {
           var imageName: String!
       }
    var protesterPin = CustomPointAnnotation()
    var popoPin = CustomPointAnnotation()
        var firePin = CustomPointAnnotation()
        var teargasPin = CustomPointAnnotation()
          var currentPin = CustomPointAnnotation()
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MapView.delegate = self
        MapView.showsUserLocation = true
        
        
        let protestCoordinates = CLLocationCoordinate2DMake(22.28552, 114.15769)
        protesterPin.coordinate = protestCoordinates
        protesterPin.title = "Protester"
        protesterPin.imageName = "gas-mask.png"
        MapView.addAnnotation(protesterPin)
        
        let PopoCoordinates = CLLocationCoordinate2DMake(22.28552,114.15778)
         popoPin.coordinate = PopoCoordinates
         popoPin.title = "Police"
         popoPin.imageName = "police.png"
         MapView.addAnnotation(popoPin)
        
        let fireCoordinates = CLLocationCoordinate2DMake(22.28552, 114.15787)
               firePin.coordinate = fireCoordinates
               firePin.title = "Fire"
               firePin.imageName = "7.png"
               MapView.addAnnotation(firePin)
        
        let teargasCoordinates = CLLocationCoordinate2DMake(22.28552, 114.15798)
               teargasPin.coordinate = teargasCoordinates
               teargasPin.title = "Tear Gas"
               teargasPin.imageName = "gas.png"
               MapView.addAnnotation(teargasPin)
        
        print("POLICE SET TO \(String(describing: popoPin.coordinate))")
            
            
     getCurrentLocation()
        // Do any additional setup after loading the view.
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     if !(annotation is MKPointAnnotation) {
                  print("NOT REGISTERED AS MKPOINTANNOTATION")
                  return nil
    }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pokemonIdentitfier")
               if annotationView == nil {
                   annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pokemonIdentitfier")
                   annotationView!.canShowCallout = true
               }
                   
               else {
                   annotationView!.annotation = annotation
               }
                         let cpa = annotation as! CustomPointAnnotation
          annotationView!.image = UIImage(named: cpa.imageName)
               // annotationView!.image = UIImage(named: "gas-mask.png")
               return annotationView
           
    }
    
    @IBOutlet weak var lbLocation: UILabel!
    func getCurrentLocation() {
               // Ask for Authorisation from the User.
               self.locationManager.requestAlwaysAuthorization()

               // For use in foreground
               self.locationManager.requestWhenInUseAuthorization()

               if CLLocationManager.locationServicesEnabled() {
                   locationManager.delegate = self
                   locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                   locationManager.startUpdatingLocation()
               }
           }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
              guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
              print("locations = \(locValue.latitude) \(locValue.longitude)")
          lbLocation.text = "latitude = \(locValue.latitude), longitude = \(locValue.longitude)"
       }
}
