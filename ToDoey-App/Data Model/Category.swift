//
//  Category.swift
//  Todoey
//
//  Created by Admin on 14/08/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colorName: String = ""
    let items = List<Item>()
}
