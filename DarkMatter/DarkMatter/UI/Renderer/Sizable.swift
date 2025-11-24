//
//  Sizable.swift
//  DarkMatter
//
//  Created by Sergey on 25.11.2025.
//

protocol Sizable {
    static var size: Int { get }
    static var stride: Int { get }
}

extension Sizable {
    static var size: Int {
        MemoryLayout<Self>.size
    }
    
    static var stride: Int {
        MemoryLayout<Self>.stride
    }
}
