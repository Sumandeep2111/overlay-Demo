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
       addPolyLine()
        addPloygon()
    }

    func addAnnotation(){
        mapView.delegate = self
        mapView.addAnnotations(places)
        
        let overlays = places.map { (MKCircle(center: $0.coordinate, radius: 1000)) }
        mapView.addOverlays(overlays)
    }
   // adding line b/w current and last location
    func addPolyLine(){
        let locations = places.map {$0.coordinate}
        let polyline = MKPolyline(coordinates: locations, count: locations.count)
        mapView.addOverlay(polyline)
    }
    
    func addPloygon(){
        let locations = places.map {$0.coordinate}
        let polygon = MKPolygon(coordinates: locations, count: locations.count)
        mapView.addOverlay(polygon)
    }

}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "ic_place_2x")
            // show more information
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return annotationView
        }
    }
    // this function is needed to add overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle{
            let render = MKCircleRenderer(overlay: overlay)
            render.fillColor = UIColor.black.withAlphaComponent(0.5)
            render.strokeColor = UIColor.green
            render.lineWidth = 2
            return render
       }
            else if overlay is MKPolyline {
            let rendrer = MKPolylineRenderer(overlay: overlay)
            rendrer.strokeColor = UIColor.blue
            rendrer.lineWidth = 10
            return rendrer
        }
        else if overlay is MKPolygon {
            let rendrer = MKPolygonRenderer(overlay: overlay)
            rendrer.strokeColor = UIColor.red
            rendrer.lineWidth = 2
            rendrer.fillColor = UIColor.black.withAlphaComponent(0.5)
            return rendrer
        }
        return MKOverlayRenderer()
    }
    
}
