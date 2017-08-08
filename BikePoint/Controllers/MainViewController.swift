
import Foundation
import UIKit
import CoreLocation
import SVProgressHUD


class MainViewController: UITabBarController, UITabBarControllerDelegate {
    
    var mapViewController: MapViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.shared.locationManager?.requestWhenInUseAuthorization()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
}
