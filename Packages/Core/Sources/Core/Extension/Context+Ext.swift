//
//  Context+Ext.swift
//  Core
//
//  Created by Mochamad Ikhsan Nurdiansyah on 16/03/25.
//

import CoreData

extension NSManagedObjectContext {
    public func fetchObjects<T: NSManagedObject>(ofType: T.Type) -> [T] {
        let request = T.fetchRequest()
        do {
            let results = try self.fetch(request) as? [T]
            return results ?? []
        } catch {
            print("Error fetching objects: \(error.localizedDescription)")
            return []
        }
    }
}
