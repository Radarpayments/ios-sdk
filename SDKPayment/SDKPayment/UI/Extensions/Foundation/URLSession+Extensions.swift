//
//  URLSession+Extensions.swift
//  SDKPayment
//
//
//

import Foundation

public extension URLSession {

    typealias ApiResponse = (data: Data?, response: URLResponse?, error: Error?)

    func syncDataTask(
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

        // Check if we should invalidate the session due to connection errors
        if let error = error, NetworkSessionManager.shared.shouldInvalidate(error: error) {
            NetworkSessionManager.shared.invalidateAndRecreate()
        }

        return (data, response, error)
    }

    func executeGet(urlString: String) -> ApiResponse {
        guard let url = URL(string: urlString) else { return (nil, nil, nil) }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30.0

        // Use the managed session instead of self
        return NetworkSessionManager.shared.getSession().syncDataTask(request: request)
    }

    func executePost(urlString: String, body: Encodable) -> ApiResponse {
        guard let url = URL(string: urlString),
              let body = try? JSONEncoder().encode(body)
        else { return (nil, nil, nil) }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        request.timeoutInterval = 30.0

        return NetworkSessionManager.shared.getSession().syncDataTask(request: request)
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
        request.timeoutInterval = 30.0

        return NetworkSessionManager.shared.getSession().syncDataTask(request: request)
    }
}
