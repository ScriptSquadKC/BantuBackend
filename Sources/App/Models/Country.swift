//
//  File.swift
//  
//
//  Created by Marcos on 7/4/24.
//

import Foundation

import Vapor
import Fluent

final class Country: Model {
    init() {
    }
    
    //Name of the table
    static let schema = "countries"
    
    @ID(custom: "id", generatedBy: .database)
    var id: Int?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "active")
    var active: Bool
    
    
    init(id: Int? = nil, name: String, active: Bool) {
        self.id = id
        self.name = name
        self.active = active
    }
}



