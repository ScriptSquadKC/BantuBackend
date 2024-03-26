import Fluent
import Vapor

func routes(_ app: Application) throws {
    //Healt check
        app.get { req async in
        "It works!"
    }

    
    
    //Put in this middleware the endpoints that need the token

   // try app.register(collection: TodoController())
}
