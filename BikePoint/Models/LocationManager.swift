
import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    var locationManager: CLLocationManager!
    
    var currentLocation: CLLocation? {
        
        willSet {
            
            willChangeValue(forKey: "currentLocation")
        }
        
        didSet {
            
            didChangeValue(forKey: "currentLocation")
        }
    }
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager?.distanceFilter = 10
        
        locationManager?.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .authorizedAlways, .authorizedWhenInUse:
            
            locationManager?.startUpdatingLocation()
            
        default:
            
            locationManager?.stopUpdatingLocation()
            
            currentLocation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
     
        print("ERROR LOCATION: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        currentLocation = location
    }
}
