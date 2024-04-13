import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    
    guard let jwtKey = Environment.process.JWT_KEY else {
        fatalError("JWT_KEY not found")
    }
    
    guard let _ = Environment.process.API_KEY else {
        fatalError("API_KEY not found")
    }


    //Configure DB
    guard let dbHost = Environment.get("DATABASE_HOST") else {
        fatalError("DATABASE_HOST not found")
    }
    guard let dbPort = Environment.get("DB_PORT") else {
        fatalError("Database port not found")
    }
    guard let dbName = Environment.get("DB_NAME") else {
        fatalError("Database name not found")
    }
    guard let dbUser = Environment.get("DB_USER") else {
        fatalError("Database user not found")
    }
    guard let dbPassword = Environment.get("DB_PASSWORD") else {
        fatalError("Database password not found")
    }
    guard let dbSchema = Environment.get("DB_SCHEMA") else {
        fatalError("Database schema not found")
    }
   
    
    
    let dbURL = "postgres://\(dbUser):\(dbPassword)@\(dbHost):\(dbPort)/\(dbName)"

    try app.databases.use(.postgres(url: dbURL), as: .psql)
    

    
    //Configure passwords hashes
    app.passwords.use(.bcrypt)
    
    //Configure JWT
    app.jwt.signers.use(.hs256(key: jwtKey))
    
    //Migrations
    //To run the migrations swift run App migrate
    app.migrations.add(ModelsMigration_v0())


    // register routes
    try routes(app)
}
