//
//  MenuUserSettings.swift
//  Gambit
//
//  Created by Муслим Курбанов on 23.12.2020.
//

import Foundation

class CartManager {
    static let shared = CartManager()
    private init() {}
    
    private let defaults = UserDefaults.standard
    private let menuKey = "MENU_PRODUCT"
    
    var dishesIds: [Int: Int] {
        guard let decoded  = defaults.object(forKey: menuKey) as? Data else { return [:] }
        let array = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? [Int: Int]
        return array ?? [:]
    }
    
    func getDishCount(by id: Int) -> Int? {
        return dishesIds[id]
    }
    
    func plusDishes(_ id: Int) {
        var dishesCopy = dishesIds
        if dishesCopy[id] != nil {
            dishesCopy[id]! += 1
        } else {
            dishesCopy[id] = 1
        }
        
        let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: dishesCopy, requiringSecureCoding: false)
        defaults.set(encodedData, forKey: menuKey)
    }
    
    func minusDishes(_ id: Int) {
        var dishesCopy = dishesIds
        if dishesCopy[id] != nil {
            dishesCopy[id]! -= 1
            
            if dishesCopy[id]! == 0 {
                dishesCopy[id] = nil
            }
        }
        
        let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: dishesCopy, requiringSecureCoding: false)
        defaults.set(encodedData, forKey: menuKey)
    }
}

class FavoriteManager {
    static let shared = FavoriteManager()
    private init() {}
    
    private let defaults = UserDefaults.standard
    private let menuKey = "LIKE_PRODUCT"
    
    var dishesIds: [Int] {
        let array  = defaults.object(forKey: menuKey) as? [Int]
//        let array = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? [Int]
        return array ?? []
    }
    
    func addToFavoriteProduct(_ id: Int) -> Bool {
        return dishesIds.contains(id)
    }
    
    func selectFavorite(by id: Int) -> Bool {
        var added: Bool
        var dishesCopy = dishesIds
        
        if dishesCopy.contains(id), let index = dishesCopy.firstIndex(of: id) {
            dishesCopy.remove(at: index)
            added = false
        } else {
            dishesCopy.append(id)
            added = true
        }
        defaults.set(dishesCopy, forKey: menuKey)
        return added
    }
    
    
}
