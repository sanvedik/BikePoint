
import UIKit

class PaveTheWayTableViewCell: UITableViewCell {

    @IBOutlet weak var distanseLabel: UILabel!
    
    var latitude: Double?
    
    var longitude: Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
