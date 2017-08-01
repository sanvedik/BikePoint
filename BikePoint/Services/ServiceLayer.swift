
import Alamofire

class ServiceLayer {
    
    static let shared = ServiceLayer()
    
    
    func checkRegData( email: String, login: String , phone: String,
                       completion: @escaping ([Bool]? , Errors?) -> ()) {
        
        let phone = String().parsPhone(number: phone)
    
        let parametrs : [String : Any] = ["email" : email, "login" : login, "phone" : phone]
        
        Alamofire.request(Router.checkRegData(parametrs: parametrs)).responseJSON{ response in
            
            switch response.result {
                
            case .success:
                
                let jsonDict = response.result.value as! NSDictionary
                
                let statusResponce = jsonDict.value(forKey: "ok") as? Bool
                
                if statusResponce! {
                    
                    let availableRegistrationData = jsonDict.value(forKey: "available") as? [Bool]
                    
                    completion(availableRegistrationData, nil)
                    
                } else {
                    
                    let error = Errors(rawValue: jsonDict.value(forKey: "error") as! String)
                    
                    completion(nil, error)
                }
                
            case .failure:
                
                completion( nil, Errors.internetNotConnect)
            }
        }
    }
    
    func requestSmsCode( phone: String,
                         completion: @escaping (Int? , Errors?) -> ()) {
        
        let phone = String().parsPhone(number: phone)
        
        let parametrs : [String : Any] = ["phone" : phone]
        
        Alamofire.request(Router.requestSmsCode(parametrs: parametrs)).responseJSON{ response in
            
            switch response.result {
                
            case .success:
                
                let jsonDict = response.result.value as! NSDictionary
                
                let statusResponce = jsonDict.value(forKey: "ok") as? Bool
                
                if statusResponce! {
                    
                    let sessionNumber = jsonDict.value(forKey: "session") as? Int
                    
                    completion(sessionNumber, nil)
                    
                } else {
                    
                    let error = Errors(rawValue: jsonDict.value(forKey: "error") as! String)
                    
                    completion(nil, error)
                }
                
            case .failure:
                
                completion( nil, Errors.internetNotConnect)
            }
        }
    }
    
    func setRegData( email: String, login: String, phone: String,
                     session: Int, code: Int, password: String,
                     fullname: String, completion: @escaping (String? , Errors?) -> ()) {
        
        let phone = String().parsPhone(number: phone)
        
        let parametrs : [String : Any] = [ "email" : email, "login" : login, "phone" : phone,
                                           "session" : session, "code" : code, "password" : password,
                                           "fullname" : fullname ]
        
        Alamofire.request(Router.setRegData(parametrs: parametrs)).responseJSON{ response in
            
            switch response.result {
                
            case .success:
                
                let jsonDict = response.result.value as! NSDictionary
                
                let statusResponce = jsonDict.value(forKey: "ok") as? Bool
                
                if statusResponce! {
                    
                    let userToken = jsonDict.value(forKey: "userToken") as? String
                    
                    completion(userToken, nil)
                    
                } else {
                    
                    let error = Errors(rawValue: jsonDict.value(forKey: "error") as! String)
                    
                    completion(nil, error)
                }
                
            case .failure:
                
                completion( nil, Errors.internetNotConnect)
            }
        }
    }
    
    func restorePassword ( login: String, phone: String, completion: @escaping (Messages?, Errors?) -> ()) {
        
        let phone = String().parsPhone(number: phone)
        
        let parametrs : [String : Any] = ["login" : login, "phone" : phone]
        
        Alamofire.request(Router.restorePassword(parametrs: parametrs)).responseJSON{ response in
            
            switch response.result {
                
            case .success:
                
                let jsonDict = response.result.value as! NSDictionary
                
                let statusResponce = jsonDict.value(forKey: "ok") as? Bool
                
                if statusResponce! {
                    
                    let done = jsonDict.value(forKey: "done") as? Bool
                    
                    if done! {
                    
                        completion(Messages.successPasswordRestore, nil)
                    
                    } else {
                    
                        completion(nil, Errors.restoreFailed)
                    }
                    
                } else {
                    
                    let error = Errors(rawValue: jsonDict.value(forKey: "error") as! String)
                    
                    completion(nil, error)
                }
                
            case .failure:
                
                completion(nil, Errors.internetNotConnect )
            }
        }
    }
    
    func getAuthToken( login: String, password: String, completion: @escaping (String?, String?, Errors?) -> ()) {
        
        let parametrs : [String : Any] = ["login" : login, "password" : password]
        
        Alamofire.request(Router.getAuthToken(parametrs: parametrs)).responseJSON{ response in
            
            switch response.result {
                
            case .success:
                
                let jsonDict = response.result.value as! NSDictionary
                
                let statusResponce = jsonDict.value(forKey: "ok") as? Bool
                
                if statusResponce! {
                    
                    let userToken = jsonDict.value(forKey: "userToken") as? String
                    
                    let email = jsonDict.value(forKey: "email") as? String
                    
                    completion(userToken, email, nil)
                    
                } else {
                    
                    let error = Errors(rawValue: jsonDict.value(forKey: "error") as! String)
                    
                    completion(nil, nil, error)
                }
                
            case .failure:
                
                completion( nil, nil, Errors.internetNotConnect)
            }
        }
    }
    
    func getStationInfo( completion: @escaping (StationInfo? ,Errors?) -> ()) {
        
        Alamofire.request(Router.getStationInfo).responseJSON{ response in
            
            switch response.result {
                
            case .success:
                
                let jsonDict = response.result.value as! NSDictionary
                
                let statusResponce = jsonDict.value(forKey: "ok") as? Bool
                
                if statusResponce! {
                    
                    let addresses = (jsonDict.value(forKey: "addresses") as! [String])
                    
                    let latitudes = (jsonDict.value(forKey: "latitudes") as! [Double])
                    
                    let longitudes = (jsonDict.value(forKey: "longitudes") as! [Double])
                    
                    let busySlots = (jsonDict.value(forKey: "busySlots") as! [Int])
                    
                    let freeSlots = (jsonDict.value(forKey: "freeSlots") as! [Int])
                    
                    let stationInfo = StationInfo(addresses: addresses, latitudes: latitudes,
                                                  longitudes: longitudes, busyClots: busySlots,
                                                  freeSlots: freeSlots)
                    
                    completion(stationInfo, nil)
                    
                } else {
                    
                    let error = Errors(rawValue: jsonDict.value(forKey: "error") as! String)
                    
                    completion(nil, error)
                }
                
            case .failure:
                
                completion(nil, Errors.internetNotConnect)
            }
        }
    }
}
