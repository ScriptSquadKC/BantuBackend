//
//  File.swift
//  
//
//  Created by Marcos on 25/3/24.
//

import Vapor

struct APIKeyMiddleware: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: Vapor.AsyncResponder) async throws -> Vapor.Response {
        
        //get apikey from headers
        guard let apiKey = request.headers.first(name: "CDS-ApiKey") else {
            throw Abort(.badRequest, reason: "ApiKey header is missing")
        }
        //Get the apikey from enviroment
        guard let envApiKey = Environment.process.API_KEY else {
            throw Abort(.failedDependency)
        }
        //Compare the apikeys
        guard apiKey == envApiKey else {
            throw Abort(.unauthorized, reason: "Invalid APi key")
        }
        
        return try await next.respond(to: request)
    }
    
    
    
}
