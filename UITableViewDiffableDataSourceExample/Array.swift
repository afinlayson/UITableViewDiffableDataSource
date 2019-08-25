//
//  Array.swift
//  TestDiffable2
//
//  Created by Alex Finlayson on 8/24/19.
//  Copyright © 2019 Wm Alex Finlayson. All rights reserved.
//

import Foundation

extension Array where Element : Hashable {
    
    func duplicates() -> [Element] {
        var duplicates = [Element]()
        var set = Set<Element>()
            
        for item in self {
            if set.contains(item) {
                duplicates.append(item)
            } else {
                set.insert(item)
            }
        }
        return duplicates
    }
}

extension Array where Element : Comparable {
    mutating func insertSort(_ element: Element) {
        let index = self.insertionIndexOf(elem: element) { e1, e2 in
            return e1 < e2
        }
        self.insert(element, at: index)
    }
    
    func insertionIndexOf(elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if isOrderedBefore(self[mid], elem) {
                lo = mid + 1
            } else if isOrderedBefore(elem, self[mid]) {
                hi = mid - 1
            } else {
                return mid // found at position mid
            }
        }
        return lo // not found, would be inserted at position lo
    }
}
