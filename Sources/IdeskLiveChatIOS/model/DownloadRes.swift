//
//  File.swift
//  
//
//  Created by Bijoy  Debnath on 27/9/23.
//

import Foundation

public class DownloadRes{
    var isSuccess: Bool
    var path: String
    var url: URL
    
    public init(isSuccess: Bool, path: String, url: URL) {
        self.isSuccess = isSuccess
        self.path = path
        self.url = url
    }
}
