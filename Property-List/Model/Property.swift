//
//  Property.swift
//  Property-List
//
//  Created by Samuel on 2019-05-29.
//  Copyright © 2019 Samuel Lavasani. All rights reserved.
//

import UIKit

struct PropertyResponse : Codable {
    let count : Int
    let results : [Property]
}

struct Property : Codable {
    let booliId : Int
    let listPrice : Int
    let published : String
    let streetAddress : String
    let objectType : String
    let daysActive : Int
    let rooms : Int
    let livingArea : Int
    let constructionYear : Int
    let thumb : String
    var thumbNailData : Data?
}
