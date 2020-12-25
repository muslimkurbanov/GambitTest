//
//  NetworkService.swift
//  Gambit
//
//  Created by Муслим Курбанов on 22.12.2020.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func getMenu(completion: @escaping(Result<[Menu]?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    func getMenu(completion: @escaping (Result<[Menu]?, Error>) -> Void) {
        let urlString = "https://api.gambit-app.ru/category/39?page=1"
        
        AF.request(urlString, method: .get, parameters: nil).responseJSON { (responce) in
            switch responce.result {
            case .failure(let error):
                print(error)
            case .success(let value):
                if let arrayDictionary = value as? [[String: Any]] {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: arrayDictionary, options: .fragmentsAllowed)
                        print(data)
                        let result = try JSONDecoder().decode([Menu].self, from: data)
                        completion(.success(result))
                        print(result)
                    } catch {
                        completion(.failure(error))
                        print(error)
                    }
                }
            }
        }.resume()
    }
    
    
}
