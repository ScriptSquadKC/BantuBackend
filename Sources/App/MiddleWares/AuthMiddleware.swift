//
//  File.swift
//  
//
//  Created by Marcos on 25/3/24.
//

import Vapor

struct AuthMiddleware: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: Vapor.AsyncResponder) async throws -> Vapor.Response {
                
        do {
                // Extract token from headers
                guard let token = request.headers.first(name: "Authorization") else {
                    throw Abort(.unauthorized, reason: "Missing Authorization header")
                }
            
            guard let bearerRange = token.range(of: "Bearer ") else {
                throw Abort(.unauthorized, reason: "Invalid Authorization header format")
            }
            
            let cleanToken = token.replacingCharacters(in: bearerRange, with: "")
            
                   // Verify and decode token
                   let _ = try request.jwt.verify(cleanToken, as: JWTToken.self)
            
                   
                   // Token is valid
                return try await next.respond(to: request)
            
               } catch {
                   throw Abort(.unauthorized, reason: "Invalid token")
               }

    }
    
}
