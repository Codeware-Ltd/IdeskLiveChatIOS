//
//  APIServiceProtocol.swift
//  LibrayTestProject
//
//  Created by Bijoy  Debnath on 24/9/23.
//

import Foundation
protocol APIServiceProtocol {
    
    func iDeskAppData(ideskAppData: IdeskAppData, completion: @escaping(Result<String, APIError>) -> Void)
}
