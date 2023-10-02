//
//  DataFetcher.swift
//  LibrayTestProject
//
//  Created by Bijoy  Debnath on 24/9/23.
//

import Foundation

class DataFetcher: ObservableObject{
    @Published var ideskChatDataRes : IdeskChatDataRes? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    
    let service: APIServiceProtocol
    
    init(service: APIServiceProtocol = APIService()) {
        self.service = service
    }
    
    func getIdeskData(ideskAppdata: IdeskAppData) {
        
        if Reachability.isConnectedToNetwork(){
            isLoading = true
            errorMessage = nil
            
            service.iDeskAppData(ideskAppData: ideskAppdata) { [weak self] result in
                
             
                 DispatchQueue.main.async {
                    
                     
                     self?.isLoading = false
                   
                    switch result {
                    case .failure(let error):
                        self?.errorMessage = APIError.unknown.description
                        print(error)
                    case .success(let res):
                        let res: String = res
                        print(res)
                        self?.ideskChatDataRes = IdeskChatDataRes(data: res)
                    }
                
                     
                 }
                    
               
            }

        }else {
            self.errorMessage = APIError.noInternet.description
        }
        
        
    }
    
}
