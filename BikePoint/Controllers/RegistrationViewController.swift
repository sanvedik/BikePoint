
import UIKit
import PhoneNumberKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var collectionTextField: [UITextField]!
    
    @IBOutlet var collectionActivityIndicators: [UIActivityIndicatorView]!
    
    @IBOutlet var agreementButton: UIButton!
    
    let NotificationCompleteRegistrationData = "NotificationCompleteRegistrationData"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.isScrollEnabled = false
        
        for textField in collectionTextField {
            
            textField.rightViewMode = .always
            
            textField.delegate = self
        }
        
        agreementButton.layer.cornerRadius = agreementButton.frame.size.height / 2
        
        agreementButton.isEnabled = false
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(isEnabledAgreementButton), name: NSNotification.Name(rawValue: NotificationCompleteRegistrationData), object: nil)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func isEnabledAgreementButton(notification: NSNotification) {
    
        agreementButton.isEnabled = (notification.object != nil)
    }
    
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let tag = textField.tag
        
        if tag != (collectionTextField.count - 1) {
            
            collectionTextField[tag + 1].becomeFirstResponder()
            
        } else {
            
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        var pointInScroll:CGPoint?
        
        let tag = textField.tag
        
        let originY = textField.frame.origin.y
        
        switch tag {
            
        case (0...2):
            pointInScroll = .zero
            
        case 7:
            pointInScroll = CGPoint(x: 0, y: originY - collectionTextField[3].frame.origin.y)
            
        default:
            pointInScroll = CGPoint(x: 0, y: originY - collectionTextField[2].frame.origin.y)
            
        }
        
        if tag == 3  && textField.text == "" {
            
            textField.text = "+375"
        }
        
        scrollView.setContentOffset(pointInScroll!, animated: true)
        
        scrollView.isScrollEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        scrollView.setContentOffset(.zero, animated: true)
        
        scrollView.isScrollEnabled = false
        
        switch textField.tag {
            
        case 0, 1, 2, 4, 5 : checkData(textField: textField) { text in
            
            return (text?.characters.count)! >= 2 ? true : false
            }
            
        case 3: checkData(textField: textField) { text in
            
            return (text?.characters.count)! == 17 ? true : false
            }
            
        case 6, 7: checkData(textField: textField) { text in
            
            return (text?.characters.count)! >= 8 ? true : false
            }
            
        default: break
            
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let candidateText = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
        
        let countCharacters = candidateText.characters.count
        
        if textField.tag == 3 {
            
            if countCharacters > 3 && countCharacters <= 17 {
                
                textField.text = PartialFormatter().formatPartial(candidateText)
            }
            
            return false
            
        } else {
            
            return true
        }
    }
    
    // MARK - MyFunc
    
    func checkData(textField: UITextField, textOptions: (String?) -> Bool) {
        
        let keys = ["surname", "name", "patronymic", "phone", "email", "login", "password", "checkPassword"]
        
        let sessionData = SessionData.shared

        let serviceLayer = ServiceLayer.shared

        let tag = textField.tag
        
        var text = textField.text
        
        let key = keys[tag]

        sessionData.editRegistrationData[key] = ""

        switch tag {
            
        case (0...2) where textOptions(text):
            
            sessionData.editRegistrationData[key] = text
            
            textField.rightView = UIImageView(image: #imageLiteral(resourceName: "okImage"))
            
        case (3...5) where textOptions(text):
            
            let location = [ 3 : 2, 4 : 0, 5 : 1 ]
            
            if tag == 3 {
                
                text = String().parsPhone(number: text!)
            }
            
            sessionData.editRegistrationData[key] = text
            
            collectionActivityIndicators[tag - 3].startAnimating()
            
            serviceLayer.checkRegData { (available, error) in
                
                self.collectionActivityIndicators[tag - 3].stopAnimating()
                
                if let error = error {
                
                    self.showAlertControllerFor(message: error)
                    
                } else  if (available?[location[tag]!])! {
                    
                    textField.rightView = UIImageView(image: #imageLiteral(resourceName: "okImage"))
                    
                } else {
                    
                    sessionData.editRegistrationData[key] = ""
                    
                    textField.rightView = UIImageView(image: #imageLiteral(resourceName: "cancelImage"))
                }
            }
            
        case (6...7) where textOptions(text):
            
            if tag == 6 {
                
                sessionData.editRegistrationData[key] = text
                
                textField.rightView = UIImageView(image: #imageLiteral(resourceName: "okImage"))
                
            } else if text == collectionTextField[6].text {
                
                sessionData.editRegistrationData[key] = text
                
                textField.rightView = UIImageView(image: #imageLiteral(resourceName: "okImage"))
                    
            } else {
                    
                fallthrough
            }
            
        case _ where !textOptions(text) && (text?.characters.count)! > 0:
            
            textField.rightView = UIImageView(image: #imageLiteral(resourceName: "cancelImage"))
            
        default:
            
            textField.rightView = nil
            
        }
    }
}
