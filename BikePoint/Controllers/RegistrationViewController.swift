
import UIKit
import PhoneNumberKit

enum ListRegData: Int {
    
    case surname = 0, name, patronymic, phone, email, login, password, checkPassword, session, code
    
    var key : String {
        
        switch self {
            
        case .surname: return "surname"
        case .name: return "name"
        case .patronymic: return "patronymic"
        case .phone: return "phone"
        case .email: return "email"
        case .login: return "login"
        case .password: return "password"
        case .checkPassword: return "checkPassword"
        case .session: return "session"
        case .code: return "code"
        }
    }
}

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var collectionTextField: [UITextField]!
    
    @IBOutlet var collectionActivityIndicators: [UIActivityIndicatorView]!
    
    @IBOutlet var agreementButton: UIButton!
    
    
    var registrationData : [String : Any?] = [:] {
    
        willSet(newData) {

            if newData.values.count == 8 {
                
                agreementButton.isEnabled = true
                
            } else {
            
                agreementButton.isEnabled = false
            }
        }
    }
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
        
        let textFieldType = ListRegData(rawValue: tag)
        
        let originY = textField.frame.origin.y
        
        switch textFieldType!{
            
        case .surname, .name, .patronymic:
            pointInScroll = .zero
            
        case .checkPassword:
            pointInScroll = CGPoint(x: 0, y: originY - collectionTextField[3].frame.origin.y)
            
        default:
            pointInScroll = CGPoint(x: 0, y: originY - collectionTextField[2].frame.origin.y)
        }
        
        if textFieldType! == .phone  && textField.text == "" {
            
            textField.text = "+375"
        }
        
        scrollView.setContentOffset(pointInScroll!, animated: true)
        
        scrollView.isScrollEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        scrollView.setContentOffset(.zero, animated: true)
        
        scrollView.isScrollEnabled = false
        
        let tag = textField.tag
        
        switch ListRegData(rawValue: tag)! {
            
        case .surname, .name, .patronymic, .email, .login : checkData(textField: textField) { text in
            
            return (text?.characters.count)! >= 2 ? true : false
            }
            
        case .phone : checkData(textField: textField) { text in
            
            return (text?.characters.count)! == 17 ? true : false
            }
            
        case .password, .checkPassword : checkData(textField: textField) { text in
            
            return (text?.characters.count)! >= 8 ? true : false
            }
            
        default: break
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let candidateText = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
        
        let countCharacters = candidateText.characters.count
        
        let tag = textField.tag
        
        if ListRegData(rawValue: tag)! == .phone {
            
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
        
        let serviceLayer = ServiceLayer.shared
        
        let tag = textField.tag
        
        var text = textField.text
        
        let textFieldType = ListRegData(rawValue: tag)
        
        let key = ListRegData(rawValue: tag)?.key
        
        registrationData[key!] = nil
        
        switch textFieldType! {

        case .surname where textOptions(text),
             .name where textOptions(text),
             .patronymic where textOptions(text):
            
            registrationData[key!] = text
            
            textField.rightView = UIImageView(image: #imageLiteral(resourceName: "okImage"))
            
        case .phone where textOptions(text),
             .email where textOptions(text),
             .login where textOptions(text):
            
            let location  = [ ListRegData.phone : 2, ListRegData.email : 0, ListRegData.login : 1 ]
            
            registrationData[key!] = text
            
            collectionActivityIndicators[tag - 3].startAnimating()
            
            serviceLayer.checkRegData(email: ((view.viewWithTag(ListRegData.email.rawValue) as? UITextField)?.text)!,
                                      login: ((view.viewWithTag(ListRegData.login.rawValue) as? UITextField)?.text)!,
                                      phone: ((view.viewWithTag(ListRegData.phone.rawValue) as? UITextField)?.text)!,
                                      completion: { (available, error) in
                                        
                                        self.collectionActivityIndicators[tag - 3].stopAnimating()
                                        
                                        let position = location[textFieldType!]
                                        
                                        if let error = error {
                                            
                                            self.showAlertControllerFor(message: error)
                                            
                                        } else  if (available?[position!])! {
                                            
                                            textField.rightView = UIImageView(image: #imageLiteral(resourceName: "okImage"))
                                            
                                        } else {
                                            
                                            self.registrationData[key!] = nil
                                            
                                            textField.rightView = UIImageView(image: #imageLiteral(resourceName: "cancelImage"))
                                        }
            })
            
        case .password where textOptions(text),
             .checkPassword where textOptions(text):
            
            if (textFieldType!) == .password {
                
                registrationData[key!] = text
                
                textField.rightView = UIImageView(image: #imageLiteral(resourceName: "okImage"))
                
            } else if text == collectionTextField[ListRegData.password.rawValue].text {
                
                registrationData[key!] = text
                
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
    
    //MARK: - Seque
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ContractViewController" {
        
            let contractViewController = segue.destination as! ContractViewController
            
            contractViewController.registrationData = self.registrationData
        }
    }
}
