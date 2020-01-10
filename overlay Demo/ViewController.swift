//
//  ViewController.swift
//  overlay Demo
//
//  Created by MacStudent on 2020-01-10.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController ,CLLocationManagerDelegate {
    
 var locationManager = CLLocationManager()
    // get data from plist places
    let places = Place.getPlaces()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
   //     locationManager.startUpdatingLocation()
        addAnnotation()
    }

    func addAnnotation(){
        mapView.delegate = self
        mapView.addAnnotations(places)
        
        let overlays = places.map { (MKCircle(center: $0.coordinate, radius: 1000)) }
        mapView.addOverlays(overlays)
    }

}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "ic_place_2x")
            return annotationView
        }
    }
    // this function is needed to add overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKCircleRenderer(overlay: overlay)
        render.fillColor = UIColor.black.withAlphaComponent(0.5)
        render.strokeColor = UIColor.green
        render.lineWidth = 2
        return render
    }
}
