//
//  File.swift
//  
//
//  Created by Marcos on 26/3/24.
//

import Vapor
import Fluent

struct AuthController: RouteCollection{
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.group("auth") { builder in
            //TODO: Add signup out of the builder
            builder.post("signup", use: createUser)
            
            //Protected by user and password
            builder.group(User.authenticator(), User.guardMiddleware()) { builder in
                builder.get("signin", use: signIn)
            }
            
            //Protected by token
            builder.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
                builder.get("refresh", use: refreshToken)
            }
        }
    }
    
    
}

extension AuthController{
    
    func createUser(req: Request) async throws -> User.Public {
        print(req)
//        Checks if the request is valid
        try User.Create.validate(content: req)
        
        let receivedUser = try req.content.decode(User.Create.self)

        let hasedhPassword = try req.password.hash(receivedUser.password)
        
        //Try yo get the province

        guard let provinceExist = try await Province.find(receivedUser.provinceId, on: req.db) else{
            throw Abort(.notFound)
        }
        
        guard let countryExist = try await Country.find(receivedUser.countryId, on: req.db) else{
            throw Abort(.notFound)
        }
        
        
        let user = User(
            name: receivedUser.name,
            email: receivedUser.email,
            password: hasedhPassword,
            lastName1: receivedUser.lastName1,
            lastName2: receivedUser.lastName2,
            postalCode: receivedUser.postalCode,
            city: receivedUser.city,
            active: receivedUser.active ?? true,
            avatar: receivedUser.avatar ?? "defaultAvatar"
        )
        
        user.$province.id = try provinceExist.requireID()
        user.$country.id = try countryExist.requireID()
        
        try await user.create(on: req.db)
                
        //Try to get the user updated
        guard let createdUser = try await User.find(user.requireID(), on: req.db) else {
            throw Abort(.notFound)
        }
                    
        return User.Public(
            id: createdUser.id ?? 0,
            name: createdUser.name,
            email: createdUser.email,
            lastName1: createdUser.lastName1,
            lastName2: createdUser.lastName2,
            provinceId: createdUser.$province.id,
            countryId: createdUser.$country.id,
            city: createdUser.city ?? "",
            postalCode: createdUser.postalCode,
            active: createdUser.active
        )
    }
    
    func signIn(req: Request) async throws -> JWTToken.Public {
        //Get the user
        let user = try req.auth.require(User.self)
        return try await generateToken(req: req, user: user)
    }
    
    func refreshToken(req: Request) async throws -> JWTToken.Public {
        //Get refresh token
        let token = try req.auth.require(JWTToken.self)
        
        guard token.type == .refresh else {
            throw Abort(.methodNotAllowed, reason: "Wrong token type, expecting refresh")
        }
        //Find user in the DDBB
        guard let user = try await User.find(Int(token.sub.value), on: req.db) else{
            throw Abort(.unauthorized, reason: "User not found")
        }
        
        return try await generateToken(req: req, user: user)
    }
    
    
}

extension AuthController {
    
    func generateToken(req: Request, user: User ) async throws -> JWTToken.Public{

        let tokens = JWTToken.generateToken(userID: user.id!)
        let accesSigned = try req.jwt.sign(tokens.accessToken)
        let refreshSigned = try req.jwt.sign(tokens.refreshToken)
        
        return JWTToken.Public(accesToken: accesSigned, refreshToken: refreshSigned)
    }
}
