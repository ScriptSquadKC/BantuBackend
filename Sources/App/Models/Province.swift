//
//  File.swift
//
//
//  Created by Marcos on 7/4/24.
//

import Foundation

import Vapor
import Fluent

final class Province: Model {
    init() {
    }
    
    //Name of the table
    static let schema = "provinces"
    
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

extension Province {
    
    struct Public: Content {
        let id: Int
        let name: String
        let active: Bool
    }
    
    func convertToPublic() -> Province.Public {
           return Province.Public(id: self.id ?? 0, name: self.name, active: self.active)
       }
}




