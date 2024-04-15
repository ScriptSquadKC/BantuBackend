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
    
    @ID(custom: "province_id", generatedBy: .database)
    var id: Int?
    
    @Field(key: "country_id")
    var country_id: Int
    
    @Field(key: "province")
    var province: String
    
    @Field(key: "active")
    var active: Bool
    
    
    init(id: Int? = nil, country_id: Int, province: String, active: Bool) {
        self.id = id
        self.country_id = country_id
        self.province = province
        self.active = active
    }
}

extension Province {
    
    struct Public: Content {
        let id: Int
        let province: String
        let active: Bool
    }
    
    func convertToPublic() -> Province.Public {
        return Province.Public(id: self.id ?? 0, province: self.province, active: self.active)
       }
}




