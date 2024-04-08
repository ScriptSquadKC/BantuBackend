//
//  File.swift
//  
//
//  Created by Marcos on 26/3/24.
//

import Vapor
import Fluent

final class User: Model {
    init() {
        
    
    }
    
    
    //Name of the table
    static let schema = "users"
    
    @ID(custom: "id", generatedBy: .database)
    var id: Int?
    
    @Field(key: "first_name")
    var name: String
    
    @Field(key: "last_name1")
    var lastName1: String
    
    @Field(key: "last_name2")
    var lastName2: String
    
    @Field(key: "postal_code")
    var postalCode: String?
    
    @Parent(key: "province_id")
    var province: Province

    @Field(key: "email")
    var email: String
    
    @Field(key: "city")
    var city: String?
    
    @Parent(key: "country_id")
    var country: Country
    //TODO: See how to do this
    @Field(key: "avatar")
    var avatar: String
    
    @Field(key: "active")
    var active: Bool
    
    @Field(key: "password")
    var password: String
    
    @Timestamp(key: "creation_date", on: .create)
    var creationDate: Date?
    
    @Timestamp(key: "deletion_date", on: .none)
    var deletionDate: Date?
    
    
    
    init(id: Int? = nil, name: String, email: String, password: String, lastName1: String, lastName2: String, postalCode: String? = "", city: String? = "", active: Bool, avatar: String, creationDate: Date? = nil, deletionDate: Date? = nil ) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.active = active
        self.avatar = avatar
        self.lastName1 = lastName1
        self.lastName2 = lastName2
        self.creationDate = creationDate
        self.deletionDate = deletionDate
        self.city = city
        self.postalCode = postalCode
        // No se asignan directamente province y country aquí
    }

}

extension User: ModelAuthenticatable {
    static var usernameKey = \User.$email
    static var passwordHashKey = \User.$password
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

//DTO
extension User {
    
    struct Public: Content {
        let id: Int
        let name: String
        let email: String
        let lastName1: String
        let lastName2: String
        let provinceId: Int
        let countryId: Int 
        let city: String?
        let postalCode: String?
        let active: Bool
    }
    
    struct Create: Content, Validatable {
        let name: String
        let email: String
        let password: String
        let lastName1: String
        let lastName2: String
        let provinceId: Int
        let countryId: Int
        let city: String?
        let postalCode: String?
        let avatar: String?
        let active: Bool?
        
        static func validations(_ validations: inout Vapor.Validations) {
            validations.add("name", as: String.self, is: !.empty, required: true, customFailureDescription: "Invalid name")
            validations.add("lastName1", as: String.self, is: !.empty, required: true, customFailureDescription: "Invalid last_name1")
            validations.add("lastName2", as: String.self, is: !.empty, required: true, customFailureDescription: "Invalid last_name2")
            //validations.add("province_id", as: Int.self, is: , required: true, customFailureDescription: "Invalid province")
            validations.add("email", as: String.self, is: .email, required: true, customFailureDescription: "Invalid email")
            validations.add("password", as: String.self, is: .count(6...), required: true, customFailureDescription: "Invalid password")
        }
    }
    
}
