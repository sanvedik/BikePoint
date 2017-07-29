
import UIKit
import ChameleonFramework

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = navigationBar.bounds.insetBy(dx: 0.0, dy: -10.0).offsetBy(dx: 0, dy: -10)
        
        let colors = [UIColor.flatBlue, UIColor.flatBlueDark]
        
        navigationBar.barTintColor = UIColor(gradientStyle: .topToBottom, withFrame: frame, andColors: colors)
        
        navigationBar.tintColor = UIColor.white
        
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
