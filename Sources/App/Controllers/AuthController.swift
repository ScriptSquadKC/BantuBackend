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
            builder.group(User.authenticator(), User.guardMiddleware()) { builder in
                builder.get("signin", use: signIn)
            }
        }
    }
    
    
}

extension AuthController{
    
    func signIn(req: Request) async throws -> JWTToken.Public {
        //Get the user
        let user = try req.auth.require(User.self)
        
        //Generate tokens
        let tokens = JWTToken.generateToken(userID: user.id!)
        let accesSigned = try req.jwt.sign(tokens.accessToken)
        let refreshSigned = try req.jwt.sign(tokens.refreshToken)
        
        return JWTToken.Public(accesToken: accesSigned, refreshToken: refreshSigned)
        
    }
    
    
}
