//
//  Todo+CoreDataProperties.swift
//  Todo-Test
//
//  Created by mitchell hudson on 11/15/15.
//  Copyright © 2015 mitchell hudson. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Todo {

    @NSManaged var name: String?
    @NSManaged var completed: Bool

}
