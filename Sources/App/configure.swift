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
    let dbHost = "90.163.132.130"
    let dbPort = 5432
    let dbName = "bantuDB"
    let dbUser = Environment.get("DB_USER") ?? ""
    let dbPassword = Environment.get("DB_PASSWORD") ?? ""
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
