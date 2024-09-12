//
//  NetworkManager.swift
//  SearchContent
//
//  Created by Danil on 08.09.2024.
//

import Foundation

class NetworkManager {
    let token = "-SDyKXcy57mwni3y4X2huKiioD75FGr5lcGat84bl5Y"
    
    func fetchData(query: String,
                   page: Int,
                   completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com//search/photos?client_id=\(token)&query=\(query)&page=\(page)&per_page=\(30)") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let data = data {
                    completion(.success(data))
                }
            }
        }.resume()
    }
    
}
