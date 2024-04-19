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
            builder.post("signup", use: createUser)
            
            //Protected by user and password
            builder.group(User.authenticator(), User.guardMiddleware()) { builder in
                builder.post("signin", use: signIn)
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
        
        //Checks if the email exist
        let existingEmail = try await User.query(on: req.db).filter(\.$email == receivedUser.email).first().get()
        
       if existingEmail != nil {
           throw Abort(.custom(code: 409, reasonPhrase: "Duplicated email"))
        }
        
        //Try to get the province
        guard let provinceExist = try await Province.find(receivedUser.provinceId, on: req.db) else{
            throw Abort(.notFound)
        }
        //Try to get the country
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
            nickname: receivedUser.nickname ?? "defaultAvatar",
            photo: receivedUser.photo ?? "http://90.163.132.130:8090/bantu/user00.png"
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
            nickname: createdUser.nickname,
            photo: createdUser.photo,
            active: createdUser.active
        )
    }
    
    func signIn(req: Request) async throws -> JWTToken.Public {
        //Get the user
        let user = try req.auth.require(User.self)
        let token = try await generateToken(req: req, user: user)
        
        guard let userId = user.id else {
            throw Abort(.expectationFailed, reason: "User not found")
        }
       
        return JWTToken.Public(accesToken: token.accesToken, refreshToken: token.refreshToken, userId: userId )
    }
    
    func refreshToken(req: Request) async throws -> JWTToken.Intern {
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
    
    func generateToken(req: Request, user: User ) async throws -> JWTToken.Intern{

        let tokens = JWTToken.generateToken(userID: user.id!)
        let accesSigned = try req.jwt.sign(tokens.accessToken)
        let refreshSigned = try req.jwt.sign(tokens.refreshToken)
        
        return JWTToken.Intern(accesToken: accesSigned, refreshToken: refreshSigned)
    }
}
