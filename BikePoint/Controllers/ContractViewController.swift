
import UIKit
import SVProgressHUD

class ContractViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var agreementButton: UIButton!
    
    var registrationData : [String : Any?] = [:]
    
    let serviceLayer = ServiceLayer.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
        agreementButton.layer.cornerRadius = agreementButton.frame.height / 2
        
        agreementButton.isEnabled = false
        
        webView.scrollView.delegate = self
        
        loadingPgf()
        
        SVProgressHUD.dismiss()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - MyFunc
    
    func loadingPgf() {
        
        let filePath = Bundle.main.path(forResource: "pdf.pdf", ofType: nil)
        
        let fileUrl = URL(fileURLWithPath: filePath!)
        
        let request = URLRequest(url: fileUrl)
        
        webView.loadRequest(request)
    }
    
    
    func showAlertControllerForEnterSmsCode() {
        
        let alertController = UIAlertController(title: "Введите код.", message: "На Ваш номер был выслан код активации, пожалуйста проверьте Ваши смс сообщения.", preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: { text in
            
            text.placeholder = "Введите смс код"
            
            text.delegate = self
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { action in
            
            let code = Int((alertController.textFields?.first?.text)!)
            
            self.registrationData[ListRegData.code.key] = code
            
            self.setRegData()
        })
        
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func requestSmsCode() {
        
        SVProgressHUD.show()
        
        serviceLayer.requestSmsCode(phone: registrationData[ListRegData.phone.key] as! String, completion: { (sessionNumber, error) in
            
            SVProgressHUD.dismiss()
            
            if let error = error {
                
                self.showAlertControllerFor(message: error)
                
            } else  {
                
                self.registrationData[ListRegData.session.key] = sessionNumber
                self.showAlertControllerForEnterSmsCode()
            }
        })
    }
    
    func setRegData() {
        
        var fullname: String {
            
            let surname = registrationData[ListRegData.surname.key] as! String
            
            let name = registrationData[ListRegData.name.key] as! String
            
            let patronymic = registrationData[ListRegData.patronymic.key] as! String
            
            return surname + " " + name + " " + patronymic
        }
        
    
        SVProgressHUD.show()
        
        serviceLayer.setRegData(email: registrationData[ListRegData.email.key] as! String,
                                login: registrationData[ListRegData.login.key] as! String,
                                phone: registrationData[ListRegData.phone.key] as! String,
                                session: registrationData[ListRegData.session.key] as! Int,
                                code: registrationData[ListRegData.code.key] as! Int,
                                password: registrationData[ListRegData.password.key] as! String,
                                fullname: fullname,
                                completion: { (userToken, error) in
                                    
                                    SVProgressHUD.dismiss()
                                    
                                    if let error = error {
                                        
                                        self.showAlertControllerFor(message: error)
                                        
                                    } else  {
                                        
                                        self.performSegue(withIdentifier: "MainViewController", sender: nil)
                                    }
        })
    }
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            
            agreementButton.isEnabled = true
        }
    }
    
    //MARK: - Actions
    
    @IBAction func actionAgreementButton(_ sender: Any) {
        
        requestSmsCode()
    }
}
