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
    
    @ID(custom: "country_id", generatedBy: .database)
    var id: Int?
    
    @Field(key: "country")
    var country: String
    
    @Field(key: "active")
    var active: Bool
    
    
    init(country_id: Int? = nil, country: String, active: Bool) {
        self.id = country_id
        self.country = country
        self.active = active
    }
}



