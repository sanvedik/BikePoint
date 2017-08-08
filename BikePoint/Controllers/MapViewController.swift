
import UIKit
import MapKit
import SVProgressHUD
import CoreLocation


class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var stationsInfo: StationsInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        requestStationInfo()
        
        LocationManager.shared.addObserver(self, forKeyPath: "currentLocation",
                                                     options: [.new], context: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - Observing 
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "currentLocation" {
            
            if ((change?[.newKey]) != nil) {
            
                mapView.showsUserLocation = true
                
            } else {
            
                mapView.showsUserLocation = false
            }
        }
    }
    
    // MARK: - MyFunc
    
    func requestStationInfo() {
        
        SVProgressHUD.show()
        
        ServiceLayer.shared.getStationInfo(completion: { (stationsInfo, error) in
            
            SVProgressHUD.dismiss()
            
            if let error = error {
                
                self.showAlertControllerFor(message: error)
                
            } else if let stationInfo = stationsInfo  {
                
                self.stationsInfo = stationInfo
                
                self.installAnnotation()
            }
        })
    }
    
    func installAnnotation() {
        
        for parkingInfo in (stationsInfo?.parkingInfo)! {
            
            let coordinate = CLLocationCoordinate2D(latitude: parkingInfo.latitude,
                                                    longitude: parkingInfo.longitude)
            
            let title = parkingInfo.address
            
            let annotation = Annotation(coordinate: coordinate, title: title, subtitle: nil)
            
            mapView.addAnnotation(annotation)
            
            zoomAnnotation()
        }
    }
    
    func zoomAnnotation() {
        
        var zoomRect = MKMapRectNull
        
        for annotation in mapView.annotations {
            
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            
            let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
            
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
        
        mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10) , animated: true)
    }
    
    func showRouteOnMap(userLoction: CLLocation, parkingLocation: CLLocation) {
        
        let request = MKDirectionsRequest()
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLoction.coordinate, addressDictionary: nil))
        
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: parkingLocation.coordinate, addressDictionary: nil))
        
        request.requestsAlternateRoutes = true
        
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            if (unwrappedResponse.routes.count > 0) {
                self.mapView.add(unwrappedResponse.routes[0].polyline)
                self.mapView.setVisibleMapRect(unwrappedResponse.routes[0].polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        
    }

    //MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKind(of: MKUserLocation.self) {
            
            return nil
        }
        
        let identifier = "pin"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            annotationView?.image = (annotation as! Annotation).image
            
            annotationView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            
            annotationView?.canShowCallout = true
            
            let button = UIButton(type: .detailDisclosure)
            
            button.addTarget(self, action: #selector(actionAnnotationButton(sender:)), for: .touchUpInside)
            
            annotationView?.rightCalloutAccessoryView = button
            
        } else {
            
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    
    //MARK: - Actions
    
    @IBAction func actionZoomButton(_ sender: Any) {
        
        zoomAnnotation()
    }
    
    func actionAnnotationButton(sender: UIButton) {
        
//        let annotationView = sender.superAnnotationView()
        
        self.tabBarController?.selectedIndex = 1
        
    }
}
