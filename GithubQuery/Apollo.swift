//
//  Apollo.swift
//  GithubQuery
//
//  Created by dkotha on 9/17/19.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import Apollo

class Apollo {
    private let githubToken = "YOUR_TOKEN"
    static let shared = Apollo()
    
    // Configure the network transport to use the singleton as the delegate.
    private lazy var networkTransport = HTTPNetworkTransport(
        url: URL(string: "https://api.github.com/graphql")!,
        delegate: self
    )
    
    // Use the configured network transport in your client.
    private(set) lazy var client = ApolloClient(networkTransport: self.networkTransport)
}

// MARK: - Pre-flight delegate

extension Apollo: HTTPNetworkTransportPreflightDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport, shouldSend request: URLRequest) -> Bool {
        return true
    }

    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          willSend request: inout URLRequest) {
        
        // Get the existing headers, or create new ones if they're nil
        var headers = request.allHTTPHeaderFields ?? [String: String]()
        
        // Add any new headers you need
        headers["Authorization"] = "Bearer \(githubToken)"
        
        // Re-assign the updated headers to the request.
        request.allHTTPHeaderFields = headers
    }
}
