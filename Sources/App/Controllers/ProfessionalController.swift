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
            builder.get(":id", use: getProfessionalById)
        }
    }
}



extension ProfessionalController {
    
    func getAllProfessionals(req: Request) async throws -> [Professional.Public] {
             let professionals = try await Professional.query(on: req.db)
                .with(\.$pro_User)
                .with(\.$pro_Type)
                .filter(\.$active == true)
                .with(\.$pro_User)
                .all()
                
           return professionals.map { prof in
                prof.convertToPublic()
            }
        }
    
    func getProfessionalById(req: Request) async throws -> Professional.Public {
        guard let professionalIDString = req.parameters.get("id"), let professionalID = Int(professionalIDString) else {
            throw Abort(.badRequest)
        }
        
        let professional = try await Professional.query(on: req.db)
           .with(\.$pro_User)
           .with(\.$pro_Type)
           .filter(\.$id == professionalID)
           .first()
                
        guard let foundProfessional = professional else {
                throw Abort(.notFound)
            }
        
        
        return foundProfessional.convertToPublic()
    }
    

}

