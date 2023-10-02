//
//  APIError.swift
//  LibrayTestProject
//
//  Created by Bijoy  Debnath on 24/9/23.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    case badURL
    case badResponse(statusCode: Int)
    case url(URLError?)
    case parsing(DecodingError?)
    case unknown
    case noInternet
    
    var localizedDescription: String {
        // user feedback
        switch self {
        case .badURL, .parsing, .unknown:
            return "Sorry, something went wrong."
        case .badResponse(_):
            return "Sorry, the connection to our server failed."
        case .url(let error):
            return error?.localizedDescription ?? "Something went wrong."
        case .noInternet :
            return "Sorry, No proper internet connection. Check your connection and try again."
        
        }
    }
    
    var description: String {
        //info for debugging
        switch self {
        case .unknown: return "Something went wrong."
        case .badURL: return "invalid URL"
        case .url(let error):
            return error?.localizedDescription ?? "url session error"
        case .parsing(let error):
            return "parsing error \(error?.localizedDescription ?? "")"
        case .badResponse(statusCode: let statusCode):
            return "bad response with status code \(statusCode)"
        case .noInternet: return "Sorry, No proper internet connection. Check your connection and try again."
        }
    
    }
}
