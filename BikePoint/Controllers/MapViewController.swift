
import UIKit
import MapKit
import CoreLocation
import SVProgressHUD

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var delegate: StationInfoDelegate?
    
    let menager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        menager.delegate = self
        
        menager.desiredAccuracy = kCLLocationAccuracyBest
        
        menager.requestWhenInUseAuthorization()
        
        menager.startUpdatingLocation()
        
        
        if delegate?.stationInfo != nil {
        
            installAnnotation()
            
        } else {
        
            delegate?.requestStationInfo()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(installAnnotation), name:successfulReceptionStationInfo, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        let spean = MKCoordinateSpanMake(0.1, 0.1)
        
        let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,
                                              location.coordinate.longitude)
        
        let region = MKCoordinateRegionMake(myLocation, spean)
        
        mapView.setRegion(region, animated: true)
        
        mapView.showsUserLocation = true
        
    }
    
    // MARK: - MyFunc
    
    func installAnnotation() {
        
        let addresses = delegate?.stationInfo?.addresses
        
        let latitudes = delegate?.stationInfo?.latitudes
        
        let longitudes = delegate?.stationInfo?.longitudes
        
        for number in  0 ... ((addresses?.count)! - 1) {
        
            let coordinate = CLLocationCoordinate2D(latitude: (latitudes?[number])!,
                                                    longitude: (longitudes?[number])!)
            
            let title = addresses?[number]
            
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
    
//    func showRouteOnMap() {
//        if arrayAnotation.count < 2 {
//            return
//        }
//        
//        let request = MKDirectionsRequest()
//        
//        request.source = MKMapItem(placemark: MKPlacemark(coordinate: (arrayAnotation[0].coordinate), addressDictionary: nil))
//        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: (arrayAnotation[5].coordinate), addressDictionary: nil))
//        
//        request.requestsAlternateRoutes = true
//        request.transportType = .walking
//        
//        let directions = MKDirections(request: request)
//        
//        directions.calculate { [unowned self] response, error in
//            guard let unwrappedResponse = response else { return }
//            
//            if (unwrappedResponse.routes.count > 0) {
//                self.mapView.add(unwrappedResponse.routes[0].polyline)
//                self.mapView.setVisibleMapRect(unwrappedResponse.routes[0].polyline.boundingMapRect, animated: true)
//            }
//        }
//    }
//    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//       
//            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
//            polylineRenderer.strokeColor = UIColor.blue
//            polylineRenderer.lineWidth = 5
//            return polylineRenderer
//        
//    }
    
    //MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "pin"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            annotationView?.image = (annotation as! Annotation).image
            
            annotationView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            
            annotationView?.canShowCallout = true
            
            let button = UIButton(type: .detailDisclosure)
            
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
}
