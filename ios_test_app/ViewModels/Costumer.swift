//
//  Costumer.swift
//  ios_test_app
//
//  Created by AveNocturna on 2/27/23.
//

import Foundation

struct CustomerViewModel{
    func getCustomers() async -> [CustomerModel]?{
        var customers:[CustomerModel] = []
        let url = "http://localhost:5000/api/customer"
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
            do{
                let (data,response) = try await makeRequest(urlRequest: request as URLRequest)
                
                if (response as? HTTPURLResponse)?.statusCode != 200{
                  return nil
                }
                customers = try JSONDecoder().decode([CustomerModel].self, from:data!)
                return customers
            } catch  {
                return nil
            }

    }
    
    
    func createCustomer(customer:CustomerModel) async ->Int?{
        let url = "http://localhost:5000/api/customer"
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let customerData = ["name":customer.name,"email":customer.email]
        var addresseList:[String] = []
        for address in customer.addresses{
            addresseList.append(address.address)
        }
        let body = ["customerData":customerData,"addresses":addresseList] as [String : Any]
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonBody
        
            do{
                let (data,response) = try await makeRequest(urlRequest: request as URLRequest)
                
                if (response as? HTTPURLResponse)?.statusCode != 201{
                  return nil
                }
                let jsonData = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                
                let id = jsonData.object(forKey: "id")as! Int
                
                return id
            } catch  {
                print(error)
                return nil
            }

    }
    
    func updateCustomer(customer:CustomerModel) async ->Bool{
        let url = "http://localhost:5000/api/customer/\(customer.id)"
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["name":customer.name,"email":customer.email]

        let jsonBody = try? JSONSerialization.data(withJSONObject: ["customerData":body])
        
        request.httpBody = jsonBody
        
            do{
                let (_,response) = try await makeRequest(urlRequest: request as URLRequest)
                if (response as? HTTPURLResponse)?.statusCode != 200{
                  return false
                }
                return true
            } catch  {
                print(error)
                return false
            }

    }
}
