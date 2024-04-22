//
//  File.swift
//  
//
//  Created by Marcos on 20/4/24.
//


import Vapor
import Fluent

struct UserController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.group("users") { builder in
            builder.get("all", use: getAllUsers)
            builder.get(":id", use: getUserById)
        }
    }
}



extension UserController {
    
    func getAllUsers(req: Request) async throws -> [User.GetAllResponse] {
        let users = try await User.query(on: req.db)
            .filter(\.$active == true)
            .with(\.$province)
            .with(\.$country)
            .all()
                

        
           return  users.map { user in
               return user.convertToGetAllResponse()
            }
        }
    
    func getUserById(req: Request) async throws -> User.Public {
        guard let userIDString = req.parameters.get("id"), let userID = Int(userIDString) else {
            throw Abort(.badRequest)
        }
        
        let user = try await User.query(on: req.db)
            .with(\.$province)
            .with(\.$country)
            .filter(User.self, \.$id == userID)
            .first()
        
        let professional = try await Professional.query(on: req.db)
            .join(User.self, on: \Professional.$pro_User.$id == \User.$id)
            .filter(User.self, \.$id == userID)
            .first()
            .get()
        
        guard let foundUser = user else {
            throw Abort(.notFound)
        }
        
        return foundUser.convertToPublic(professional: professional)
    }
}


