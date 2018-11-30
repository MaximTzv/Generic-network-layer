//
//  Router.swift
//  Enceladus 2.0
//
//  Created by Maksim Tsvetkov on 11/29/18.
//  Copyright © 2018 Maksim Tsvetkov. All rights reserved.
//

import Foundation

public typealias RouterCallback = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

public protocol Routable: class {
    
    associatedtype Endpoint: EndpointType
    
    func request(_ route: Endpoint, completion: @escaping RouterCallback)
    
    func cancel()
} 

//** Generic implementation of a service call
public class Router<E: EndpointType>: Routable {
    
    private var task: URLSessionTask?
    
    public func request(_ route: E, completion: @escaping RouterCallback) {
        
        let session = URLSession.shared
        
        do {
            let request = try self.buildRequest(from: route)
            
            task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                completion(data, response, error)
            })
            
            NetworkLogger.log(request: request)
            
        } catch {
            completion(nil, nil, error)
        }
        
        self.task?.resume()
    }
    
    public func cancel() {
        self.task?.cancel()
    }
    
    // # MARK: Helper methods
    // Building the request with valid url components
    private func buildRequest(from route: E) throws -> URLRequest {
        
        var request = URLRequest(
            url: route.baseURL.appendingPathComponent(route.path),
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .requestParams(let bodyParams, let urlParams):
                try self.configureParameters(
                    bodyParams: bodyParams,
                    urlParams: urlParams,
                    request: &request)
                
            case .requestParamsAndHeaders(let bodyParams, let urlParams, let additionalHeaders):
                self.addAdditionalHeader(additionalHeaders, request: &request)
                
                try self.configureParameters(
                    bodyParams: bodyParams,
                    urlParams: urlParams,
                    request: &request)
            }
            
            return request
        } catch {
            throw error
        }
    }
    
    // Configuring the parameters for both url and json
    private func configureParameters(bodyParams: Parameters?,
                                     urlParams: Parameters?,
                                     request: inout URLRequest) throws {
        
        do {
            if let bodyParams = bodyParams {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParams)
            }
            
            if let urlParams = urlParams {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParams)
            }
        } catch {
            throw error
        }
    }
    
    private func addAdditionalHeader(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        
        guard let headers = additionalHeaders else { return }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
