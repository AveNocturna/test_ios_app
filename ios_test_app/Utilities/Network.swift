//
//  Network.swift
//  ios_test_app
//
//  Created by AveNocturna on 2/27/23.
//

import Foundation

@available(iOS 13.0.0, *)
func makeRequest(urlRequest:URLRequest)async throws ->(Data?, URLResponse?){
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard response is HTTPURLResponse else {
        return (nil,nil)
            }
    return (data,response)
}
