//
//  NetworkExtensions.swift
//  SDKForms
//
// 
//

import Foundation

public extension URLSession {
    
    typealias ApiResponse = (data: Data?, response: URLResponse?, error: Error?)
    
    private func syncDataTask(
        request: URLRequest
    ) -> ApiResponse {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = self.dataTask(with: request) {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        dataTask.resume()
        
        semaphore.wait()
        
        return (data, response, error)
    }
    
    func executeGet(urlString: String) -> ApiResponse {
        guard let url = URL(string: urlString) else { return (nil, nil, nil) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return syncDataTask(request: request)
    }
    
    func executePost(urlString: String, body: Encodable) -> ApiResponse {
        guard let url = URL(string: urlString),
              let body = try? JSONEncoder().encode(body)
        else { return (nil, nil, nil) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        return syncDataTask(request: request)
    }
    
    func executePostParams(
        urlString: String,
        paramBody: [String: String]
    ) -> ApiResponse {
        guard let url = URL(string: urlString) else { return (nil, nil, nil) }
        
        var params = paramBody
            .reduce("") { $0 + "&\($1.key.urlEncoded!)=\($1.value.urlEncoded!)" }

        if !params.isEmpty { params.removeFirst() }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = params.data(using: .utf8)
        
        return syncDataTask(request: request)
    }
}

public extension String {
    
    var urlEncoded: String? {
        let allowedCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "~-_."))
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
    }
}
