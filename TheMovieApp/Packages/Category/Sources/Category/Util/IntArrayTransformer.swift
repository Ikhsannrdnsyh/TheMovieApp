//
//  IntArrayTransformer.swift
//  Category
//
//  Created by Mochamad Ikhsan Nurdiansyah on 07/04/25.
//

import Foundation

import Foundation

public class IntArrayTransformer: ValueTransformer {
    public override class func allowsReverseTransformation() -> Bool {
        return true
    }

    public override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    public override func transformedValue(_ value: Any?) -> Any? {
        guard let intArray = value as? [Int] else { return nil }
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: intArray, requiringSecureCoding: true)
        } catch {
            print("Failed to transform value: \(error)")
            return nil
        }
    }

    public override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSNumber.self], from: data) as? [Int]
        } catch {
            print("Failed to reverse transform value: \(error)")
            return nil
        }
    }
}
