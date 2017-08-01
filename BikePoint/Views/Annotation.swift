
import UIKit
import MapKit

class Annotation: NSObject, MKAnnotation {
    
    var coordinate : CLLocationCoordinate2D
    
    var title: String?
    
    var subtitle: String?
    
    var image = #imageLiteral(resourceName: "pointImage")
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?){
        
        self.coordinate = coordinate
        
        self.title = title
        
        self.subtitle = subtitle
        
    }
}
