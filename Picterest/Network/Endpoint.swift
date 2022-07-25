//
//  Endpoint.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import Foundation

struct Endpoint {
    private let urlString: String
    private let method: HttpMethod
    private let headers: [String: String]
    private let queryItems: [String: String]
    
    init(urlString: String, method: HttpMethod, headers: [String: String], queryItems: [String: String]) {
        self.urlString = urlString
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
    }
    
    func urlRequest() -> URLRequest? {
        guard let url = url() else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        return urlRequest
    }
    
    private func url() -> URL? {
        guard var urlComponents = URLComponents(string: urlString) else {
            return nil
        }
        
        urlComponents.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        return urlComponents.url
    }
}
