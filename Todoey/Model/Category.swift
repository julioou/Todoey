//
//  Category.swift
//  Todoey
//
//  Created by Treinamento on 9/4/19.
//  Copyright © 2019 trainee. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var colour : String = ""
    let items = List<Item>()
    
}
