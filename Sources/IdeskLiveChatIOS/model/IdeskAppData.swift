//
//  IdeskAppData.swift
//  LibrayTestProject
//
//  Created by Bijoy  Debnath on 24/9/23.
//

import Foundation

public class IdeskAppData{
    var resource_uri: String
    var app_uri: String
    var page_id: String
    var customerInfo: [String: Any]?
    var miscellaneousDic: [String: Any]?
    
   public init(resource_uri: String, app_uri: String, page_id: String, customerInfo: [String: Any]?,miscellaneousDic: [String: Any]?) {
        self.resource_uri = resource_uri
        self.app_uri = app_uri
        self.page_id = page_id
        self.customerInfo = customerInfo
        self.miscellaneousDic = miscellaneousDic
    }
    
}
