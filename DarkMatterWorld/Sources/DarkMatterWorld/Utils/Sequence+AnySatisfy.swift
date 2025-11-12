//
//  Sequence+AnySatisfy.swift
//  DarkMatterWorld
//
//  Created by Sergey on 11.11.2025.
//

import Foundation

/* never used
extension Sequence {
    /// Returns `true` if at least one element satisfies condition in the `predicate`.
    /// Otherwise returns `false`
    func anySatisfy(_ predicate: (Element) -> Bool) -> Bool {
        if let _ = self.min(by: { _, _ in true }) {
            for element in self {
                if predicate(element) {
                    return true
                }
            }
        }
        return false
    }
}
*/
