//
//  ProSuscription.swift
//
//
//  Created by mnanton on 15/4/24.
//

import Vapor
import Fluent

final class ProSuscription: Model {
    init() {
    }
    
    //Name of the table
    static let schema = "pro_suscriptions"
    
    @ID(custom: "suscription_id", generatedBy: .database)
    var id: Int?
    
    @Field(key: "suscription")
    var suscription: String
    
    @Field(key: "active")
    var active: Bool
    
    
    init(id: Int? = nil, type: String, active: Bool) {
        self.id = id
        self.suscription = type
        self.active = active
    }
}

extension ProSuscription {
    
    struct Public: Content {
        let id: Int
        let suscription: String
        let active: Bool
    }
    
    func convertToPublic() -> ProSuscription.Public {
        return ProSuscription.Public(id: self.id ?? 1, suscription: self.suscription, active: self.active)
       }
}
