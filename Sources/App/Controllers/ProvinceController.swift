//
//  File.swift
//  
//
//  Created by Marcos on 8/4/24.
//

import Vapor
import Fluent

struct ProvinceController: RouteCollection{
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.group("provinces") { builder in
            
            builder.get(":id", use: getProvinceByID)
            

        }
    }
    
    
}


extension ProvinceController {
    
    func getAllProvinces(){
        
    }
    
    func getProvinceByID(req: Request) async throws -> Province.Public {
        guard let provinceIDString = req.parameters.get("id"), let provinceID = Int(provinceIDString) else {
            throw Abort(.badRequest)
        }
        
        let province = try await Province.find(provinceID, on: req.db)
        
        guard let foundProvince = province else {
                throw Abort(.notFound)
            }
        return foundProvince.convertToPublic()
    }
}
