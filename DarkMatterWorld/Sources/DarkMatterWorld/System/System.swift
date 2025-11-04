//
//  System.swift
//  DarkMatterWorld
//
//  Created by Sergey on 05.11.2025.
//

import Foundation

public protocol System {
    var query: Query { get }
    
    func run(command: Command, queryResult: any QueryResult)
}
