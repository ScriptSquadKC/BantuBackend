//
//  File.swift
//  
//
//  Created by Marcos on 15/4/24.
//

import Vapor
import Fluent

struct ProfessionalController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.group("professional") { builder in
            builder.post("all", use: getAllProfessionals)
        }
    }
}



extension ProfessionalController {
    
    func getAllProfessionals(req: Request) async throws -> [Professional.Public] {
        
        
        
    }
    
    
}

