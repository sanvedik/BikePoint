
import Foundation

enum Messages: String {
    
    case successPasswordRestore
    
    var message : String {
        
        switch self {
            
        case .successPasswordRestore:
            return "Ваш новый пароль был выслан на Ваш номер"
            
        }
    }
}
