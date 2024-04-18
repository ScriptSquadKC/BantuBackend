import Fluent
import Vapor

func routes(_ app: Application) throws {
    //Healt check
        app.get { req async in
        "It works!"
    }

    try app.group("api"){ builder in
        
        try  builder.register(collection: AuthController())
        try  builder.register(collection: CountryController())
        try  builder.register(collection: ProvinceController())
        //Put in this middleware the endpoints that need the token
        
        try builder.group(AuthMiddleware()) { builder in
            try builder.register(collection: ProfessionalController())
        }
    }
    
    
    
    

}
