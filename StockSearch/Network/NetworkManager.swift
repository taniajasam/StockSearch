//
//  NetworkManager.swift
//  StockSearch
//
//  Created by Tania Jasam on 11/04/20.
//  Copyright © 2020 Tania Jasam. All rights reserved.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    let webserviceHelper = WebserviceHelper()
    private init() {
        
    }
    
    func fetchUsers(completion: @escaping (HomeResponse?) -> ()) {
        guard let url = URL(string: AppConstants.API.users)
            else {
                return
        }
        webserviceHelper.fetchData(url: url, shouldCancelOtherOps: true) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                completion(nil)
            } else {
                guard let responseData = data else { return }
                
                let jsonDecoder = JSONDecoder()
                do {
                    let usersResponse = try jsonDecoder.decode(HomeResponse.self, from: responseData)
                    completion(usersResponse)
                } catch {
                    print("Error occured while parsing users response")
                    completion(nil)
                }
            }
        }
    }
}
