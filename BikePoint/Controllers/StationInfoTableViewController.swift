
import UIKit
import SVProgressHUD
import ChameleonFramework

class StationInfoTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: StationInfoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        if delegate?.stationInfo != nil {
            
            tableView.reloadData()
            
        } else {
            
            delegate?.requestStationInfo()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(tableView.reloadData), name:successfulReceptionStationInfo, object: nil)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return delegate!.stationInfo?.addresses.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        let row = indexPath.row
        
        if row == 0 {
        
            let identifier = "StationInfoTableViewCell"
        
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! StationInfoTableViewCell
        
            cell.adressLabel.text = delegate?.stationInfo?.addresses[section]
        
            cell.countBusuSlotsLabel.text = String(describing: delegate!.stationInfo!.busyClots[section])
        
            cell.countFreeSlotsLabel.text = String(describing: delegate!.stationInfo!.freeSlots[section])
            
            return cell
            
        } else {
        
            let identifier = "PaveTheWayTableViewCell"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            
            return cell
        }
    }
    

    //MARK: - UITableViewDelegate    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.row == 0 ? 75 : 33
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        view.tintColor = UIColor.flatSkyBlue.withAlphaComponent(0.3)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 8
    }
    
    
}
