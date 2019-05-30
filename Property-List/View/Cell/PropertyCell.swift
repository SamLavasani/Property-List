//
//  PropertyCell.swift
//  Property-List
//
//  Created by Samuel on 2019-05-29.
//  Copyright © 2019 Samuel Lavasani. All rights reserved.
//

import UIKit

protocol PropertyCellDelegate {
    func didTapFavouriteButton(property: Property)
}

class PropertyCell: UITableViewCell {

    
    @IBOutlet weak var thumbNail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var delegate : PropertyCellDelegate?
    var property : Property!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbNail.layer.cornerRadius = thumbNail.bounds.width / 2
    }
    
    func setProperty(property: Property) {
        self.property = property
        self.titleLabel.text = property.streetAddress
        self.priceLabel.text = "\(property.listPrice) SEK"
        if let data = property.thumbNailData {
            self.thumbNail.image = UIImage(data: data)
        }
    }
    
    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.didTapFavouriteButton(property: property)
    }
}
