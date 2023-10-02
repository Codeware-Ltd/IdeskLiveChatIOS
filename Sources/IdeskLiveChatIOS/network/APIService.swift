//
//  APIService.swift
//  LibrayTestProject
//
//  Created by Bijoy  Debnath on 24/9/23.
//

import Foundation

struct APIService: APIServiceProtocol {
    
    func fetch<T: Decodable>(_ type: T.Type, url: URL?, completion: @escaping(Result<T,APIError>) -> Void) {
        guard let url = url else {
            let error = APIError.badURL
            completion(Result.failure(error))
            return
        }
        let task = URLSession.shared.dataTask(with: url) {(data , response, error) in
            
            if let error = error as? URLError {
                completion(Result.failure(APIError.url(error)))
            }else if  let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(Result.failure(APIError.badResponse(statusCode: response.statusCode)))
            }else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(type, from: data)
                    completion(Result.success(result))
                    
                }catch {
                    completion(Result.failure(APIError.parsing(error as? DecodingError)))
                }

            }
        }

        task.resume()
    }
    
    
    func iDeskAppData(ideskAppData: IdeskAppData, completion: @escaping (Result<String, APIError>) -> Void) {
      
//        if ideskAppData == nil {
//            let error = APIError.unknown
//            completion(Result.failure(error))
//            return
//        }
//
        let url = URL(string: AppConstants.BASE_URL)
        var request = URLRequest(url: url!,timeoutInterval: Double.infinity)
        
        
        var dictionary =  [String: Any]()
        dictionary["resource_uri"] = ideskAppData.resource_uri
        dictionary["app_uri"] = ideskAppData.app_uri
        dictionary["page_id"] = ideskAppData.page_id
        
        
        if ideskAppData.customerInfo != nil{
            dictionary["customerInfo"] = ideskAppData.customerInfo
        }
        
        if ideskAppData.miscellaneousDic != nil {
            dictionary["miscellaneous"] = ideskAppData.miscellaneousDic
            
        }
        
        print("custom json")
        print(dictionary)
        
        do {
            let jsonDicData =  try JSONSerialization.data(withJSONObject: dictionary, options: [])
            print("custom json2")
            print(jsonDicData)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonDicData
            
            
            let task = URLSession.shared.dataTask(with: request) {(data , response, error) in
                
                if let error = error as? URLError {
                    print(error)
                    completion(Result.failure(APIError.url(error)))
                }else if  let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    print(response)
                    print(response.statusCode)
                    completion(Result.failure(APIError.badResponse(statusCode: response.statusCode)))
                }else if let data = data {
                
                    let str = String(decoding: data, as: UTF8.self)
                    print(str)
                    
                    completion(Result.success(str))
                    
                }
            }

            task.resume()
            
            
        }catch {
            let error = APIError.unknown
            completion(Result.failure(error))
        }
    
      
        
    }
    
        
}
