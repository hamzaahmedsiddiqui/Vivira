//
//  NetworkManager.swift
//  Vivira
//
//  Created by Hamza Ahmed on 10/03/2022.
//

import Foundation
import Alamofire
import Alamofire_SwiftyJSON
import SwiftyJSON

protocol NetworkManager {
    func requestData(endpoint: String, parameters: [String: Any], httpMethod: HTTPMethod, completionHandler: @escaping ( Swift.Result<JSON, Error>) -> Void)
}


// MARK: - base network class to call api
/**
 API call function for fetching search result
 */
final class NetworkManagerImplementation:NetworkManager {
    private let baseURL = "\(Constant.baseUrl)"
    func requestData(endpoint: String, parameters: [String: Any], httpMethod: HTTPMethod, completionHandler: @escaping ( Swift.Result<JSON, Error>) -> Void) {
        
        
        
        let urlString = baseURL + endpoint
        
        let serviceRequest = request(urlString, method: httpMethod, parameters: parameters, encoding: URLEncoding.default)
        
        serviceRequest.responseSwiftyJSON { (response) in
            
            if response.error == nil{
                guard let data = response.value else { return }
                
                guard let statusCode = response.response?.statusCode
                else {
                    completionHandler(.failure(NetworkError.generic))
                    return
                }
                if statusCode == StatusCode.authExpired.rawValue{
                    completionHandler(.failure(NetworkError.generic))
                }
                else if statusCode != StatusCode.success.rawValue{
                    completionHandler(.failure(NetworkError.generic))
                }
                else{
                    completionHandler(.success(data))
                }
                
            }
            else{
                completionHandler(.failure(NetworkError.generic))
            }
            
        }
    }
}

enum StatusCode : Int {
    case success = 200
    case authExpired = 401
    case error = 500
}

enum NetworkError: Error {
    case apiResponseError
    case generic
    
    func showMessage()-> String {
        switch self {
        case .apiResponseError:
            return "Parsing Error"
        case .generic:
            return "Something went wrong"
        }
    }
}

