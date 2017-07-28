
import Alamofire

class ServiceLayer {
    
    static let shared = ServiceLayer()
    
    let sessionData = SessionData.shared
    
    
    func checkRegData(completion: @escaping ([Bool]? , Errors?) -> ()) {
        
        let editRegistrationData = sessionData.editRegistrationData
        
        let keyEmail = "email"
        let keyLogin = "login"
        let keyPhone = "phone"
        
        let params = [ keyEmail : editRegistrationData[keyEmail]!,
                       keyLogin : editRegistrationData[keyLogin]!,
                       keyPhone : editRegistrationData[keyPhone]! ]
        
        Alamofire.request(Router.checkRegData(parametrs: params)).responseJSON{ response in
            
            switch response.result {
                
            case .success:
                
                let responseData = ResponceData(checkRegData: response.result.value as! NSDictionary)
                
                if responseData.statusResponce! {
                
                    completion(responseData.availableRegistrationData, nil)
                
                } else {
                
                    completion(nil, responseData.error)
                }
                
            case .failure:
                
                completion( nil, Errors.internetNotConnect)
                
            }
        }
    }
    
}
