
import Foundation

class SessionData {

    static let shared = SessionData()
    
    
    
    var editRegistrationData = [ "surname" : "", "name" : "", "patronymic" : "",
                                 "phone" : "", "email" : "",
                                 "login" : "", "password" : "", "checkPassword" : ""] {
        
        willSet(value){
            
            if Array().checkForComplete(array: Array(value.values)) {
                
               
                
            } else {
                
                
            }
        }
    }
}
