
import Foundation
import UIKit
import SVProgressHUD

protocol StationInfoDelegate {
    
    var stationInfo: StationInfo? {get set}
    
    func requestStationInfo()
}

let successfulReceptionStationInfo = NSNotification.Name(rawValue: "successfulReceptionStationInfo")

class MainViewController: UITabBarController, StationInfoDelegate {
    
    var stationInfo: StationInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapViewController = viewControllers?.first as! MapViewController
        
        mapViewController.delegate = self
        
        let stationInfoTableViewController = viewControllers?.last as! StationInfoTableViewController
        
        stationInfoTableViewController.delegate = self
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
                
                NotificationCenter.default.post(name: successfulReceptionStationInfo, object: nil)
            }
        })
    }
}
