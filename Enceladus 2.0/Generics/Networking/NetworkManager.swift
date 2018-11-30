//
//  NetworkManager.swift
//  Enceladus 2.0
//
//  Created by Maksim Tsvetkov on 11/29/18.
//  Copyright © 2018 Maksim Tsvetkov. All rights reserved.
//

import Foundation

public enum Result<String> {
    case success
    case failure(String)
}

public enum NetworkResponse: String {
    case success
    case authError = "You need to be authenticated first"
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated"
    case failed = "Network request failed"
    case noData = "Response returned with no data to decode"
    case unableToDecode = "We were unable to decode the response"
}

public protocol NetworkManageable {

//    associatedtype GenericModel: Decodable
    
    static var apiKey: String? { get }

//    var model: GenericModel { get }
    
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>
}

extension NetworkManageable {

    static var apiKey: String? {
        return ""
    }
    
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
