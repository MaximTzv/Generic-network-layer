//
//  GitHubService.swift
//  Enceladus 2.0
//
//  Created by Maksim Tsvetkov on 11/29/18.
//  Copyright © 2018 Maksim Tsvetkov. All rights reserved.
//

import Foundation

enum GithubEndpoint {
    case language(lang: String)
}

extension GithubEndpoint: EndpointType {
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .language(let lang):
            return .requestParams(bodyParams: nil, urlParams: ["q": "language:\(lang)", "sort": "stars"])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }

    var baseURL: URL {
        return URL(string: "https://api.github.com/search/")!
    }
    
    var path: String {
        return "repositories"
    }
}

struct GithubManager: NetworkManageable {
    
    var router = Router<GithubEndpoint>()
    
    func getMostPopularLanguage(byLanguage language: String, completion: @escaping (_ repo: [Repo]?, _ error: String?) -> ()) {
        
        router.request(.language(lang: language)) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Please check your network connection")
            }
            
            if let response = response as? HTTPURLResponse {
                print("Status code \(response.statusCode)")
                let result = self.handleNetworkResponse(response)
                
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    do {
                        let apiResponse = try JSONDecoder().decode(RepoCollection.self, from: responseData)
                        
                        DispatchQueue.main.async {
                            completion(apiResponse.items, nil)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                        }
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
}
