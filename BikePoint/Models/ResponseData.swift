
import Foundation

class ResponceData {

    var statusResponce: Bool?
    
    var error: Errors?
    
    
    var availableRegistrationData: [Bool]?
    
    
    
    init (statusResponce jsonDict: NSDictionary) {
    
        statusResponce = jsonDict.value(forKey: "ok") as? Bool
        
        if statusResponce == false {
        
            error = Errors(rawValue: jsonDict.value(forKey: "error") as! String)
        }
    }
    
    
    convenience init (checkRegData jsonDict: NSDictionary) {
    
        self.init(statusResponce: jsonDict)
        
        if statusResponce! {
        
            availableRegistrationData = jsonDict.value(forKey: "available") as? [Bool]
        }
    }
}
