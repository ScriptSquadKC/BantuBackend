//
//  File.swift
//  
//
//  Created by Marcos on 25/3/24.
//

import Vapor

struct AuthMiddleware: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: Vapor.AsyncResponder) async throws -> Vapor.Response {
        
        //get the token from headers
        guard let authToken = request.headers.first(name: "Authorization") else {
            throw Abort(.badRequest, reason: "Token is missing")
        }
        
        // remove the prefix "Bearer "
         guard let token = authToken.split(separator: " ").last else {
             throw Abort(.badRequest, reason: "Invalid authorization header")
         }
        
        do {
                   // Verificar el token JWT
                   let jwtVerifier = try request.jwt.verify(JWTToken.self)
                   try jwtVerifier.verify(token)
                   
                   // Token válido, continuar con la solicitud
                   return next.respond(to: request)
               } catch {
                   return request.eventLoop.makeFailedFuture(Abort(.unauthorized, reason: "Invalid token"))
               }
   
    }
    
    
    
}
