//
//  Address.swift
//  ios_test_app
//
//  Created by AveNocturna on 2/28/23.
//

import Foundation


class AddressViewModel{
    
    func removeAddress(id:Int) async ->Bool?{
        let url = "http://localhost:5000/api/address/\(id)"
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "DELETE"
            do{
                let (_,response) = try await makeRequest(urlRequest: request as URLRequest)
                if (response as? HTTPURLResponse)?.statusCode != 200{
                  return nil
                }
                return true
            } catch  {
                return nil
            }
    }
    
    func addAddress(address:Address) async ->Address?{
        
        let url = "http://localhost:5000/api/address"
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        
        let body = ["address":address.address,"customerId":address.customerId] as [String : Any]
        let jsonBody = try? JSONSerialization.data(withJSONObject: body)
        print(body)
        request.httpBody = jsonBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do{
                let (data,response) = try await makeRequest(urlRequest: request as URLRequest)
                
                if (response as? HTTPURLResponse)?.statusCode != 201{
                  return nil
                }
                print("Agregado")
                let address = try JSONDecoder().decode(Address.self, from: data!)
                
                return address
            } catch  {
                print(error)
                return nil
            }

    }
}
