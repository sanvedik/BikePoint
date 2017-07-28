
import Foundation
import SVProgressHUD

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
    
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
}

extension Array {
    
    func checkForComplete(array: Array) -> Bool {
        
        var bool = true
        
        for i in array {
            
            if String(describing: i) == "" {
                
                bool = false
            }
        }
        
        return bool
    }
}
