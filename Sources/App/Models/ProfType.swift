//
//  ProfType.swift
//
//
//  Created by mnanton on 15/4/24.
//

import Vapor
import Fluent

final class ProTypes: Model {
    init() {
    }
    
    //Name of the table
    static let schema = "pro_types"
    
    @ID(custom: "type_id", generatedBy: .database)
    var id: Int?
    
    @Field(key: "type")
    var type: String
    
    @Field(key: "active")
    var active: Bool
    
    
    init(id: Int? = nil, type: String, active: Bool) {
        self.id = id
        self.type = type
        self.active = active
    }
}

extension ProTypes {
    
    struct Public: Content {
        let id: Int
        let type: String
        let active: Bool
    }
    
    func convertToPublic() -> ProTypes.Public {
        return ProTypes.Public(id: self.id ?? 1, type: self.type, active: self.active)
       }
}
