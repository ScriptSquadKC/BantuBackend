//
//  Professional.swift
//  
//
//  Created by mnanton on 15/4/24.
//

import Vapor
import Fluent

final class Professional: Model {
    init() {
        
    
    }
    
    static let schema = "pro_professionals"
    
    @ID(custom: "professional_id", generatedBy: .database)
    var id: Int?
    
    @Parent(key: "id")
    var pro_User: User
    
    @Field(key: "nif")
    var nif: String
    
    @Field(key: "telephone")
    var telephone: Int
    
    @Parent(key: "type_id")
    var pro_Type: ProTypes
    
    @Parent(key: "suscription_id")
    var pro_Suscription: ProSuscription

    @Field(key: "description")
    var description: String?
    
    @Timestamp(key: "creation_date", on: .create)
    var creationDate: Date?
    
    @Timestamp(key: "leaving_date", on: .none)
    var leavingDate: Date?
        
    @Field(key: "active")
    var active: Bool
    
        
    init(id: Int? = nil, nif: String,  telephone: Int, description: String? = "", creationDate: Date? = nil, leavingDate: Date? = nil, active: Bool) {
        self.id = id
        self.nif = nif
        self.telephone = telephone
        self.description = description
        self.creationDate = creationDate
        self.leavingDate = leavingDate
        self.active = active
    }

}

//DTO
extension Professional {
    
    struct Public: Content {
        let id: Int
        let nif: String
        let telephone: Int
        let description: String?
        let creationDate: Date
        let leavingDate: Date
        let active: Bool
    }
    
    struct Create: Content, Validatable {
        let id: Int
        let nif: String
        let telephone: Int
        let type_id: Int
        let suscription_id: String
        let description: String?
        let active: Bool?
        
        static func validations(_ validations: inout Vapor.Validations) {
            
            validations.add("nif", as: String.self, is: !.empty, required: true, customFailureDescription: "Invalid nif")
            validations.add("telephone", as: String.self, is: !.empty, required: true, customFailureDescription: "Invalid telephone")
    
        }
    }
}
