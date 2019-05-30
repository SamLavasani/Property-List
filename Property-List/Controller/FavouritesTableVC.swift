//
//  FavouriteTableVC.swift
//  Property-List
//
//  Created by Samuel on 2019-05-29.
//  Copyright © 2019 Samuel Lavasani. All rights reserved.
//

import UIKit

class FavouritesTableVC: UITableViewController {
    
    var favourites : [Property] = []
    let cellID = "PropertyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PropertyCell", bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favourites = PropertyHelper.getFavouritesFromUserDefaults()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyCell", for: indexPath) as!
        PropertyCell
        let property = favourites[indexPath.row]
        cell.delegate = self
        cell.setProperty(property: property)
        cell.favouriteButton.isSelected = PropertyHelper.isFavouriteProperty(property: property, favourites: favourites)
        return cell
    }
    
}

    // MARK: - Delegates
extension FavouritesTableVC: PropertyCellDelegate {
    
    func didTapFavouriteButton(property: Property) {
        if PropertyHelper.isFavouriteProperty(property: property, favourites: favourites) {
            favourites.removeAll { (favProperty) -> Bool in
                favProperty.booliId == property.booliId
            }
        } else {
            favourites.append(property)
        }
        //tableView.reloadData()
        PropertyHelper.saveFavouritesInUserDefaults(favourites: favourites)
    }

}
