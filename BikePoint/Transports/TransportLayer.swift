import Foundation

import Alamofire

enum Router: URLRequestConvertible {
    
    case checkRegData(parametrs: Parameters)
    
    case requestSmsCode(parametrs: Parameters)
    
    case setRegData(parametrs: Parameters)
    
    case getAuthToken(parametrs: Parameters)
    
    case checkAuthToken(parametrs: Parameters)
    
    case resetConnections(parametrs: Parameters)
    
    case changePassword(parametrs: Parameters)
    
    case restorePassword(parametrs: Parameters)
    
    case getAccountInfo(parametrs: Parameters)
    
    case getPrice(parametrs: Parameters)
    
    case createNewOrder(parametrs: Parameters)
    
    case getOrders(parametrs: Parameters)
    
    case cancelOrder(parametrs: Parameters)
    
    case getStationInfo
    
    
    static let baseURLString = "https://bikerent.azurewebsites.net/client/ihk4NOpYk4GQ9SybB0tSQebTQjcRptAh"
    
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        
        switch self {
        case .checkRegData:
            return "checkRegData"
            
        case.requestSmsCode:
            return "requestSmsCode"
            
        case .setRegData:
            return "setRegData"
            
        case .getAuthToken:
            return "getAuthToken"
            
        case .checkAuthToken:
            return "checkAuthToken"
            
        case .resetConnections:
            return "resetConnections"
            
        case .changePassword:
            return "changePassword"
            
        case .restorePassword:
            return "restorePassword"
            
        case .getAccountInfo:
            return "getAccountInfo"
            
        case .getPrice:
            return "getPrice"
            
        case .createNewOrder:
            return "createNewOrder"
            
        case .getOrders:
            return "getOrders"
            
        case .cancelOrder:
            return "cancelOrder"
            
        case .getStationInfo:
            return "getStationInfo"
            
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
            
        case .checkRegData(let parametrs):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parametrs)
            
        case .requestSmsCode(let parametrs):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parametrs)
            
        case .setRegData(let parametrs):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parametrs)
            
        case .getAuthToken(let parametrs):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parametrs)
            
        case .checkAuthToken(let parametrs):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parametrs)
            
        case .resetConnections(let parametrs):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parametrs)
            
        case .changePassword(let parametrs):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parametrs)
            
        case .restorePassword(let parametrs):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parametrs)
            
        case .getAccountInfo(let parametrs):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parametrs)
            
        case .getPrice(let parametrs):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parametrs)
            
        case .createNewOrder(let parametrs):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parametrs)
            
        case .getOrders(let parametrs):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parametrs)
            
        case .cancelOrder(let parametrs):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parametrs)
            
        case .getStationInfo:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        }
        
        return urlRequest
    }
}
