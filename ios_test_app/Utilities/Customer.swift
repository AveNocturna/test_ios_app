//
//  Customer.swift
//  ios_test_app
//
//  Created by AveNocturna on 2/28/23.
//

import Foundation

func addressListToDictionary(_ addresses: [Address]) -> [Int: Address] {
    var dict: [Int: Address] = [:]
    for address in addresses {
        dict[address.id] = address
    }
    return dict
}
