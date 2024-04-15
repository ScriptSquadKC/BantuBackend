//
//  File.swift
//  
//
//  Created by Marcos on 12/4/24.
//

import Vapor
import Fluent

struct CountryController: RouteCollection{
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.group("countries") { builder in
            builder.get("all/", use: getAllCountries)
            builder.get(":id", "/", use: getCountryByID)
        }
    }
    
    
}


extension CountryController {
    
    func getAllCountries(req: Request) async throws -> [Country.Public]{
         let countries = try await Country.query(on: req.db)
            .filter(\.$active == true)
            .sort(\.$country)
            .all()
                
//        Transform Conutry into Country.public and returns the list
       return countries.map { country in
            country.convertToPublic()
        }
            
    }
    
    func getCountryByID(req: Request) async throws -> Country.Public {
        guard let countryIDString = req.parameters.get("id"), let countryID = Int(countryIDString) else {
            throw Abort(.badRequest)
        }
        
        let country = try await Country.find(countryID, on: req.db)
        
        guard let foundCountry = country else {
                throw Abort(.notFound)
            }
        return foundCountry.convertToPublic()
    }
}

