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
        routes.group("professionals") { builder in
            builder.get("all", use: getAllProfessionals)
        }
    }
}



extension ProfessionalController {
    
    func getAllProfessionals(req: Request) async throws -> [Professional.Public] {
             let professionals = try await Professional.query(on: req.db)
                .filter(\.$active == true)
                .with(\.$pro_User)
                .all()
        
        print("PROFESSIONALS ---->", professionals)
        
                    
    //        Transform Conutry into Country.public and returns the list
           return professionals.map { prof in
                prof.convertToPublic()
            }
                
        }
}

