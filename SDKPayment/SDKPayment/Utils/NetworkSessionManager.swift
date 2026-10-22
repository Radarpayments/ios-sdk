//
//  NetworkSessionManager.swift
//  SDKPayment
//
//
//

import Foundation

final class NetworkSessionManager {
    static let shared = NetworkSessionManager()
    
    private var currentSession: URLSession
    private let sessionQueue = DispatchQueue(label: "com.sdk.networkSession", attributes: .concurrent)
    
    private init() {
        let configuration = URLSessionConfiguration.default
        
        configuration.timeoutIntervalForRequest = Constants.TIMEOUT_INTERVAL_REQUEST
        configuration.timeoutIntervalForResource = Constants.TIMEOUT_INTERVAL_RESOURCE
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = Constants.HTTP_MAX_CONNECTIONS_PER_HOST
        
        self.currentSession = URLSession(configuration: configuration)
    }
    
    func getSession() -> URLSession {
        return sessionQueue.sync {
            return currentSession
        }
    }
    
    func invalidateAndRecreate() {
        sessionQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            
            // Invalidate the current session
            self.currentSession.invalidateAndCancel()
            
            // Create a new session with fresh configuration
            let configuration = URLSessionConfiguration.default
            
            configuration.timeoutIntervalForRequest = Constants.TIMEOUT_INTERVAL_REQUEST
            configuration.timeoutIntervalForResource = Constants.TIMEOUT_INTERVAL_RESOURCE
            configuration.waitsForConnectivity = true
            configuration.httpMaximumConnectionsPerHost = Constants.HTTP_MAX_CONNECTIONS_PER_HOST
            
            self.currentSession = URLSession(configuration: configuration)
        }
    }
    
    func shouldInvalidate(error: Error?) -> Bool {
        guard let error = error else { return false }
        
        // Check for connection-related errors that indicate bad connection state
        let nsError = error as NSError
        
        return nsError.domain == NSURLErrorDomain && (
            nsError.code == NSURLErrorTimedOut ||
            nsError.code == NSURLErrorCannotConnectToHost ||
            nsError.code == NSURLErrorNetworkConnectionLost ||
            nsError.code == NSURLErrorNotConnectedToInternet ||
            nsError.code == NSURLErrorDataNotAllowed
        )
    }
}
