//
//  FavoritesService.swift
//  Marvel
//
//  Created by shuynh on 9/16/21.
//

import UIKit

class FavoritesService {
    static let shared = FavoritesService()
    
    private var favorites = [Character]()
    private init() {
        favorites = UserDefaults.standard.loadFavorites()
    }
    
    func addFavorite(_ character: Character) {
        if isFavorite(character) { return }
        favorites.append(character)
        UserDefaults.standard.saveFavorites(favorites)
    }
    
    func deleteFavorite(_ character: Character) {
        if let index = favorites.firstIndex(where: {$0.id == character.id}) {
            favorites.remove(at: index)
            UserDefaults.standard.saveFavorites(favorites)
        }
    }
    
    func isFavorite(_ character: Character) -> Bool {
        return favorites.contains(where: {$0.id == character.id})
    }

}
