
import Foundation

class SessionData {
    
    static let shared = SessionData()
    
    let userDefaults = UserDefaults.standard
    
    var userToken: String? {
        
        get{
            return userDefaults.string(forKey: "keyUserToken")
        }
        
        set{
            userDefaults.set(newValue, forKey: "keyUserToken")
        }
    }
}
