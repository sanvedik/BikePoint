
import Foundation
import UIKit
import SVProgressHUD
import CoreLocation

protocol StationInfoDelegate {
    
    var stationInfo: StationInfo? {get set}
    
    func requestStationInfo()
}

protocol UserLocationInfoDelegete {

    var userLocation: CLLocation? {get set}
    
    func openLocation()
}



class MainViewController: UITabBarController, StationInfoDelegate, UserLocationInfoDelegete, CLLocationManagerDelegate {
    
    var stationInfo: StationInfo?
    
    
    var locationAuthorizationStatus: Bool?
    
    var userLocation: CLLocation?
    
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapViewController = viewControllers?.first
            as! MapViewController
        
        let stationInfoTableViewController = viewControllers?.last
            as! StationInfoTableViewController
        
//        mapViewController.delegate = self
        stationInfoTableViewController.delegate = self
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.distanceFilter = 10
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    //MARK: - StationInfoDelegate 
    
    func requestStationInfo() {
        
        if (stationInfo == nil) {
        
            SVProgressHUD.show()
        }
        
        ServiceLayer.shared.getStationInfo(completion: { (stationInfo, error) in
            
            if SVProgressHUD.isVisible() {
            
                SVProgressHUD.dismiss()
            }
            
            if let error = error {
                
                self.showAlertControllerFor(message: error)
                
            } else if let stationInfo = stationInfo  {
                
                self.stationInfo = stationInfo
                
            }
        })
    }
    
    func openLocation() {
    
        locationManager.requestWhenInUseAuthorization()
    }
    
    //MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .authorizedAlways, .authorizedWhenInUse:
            
            locationManager.startUpdatingLocation()
            
            locationAuthorizationStatus = true
            
        default:
            
            locationManager.stopUpdatingLocation()
            
            locationAuthorizationStatus = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        self.showAlertControllerFor(message: .locationFailed)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations[locations.count - 1]
        
    }
}
