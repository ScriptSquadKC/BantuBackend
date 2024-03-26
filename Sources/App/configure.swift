import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    /* Configure when we upload the db
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    app.migrations.add(CreateTodo())
     */
    
    guard let jwtKey = Environment.process.JWT_KEY else {
        fatalError("JWT_KEY not found")
    }
    
    guard let _ = Environment.process.API_KEY else {
        fatalError("API_KEY not found")
    }
    guard let dbURL = Environment.process.DATABASE_URL else {
        fatalError("DATABASE_URL not found")
    }

    //Configure DB
    try app.databases.use(.postgres(url: dbURL), as: .psql)


    // register routes
    try routes(app)
}
