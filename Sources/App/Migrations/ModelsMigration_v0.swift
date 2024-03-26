//
//  File.swift
//  
//
//  Created by Marcos on 26/3/24.
//

import Vapor
import Fluent

struct ModelsMigration_v0: AsyncMigration{
    func prepare(on database: FluentKit.Database) async throws {
        //TODO: Change with the correct model
        try await database
            .schema(User.schema)
            .id()
            .field("name", .string, .required)
            .field("last_connection", .string )
            .field("email", .string, .required)
            .field("password", .string, .required)
            .unique(on: "email")
            .create()
        
        }
    
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema(User.schema).delete()
    }
    
    

    
    
    
    
}
