//
//  Customer.swift
//  ios_test_app
//
//  Created by AveNocturna on 2/27/23.
//

import Foundation

struct CustomerModel: Codable {
    let id: Int
    let name: String
    let email: String
    let addresses: [Address]
}

