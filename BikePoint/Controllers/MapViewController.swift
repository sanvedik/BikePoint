
import UIKit
import MapKit
import SVProgressHUD

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var stationInfo: StationInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       requestStationInfo()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // MARK: - MyFunc
    
    func requestStationInfo() {
        
       
            
        SVProgressHUD.show()
        
        
        ServiceLayer.shared.getStationInfo(completion: { (stationInfo, error) in
            
          
                
                SVProgressHUD.dismiss()
            
            
            if let error = error {
                
                self.showAlertControllerFor(message: error)
                
            } else if let stationInfo = stationInfo  {
                
                self.stationInfo = stationInfo
                
            }
        })
    }
    
    
//    func installAnnotation() {
//        
//        let addresses = delegate?.stationInfo?.addresses
//        
//        let latitudes = delegate?.stationInfo?.latitudes
//        
//        let longitudes = delegate?.stationInfo?.longitudes
//        
//        for number in  0 ... ((addresses?.count)! - 1) {
//        
//            let coordinate = CLLocationCoordinate2D(latitude: (latitudes?[number])!,
//                                                    longitude: (longitudes?[number])!)
//            
//            let title = addresses?[number]
//            
//            let annotation = Annotation(coordinate: coordinate, title: title, subtitle: nil)
//            
//            mapView.addAnnotation(annotation)
//            
//            zoomAnnotation()
//        }
//    }
    
    func zoomAnnotation() {
        
        var zoomRect = MKMapRectNull
        
        for annotation in mapView.annotations {
            
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            
            let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
            
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
        
        mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10) , animated: true)
    }
    

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
            
            button.addTarget(self, action: #selector(actionAnnotationButton(sender:)), for: .touchUpInside)
            
            annotationView?.rightCalloutAccessoryView = button
            
        } else {
            
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    
    //MARK: - Actions
    
//    @IBAction func actionZoomButton(_ sender: Any) {
//        
//        zoomAnnotation()
//    }
    
    func actionAnnotationButton(sender: UIButton) {
        
        let annotationView = sender.superAnnotationView()
        
        
        
    }
}
