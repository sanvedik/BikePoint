
import Foundation
import SVProgressHUD
import MapKit

extension String {
    
    func parsPhone(number: String) -> String {
        
        let set = NSCharacterSet.decimalDigits.inverted
        
        let componentsStrng = number.components(separatedBy: set)
        
        return "+" + (componentsStrng.joined(separator: ""))
    }
}

extension UIViewController {
    
    func showAlertControllerFor(message: Errors) {
        
        SVProgressHUD.dismiss()
        
        let controller = UIAlertController(title: message.title, message: message.message , preferredStyle: .alert)
        
        let exitAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        
        controller.addAction(exitAction)
        
        present(controller, animated: true, completion: nil)
        
    }
}


extension UIViewController {
    
    func showAlertControllerFor(message: Messages) {
        
        SVProgressHUD.dismiss()
        
        let controller = UIAlertController(title: nil, message: message.message , preferredStyle: .alert)
        
        let exitAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        
        controller.addAction(exitAction)
        
        present(controller, animated: true, completion: nil)
        
    }
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
}

extension UIStoryboard {
    
    open class var signIn: UIStoryboard {
        get {
            return UIStoryboard(name: "SignIn", bundle: nil)
        }
    }
    
    open class var main: UIStoryboard {
        get {
            return UIStoryboard(name: "Main", bundle: nil)
        }
    }
}

extension UIViewController {
    
    static func topViewController() -> UIViewController? {
        
        var topViewController = UIApplication.shared.keyWindow?.rootViewController!
        
        while topViewController?.presentedViewController != nil {
            
            topViewController = topViewController?.presentedViewController
        }
        return topViewController
    }
}

extension UIView {
    
    func superAnnotationView() -> MKAnnotationView? {
        
        if (self.superview?.isKind(of: MKAnnotationView.self))!  {
        
            return self.superview as? MKAnnotationView
        }
        
        if (self.superview == nil) {
        
            return nil
        }
        
        return self.superview?.superAnnotationView()
    }
}


