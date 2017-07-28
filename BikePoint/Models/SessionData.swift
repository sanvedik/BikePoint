
import Foundation

class SessionData {

    static let shared = SessionData()
    
    let NotificationCompleteRegistrationData = "NotificationCompleteRegistrationData"
    
    var editRegistrationData = [ "surname" : "", "name" : "", "patronymic" : "",
                                 "phone" : "", "email" : "",
                                 "login" : "", "password" : "", "checkPassword" : ""] {
        
        willSet(value){
            
            if Array().checkForComplete(array: Array(value.values)) {
                
               NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCompleteRegistrationData), object: true)
                
            } else {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCompleteRegistrationData), object: false)
            }
        }
    }
}
