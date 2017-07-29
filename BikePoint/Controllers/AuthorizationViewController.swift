
import UIKit
import SVProgressHUD
import PhoneNumberKit

enum ListAutData: Int {
    
    case login = 0, password, loginForRestore, phoneForRestore
    
    var key : String {
        
        switch self {
            
        case .login: return "login"
        case .password: return "password"
        case .loginForRestore: return "loginForRestore"
        case .phoneForRestore: return "phoneForRestore"
        }
    }
}


class AuthorizationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    
    @IBOutlet fileprivate var collectionTextFields: [UITextField]!
    
    @IBOutlet fileprivate weak var signInButton: UIButton!
    
    @IBOutlet fileprivate weak var registrationButton: UIButton!
    
    @IBOutlet fileprivate weak var restorePasswordButton: UIButton!
    
    fileprivate let serviceLayer = ServiceLayer.shared
    
    fileprivate var alertController: UIAlertController?
    
    var authorizationData : [String : Any?] = [:] {
        
        willSet(newData) {
            
            if newData.values.count == 2 {
            
                signInButton.isEnabled = true
                
            } else {
            
                signInButton.isEnabled = false
            }
        }
    }
    
    var restorePasswordData : [String : Any?] = [:] {
    
        willSet(newData) {
            
            if newData.values.count == 2 {
                
                alertController?.actions.last?.isEnabled = true
                
            } else {
                
                alertController?.actions.last?.isEnabled = false
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionTextFields.first?.delegate = self
        collectionTextFields.last?.delegate = self
        
        collectionTextFields.last?.rightViewMode = .always
        collectionTextFields.first?.rightViewMode = .always
        
        scrollView.isScrollEnabled = false
        
        self.hideKeyboardWhenTappedAround()
        
        signInButton.layer.cornerRadius = signInButton.frame.height / 2
        
        signInButton.isEnabled = false
        
        registrationButton.layer.cornerRadius = registrationButton.frame.height / 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let tag = textField.tag
        
        switch tag {
            
        case ListAutData.login.rawValue:
            collectionTextFields[ListAutData.password.rawValue].becomeFirstResponder()
            
        case ListAutData.password.rawValue:
            textField.resignFirstResponder()
            
        case ListAutData.loginForRestore.rawValue:
            alertController?.textFields?.first(where: { $0.tag == 3 })?.becomeFirstResponder()
            return false
            
        case ListAutData.phoneForRestore.rawValue:
            textField.resignFirstResponder()
            
        default:break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        scrollView.isScrollEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        scrollView.isScrollEnabled = false
        
        scrollView.setContentOffset(.zero, animated: true)
        
        let tag = textField.tag
        
        switch ListAutData(rawValue: tag)! {
            
        case .login, .loginForRestore: checkData(textField: textField) { text in
            
            return (text?.characters.count)! >= 2 ? true : false
            }
            
        case .password: checkData(textField: textField) { text in
            
            return (text?.characters.count)! >= 8 ? true : false
            }
            
        case .phoneForRestore: checkData(textField: textField) { text in
            
            return (text?.characters.count)! == 17  ? true : false
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let candidateText = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
        
        let countCharacters = candidateText.characters.count
        
        let tag = textField.tag
        
        if ListAutData(rawValue: tag)! == .phoneForRestore {
            
            if countCharacters > 3 && countCharacters <= 17 {
                
                textField.text = PartialFormatter().formatPartial(candidateText)
            }
            
            return false
            
        } else {
            
            return true
        }
    }
    
    
    //MARK: - MyFunc
    
    func showAlertControllerForResstorePassword() {
        
        alertController =
            UIAlertController(title: "Востановление пароля.",
                              message: "Пожалуйста введите необходимые данные и мы вышлем Вам новый пароль.",
                              preferredStyle: .alert)
        
        guard let alertController = alertController else {
            return
        }
        
        alertController.addTextField(configurationHandler: { textField in
            
            textField.placeholder = "Введите логин"
            textField.tag = ListAutData.loginForRestore.rawValue
            textField.rightViewMode = .always
            textField.delegate = self
            
        })
        
        alertController.addTextField(configurationHandler: { textField in
            
            textField.placeholder = "Введите телефон"
            textField.text = "+375"
            textField.tag = ListAutData.phoneForRestore.rawValue
            textField.rightViewMode = .always
            textField.delegate = self
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { [unowned self] action in
            
            SVProgressHUD.show(withStatus: "Подождите пожалуйста, Bike Point востанавливает пароль")
            
            self.serviceLayer.restorePassword(
                login: (alertController.textFields?[ListAutData.loginForRestore.rawValue].text)!,
                phone: (alertController.textFields?[ListAutData.phoneForRestore.rawValue].text)!,
                completion: { error in
                    
                    if let error = error {
                        
                        self.showAlertControllerFor(message: error)
                    }
            })
        })
        
        
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        
        alertController.actions.last?.isEnabled = false
            
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkData(textField: UITextField, textOptions: (String?) -> Bool) {
        
        let tag = textField.tag
        
        let text = textField.text
        
        switch ListAutData(rawValue: tag)! {
            
        case .login where textOptions(text) ,
             .password where textOptions(text):
            
            authorizationData[(ListAutData(rawValue: tag)?.key)!] = text
            
            textField.rightView = UIImageView(image: #imageLiteral(resourceName: "okImage"))
            
        case .loginForRestore where textOptions(text),
             .phoneForRestore where textOptions(text):
            
            restorePasswordData[(ListAutData(rawValue: tag)?.key)!] = text
            
            textField.rightView = UIImageView(image: #imageLiteral(resourceName: "okImage"))
            
        case _ where !textOptions(text):
            
            if text != "" {
            
                textField.rightView = UIImageView(image: #imageLiteral(resourceName: "cancelImage"))
            
            } else {
            
                fallthrough
            }
            
        default:
            textField.rightView = nil
        }
        
    }

    //MARK: - Actions

    @IBAction func actionResstorePassword(_ sender: Any) {
    
        showAlertControllerForResstorePassword()
    }
}
