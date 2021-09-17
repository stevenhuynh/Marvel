//
//  ApiService.swift
//  Marvel
//
//  Created by shuynh on 9/15/21.
//

import Foundation

enum ApiError: Error {
    case unknownError
    case invalidResponse
    case invalidURL
 }

typealias Completion<T> = (Result<T, Error>) -> Void
class ApiService {
    static let shared = ApiService()
    static let privateKey = "b3ea8a30d64869bbd0d5dec2e19070ff"
    static let publicKey = "5ae147f4e960b64579d410f12a61b50d2eb15ae0"
    let session = URLSession(configuration: .default)
    
    private init() {}
    
    func fetchCharacters(_ offset: Int, completion: @escaping Completion<CharacterResponse>) {
        let ts = Int(Date().timeIntervalSince1970)
        let hash = "\(ts)\(ApiService.publicKey)\(ApiService.privateKey)".md5()
        let urlString = "https://gateway.marvel.com/v1/public/characters?ts=\(ts)&offset=\(offset)&hash=\(hash!)&apikey=\(ApiService.privateKey)&limit=20"
        
        guard let url = URL.init(string: urlString) else {
            return completion(.failure(ApiError.invalidURL))
        }
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(ApiError.invalidResponse))
                }
                return
            }

            do {
                if response.statusCode == 200 {
                    let characters = try JSONDecoder().decode(CharacterResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(characters))
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(.failure(ApiError.invalidResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchCharacterDetails(for characterId: Int, section: String, completion: @escaping Completion<DetailResponse>) {
        let ts = Int(Date().timeIntervalSince1970)
        let hash = "\(ts)\(ApiService.publicKey)\(ApiService.privateKey)".md5()
        let urlString = "https://gateway.marvel.com/v1/public/characters/\(characterId)/\(section)?ts=\(ts)&hash=\(hash!)&apikey=\(ApiService.privateKey)"
        guard let url = URL.init(string: urlString) else {
            return completion(.failure(ApiError.invalidURL))
        }
        
        session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data, let response = response as? HTTPURLResponse else {
                    completion(.failure(ApiError.invalidResponse))
                    return
                }

                do {
                    if response.statusCode == 200 {
                        let details = try JSONDecoder().decode(DetailResponse.self, from: data)
                        completion(.success(details))
                        return
                    }
                    completion(.failure(ApiError.invalidResponse))

                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
