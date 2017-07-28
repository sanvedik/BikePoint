import Foundation

enum Errors: String {
    
    case authFailed = "AUTH_FAILED"
    case tokenExpired = "TOKEN_EXPIRED"
    case userBanned = "USER_BANNED"
    case parametersFailure = "PARAMETERS_FAILURE"
    case unknownFailure = "UNKNOWN_FAILURE"
    
    case internetNotConnect
    
    case restoreFailed
    
    case regionCodeFailure
    
    var title : String {
        
        switch self {
            
        case .authFailed:
            return "Ошибка авторизации."
            
        case .tokenExpired:
            return "Аккаунт устарел."
            
        case .userBanned:
            return "Доступ пользователя приостановлен."
            
        case .parametersFailure:
            return "Указаны неверные данные."
            
        case .unknownFailure:
            return "Неизвестная ошибка"
            
        case .internetNotConnect:
            return "Отсуствует соединение с сетью."
            
        case .restoreFailed:
            return "Ошибка Востановления."
            
        case .regionCodeFailure:
            return "Неверный региональный код"
            
        }
    }
    
    var message : String {
        
        switch self {
            
        case .authFailed:
            return "Проверьте правильность введеных данных."
            
        case .tokenExpired:
            return "Зарегистрируйтесь заново."
            
        case .userBanned:
            return "Обратитесь в службу технической поддержки."
            
        case .parametersFailure:
            return "Проверьте правильность введеных данных"
            
        case .unknownFailure:
            return "Обратитесь в службу технической поддержки."
            
        case .internetNotConnect:
            return "Проверьте подключение к сети."
            
        case .restoreFailed:
            return "Проверьте правильность введеных данных."
            
        case .regionCodeFailure:
            return "Только региональные коды беларуси (25, 29, 33, 44)"
            
        }
    }
}
