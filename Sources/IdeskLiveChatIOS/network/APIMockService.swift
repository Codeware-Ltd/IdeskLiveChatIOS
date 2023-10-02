//
//  APIMockService.swift
//  LibrayTestProject
//
//  Created by Bijoy  Debnath on 24/9/23.
//

import Foundation
struct APIMockService: APIServiceProtocol {
    
    var result: Result<String, APIError>
    
    func iDeskAppData(ideskAppData: IdeskAppData, completion: @escaping (Result<String, APIError>) -> Void) {
        completion(result)
    }
    
}
