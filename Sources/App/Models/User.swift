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
 
    @Field(key: "nickname")
    var nickname: String
    
    @Field(key: "photo")
    var photo: String?
    
    @Field(key: "active")
    var active: Bool
    
    @Field(key: "password")
    var password: String
    
    @Timestamp(key: "creation_date", on: .create)
    var creationDate: Date?
    
    @Timestamp(key: "leaving_date", on: .none)
    var leavingDate: Date?
    
    
    
    init(id: Int? = nil, name: String, email: String, password: String, lastName1: String, lastName2: String, postalCode: String? = "", city: String? = "", active: Bool, nickname: String, photo: String?, creationDate: Date? = nil, leavingDate: Date? = nil ) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.active = active
        self.nickname = nickname
        self.photo = photo ?? "http://90.163.132.130:8090/bantu/user00.png"
        self.lastName1 = lastName1
        self.lastName2 = lastName2
        self.creationDate = creationDate
        self.leavingDate = leavingDate
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
        let name: String?
        let email: String
        let lastName1: String?
        let lastName2: String?
        let provinceId: Int?
        let countryId: Int?
        let city: String?
        let postalCode: String?
        let nickname: String?
        let photo: String
        let active: Bool
        let professional: Professional?
    }
    
    func convertToPublic(professional: Professional? = nil) -> User.Public {
        return User.Public(id: self.id ?? 0,name: self.name , email: self.email, lastName1: self.lastName1 , lastName2: self.lastName2 , provinceId: self.province.id ?? 1, countryId: self.country.id ?? 1, city: self.city ?? "", postalCode: self.postalCode ?? "", nickname: self.nickname , photo: self.photo ?? "", active: self.active, professional: professional )
       }
    
    struct Create: Content, Validatable {
        let name: String?
        let email: String
        let password: String
        let lastName1: String?
        let lastName2: String?
        let provinceId: Int?
        let countryId: Int?
        let city: String?
        let postalCode: String?
        let nickname: String
        let photo: String?
        let active: Bool?
        let isProfessional: Bool?
        
        static func validations(_ validations: inout Vapor.Validations) {
            validations.add("nickname", as: String.self, is: !.empty, required: true, customFailureDescription: "Invalid nickname")
            validations.add("email", as: String.self, is: .email, required: true, customFailureDescription: "Invalid email")
            validations.add("password", as: String.self, is: .count(6...), required: true, customFailureDescription: "Invalid password")
        }
    }
    
}


extension User {
    
    struct GetAllResponse: Content {
        let id: Int
        let name: String?
        let email: String
        let lastName1: String?
        let lastName2: String?
        let provinceId: Int
        let countryId: Int
        let city: String?
        let postalCode: String?
        let nickname: String?
        let photo: String
    }
    
    func convertToGetAllResponse() -> User.GetAllResponse {
        return User.GetAllResponse(id: self.id ?? 0,name: self.name , email: self.email, lastName1: self.lastName1 , lastName2: self.lastName2 , provinceId: self.province.id ?? 1, countryId: self.country.id ?? 1, city: self.city ?? "", postalCode: self.postalCode ?? "", nickname: self.nickname , photo: self.photo ?? "" )
       }
    
}
