//
//  UserDefaults.swift
//  Marvel
//
//  Created by shuynh on 9/16/21.
//

import UIKit

extension UserDefaults {
    func saveFavorites(_ favorites: [Character]) {
        do {
            let data = try JSONEncoder().encode(favorites)
            set(data, forKey: "favorites")
        } catch {
            print("Unable to Encode Array of Character (\(error))")
        }
    }
    
    func loadFavorites() -> [Character] {
        if let data = data(forKey: "favorites") {
            do {
                let favorites = try JSONDecoder().decode([Character].self, from: data)
                return favorites

            } catch {
                print("Unable to Decode Favorite Characters (\(error))")
            }
        }
        
        return [];
    }
}
