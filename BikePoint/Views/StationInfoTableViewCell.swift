
import UIKit

class StationInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var adressLabel: UILabel!
    
    @IBOutlet weak var countBusuSlotsLabel: UILabel!
    
    @IBOutlet weak var countFreeSlotsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
