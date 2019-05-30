//
//  Helper.swift
//  Property-List
//
//  Created by Samuel on 2019-05-29.
//  Copyright © 2019 Samuel Lavasani. All rights reserved.
//

import UIKit

class PropertyHelper {
    
    static func saveFavouritesInUserDefaults(favourites: [Property]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(favourites) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedProperties")
        }
    }
    
    static func getFavouritesFromUserDefaults() -> [Property] {
        let defaults = UserDefaults.standard
        if let savedProperties = defaults.object(forKey: "SavedProperties") as? Data {
            let decoder = JSONDecoder()
            if let favouriteProperties = try? decoder.decode([Property].self, from: savedProperties) {
                
                return favouriteProperties
            }
        }
        return []
    }
    
    static func isFavouriteProperty(property: Property, favourites: [Property]) -> Bool {
        return favourites.contains(where: { (prop) -> Bool in
            prop.booliId == property.booliId
        })
    }
    
}
