
enum ListRegData: Int {
    
    case surname = 0, name, patronymic, phone, email, login, password, checkPassword
    
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
        }
    }
}
