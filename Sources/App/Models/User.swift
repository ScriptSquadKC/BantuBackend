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
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Timestamp(key: "last_connection", on: .create, format: .iso8601)
    var latsConnection: Date?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    init(id: UUID? = nil, name: String, latsConnection: Date? = nil, email: String, password: String) {
        self.id = id
        self.name = name
        self.latsConnection = latsConnection
        self.email = email
        self.password = password
    }
}

extension User: ModelAuthenticatable {
    static var usernameKey = \User.$email
    static var passwordHashKey = \User.$password
    
    func verify(password: String) throws -> Bool {
        
        try Bcrypt.verify(password, created: self.password)
        
    }
}
