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
            builder.get("all", use: getAllProvinces)
            builder.get(":id", use: getProvinceByID)
            builder.group("country"){ countryBuilder in
                countryBuilder.get(":countryId", use: getProvincesByCountryID)
                
            }
        }
    }
    
    
}


extension ProvinceController {
    
    func getAllProvinces(req: Request) async throws -> [Province.Public]{
        let provinces = try await Province.query(on: req.db)
           .filter(\.$active == true)
           .sort(\.$province)
           .all()
               
//        Transform Conutry into Country.public and returns the list
      return provinces.map { province in
           province.convertToPublic()
       }
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
    
    func getProvincesByCountryID(req: Request) async throws -> [Province.Public] {
        
        guard let countryIdString = req.parameters.get("countryId"), let countryID = Int(countryIdString) else {
            throw Abort(.badRequest)
        }
                
        let provinces = try await Province.query(on: req.db)
            .filter(\.$country_id == countryID)
            .filter(\.$active == true)
            .sort(\.$province)
            .all()
        
        return provinces.map { province in
             province.convertToPublic()
         }
    }
}
