//
//  ViewController.swift
//  Property-List
//
//  Created by Samuel on 2019-05-29.
//  Copyright © 2019 Samuel Lavasani. All rights reserved.
//

import UIKit

class PropertyVC: UITableViewController {
    
    let jsonUrlString = "https://www.booli.se/public/search-results.json"
    let cellID = "PropertyCell"
    var favouriteProperties : [Property] = []
    var allProperties : [Property] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "PropertyCell", bundle: nil), forCellReuseIdentifier: cellID)
        getAllProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favouriteProperties = PropertyHelper.getFavouritesFromUserDefaults()
        tableView.reloadData()
    }
    
    func getAllProperties() {
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            if let error = error {
                self?.showErrorAlertMessage(message: error.localizedDescription, title: "Property error")
                return
            }
            
            guard let data = data else { return }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            if (httpResponse.statusCode == 200) {
                do {
                    let propertyResponse = try JSONDecoder().decode(PropertyResponse.self, from: data)
                    self?.allProperties = propertyResponse.results
                    self?.getThumbNailData()
                } catch {
                    self?.showErrorAlertMessage(message: error.localizedDescription, title: "Property error")
                    print("Error:\(error)")
                }
            } else {
                self?.showErrorAlertMessage(message: "Server error", title: "Property error")
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            }.resume()
    }
    
    func getThumbNailData() {
        for i in 0..<allProperties.count {
            let urlString = allProperties[i].thumb
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url){ [weak self] (data, response, error) in
                
                if let error = error {
                    self?.showErrorAlertMessage(message: error.localizedDescription, title: "Thumbnail error")
                    return
                }
                
                guard let data = data else { return }
                guard let httpResponse = response as? HTTPURLResponse else { return }
                
                if(httpResponse.statusCode == 200) {
                    self?.allProperties[i].thumbNailData = data
                } else {
                    self?.showErrorAlertMessage(message: "Server error", title: "Thumbnail error")
                }
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                }.resume()
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allProperties.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyCell", for: indexPath) as!
        PropertyCell
        let property = allProperties[indexPath.row]
        cell.delegate = self
        cell.setProperty(property: property)
        cell.favouriteButton.isSelected = PropertyHelper.isFavouriteProperty(property: property, favourites: favouriteProperties)
        return cell
    }
}

    // MARK: - Delegates

extension PropertyVC: PropertyCellDelegate {
    
    func didTapFavouriteButton(property: Property) {
        if PropertyHelper.isFavouriteProperty(property: property, favourites: favouriteProperties) {
            favouriteProperties.removeAll { (favProperty) -> Bool in
                favProperty.booliId == property.booliId
            }
        } else {
            favouriteProperties.append(property)
        }
        tableView.reloadData()
        PropertyHelper.saveFavouritesInUserDefaults(favourites: favouriteProperties)
    }
}

extension UIViewController {
    
    func showErrorAlertMessage(message: String, title: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}

