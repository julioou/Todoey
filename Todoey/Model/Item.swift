//
//  Item.swift
//  Todoey
//
//  Created by Treinamento on 9/4/19.
//  Copyright © 2019 trainee. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated : Date?
    let parentRelationship = LinkingObjects(fromType: Category.self, property: "items")
    
}
