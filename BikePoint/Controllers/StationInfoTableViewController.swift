
import UIKit
import SVProgressHUD
import ChameleonFramework
import CoreLocation

class StationInfoTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var mapViewController: MapViewController?
    
    var currentLocation: CLLocation?
    
    var stationsInfo: StationsInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        requestStationInfo()
        
        LocationManager.shared.addObserver(self, forKeyPath: "currentLocation",
                                           options: [.new], context: nil)
        
        mapViewController = tabBarController?.viewControllers?.first as? MapViewController
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    //MARK: - Observing
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "currentLocation" {
            
            if let currentLocation = change?[.newKey] {
                
                self.currentLocation = currentLocation as? CLLocation
                
                for parkingInfo in (stationsInfo?.parkingInfo)! {
                
                    var distance = (currentLocation as! CLLocation).distance(from: CLLocation(latitude: parkingInfo.latitude, longitude: parkingInfo.longitude))
                    
                    distance = distance / 1000
                    
                    parkingInfo.distanse = Float(distance)
                }
                
                segmentControl.setEnabled(true, forSegmentAt: 1)
                
                tableView.reloadData()
            }
        }
    }
    
    //MARK: - MyFunc
    
    func requestStationInfo() {
        
        SVProgressHUD.show()
        
        ServiceLayer.shared.getStationInfo(completion: { (stationInfo, error) in
            
            SVProgressHUD.dismiss()
            
            if let error = error {
                
                self.showAlertControllerFor(message: error)
                
            } else if let stationInfo = stationInfo  {
                
                self.stationsInfo = stationInfo
                
                self.stationsInfo?.parkingInfo.sort(by: { $0.address < $1.address })
                
                self.tableView.reloadData()
            }
        })
    }
    
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return stationsInfo != nil ? (stationsInfo?.parkingInfo.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (stationsInfo?.parkingInfo[section].distanse != nil) ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        let row = indexPath.row
        
        let parkingInfo = stationsInfo?.parkingInfo[section]
        
        if row == 0 {
        
            let identifier = "StationInfoTableViewCell"
        
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! StationInfoTableViewCell
            
            cell.adressLabel.text = parkingInfo?.address
            
            cell.countBusuSlotsLabel.text = String(describing: parkingInfo!.busySlot!)
            
            cell.countFreeSlotsLabel.text = String(describing: parkingInfo!.freeSlot!)
            
            return cell
            
        } else {
            
            let identifier = "PaveTheWayTableViewCell"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PaveTheWayTableViewCell
            
            cell.distanseLabel.text = String(format: "%.3f км", (parkingInfo?.distanse)!)
            
            cell.latitude = parkingInfo?.latitude
            
            cell.longitude = parkingInfo?.longitude
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        
        if row == 0 {
        
        
        } else {
            
            let cell = tableView.cellForRow(at: indexPath) as! PaveTheWayTableViewCell
            
            let parkingLocation = CLLocation(latitude: cell.latitude!, longitude: cell.longitude!)
            
            mapViewController?.showRouteOnMap(userLoction: currentLocation!, parkingLocation: parkingLocation)
        
            self.tabBarController?.selectedIndex = 0
            
        }
    }
    

    //MARK: - UITableViewDelegate    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.row == 0 ? 75 : 44
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        view.tintColor = UIColor.flatSkyBlue.withAlphaComponent(0.3)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 4
    }
    
    //MARK: - Actions
    
    @IBAction func actionsSegmentControl(_ sender: Any) {
        
        if segmentControl.selectedSegmentIndex == 0 {
        
            self.stationsInfo?.parkingInfo.sort(by: { $0.address < $1.address })
        
        } else {
        
            self.stationsInfo?.parkingInfo.sort(by: { $0.distanse! < $1.distanse! })
        }
       
        tableView.reloadData()
    }
}
