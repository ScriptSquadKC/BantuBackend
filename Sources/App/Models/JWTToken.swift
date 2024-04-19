//
//  File 2.swift
//  
//
//  Created by Marcos on 26/3/24.
//

import Vapor
import JWT

enum JWTTokenType: String, Codable {
    case acess
    case refresh
    
}

struct JWTToken: Content, JWTPayload, Authenticatable {
    
    //Payload
    var exp: ExpirationClaim
    var sub: SubjectClaim
    var type: JWTTokenType
    

    
    func verify(using signer: JWTKit.JWTSigner) throws {
        // Token is not expired
        try exp.verifyNotExpired()
        //Validate the subject
        if(sub.value.isEmpty){
            throw JWTError.claimVerificationFailure(name: "sub", reason: "Subject is invalid")
        }
        guard type == .acess || type == .refresh else {
            throw JWTError.claimVerificationFailure(name: "type", reason: "Type is invalid")
        }
        
    }
}

extension JWTToken {
    struct Public: Content {
        let accesToken: String
        let refreshToken: String
        let userId: Int
    }
    
    func convertToPublic(accesToken: String,refreshToken: String ,userID: Int) -> JWTToken.Public {
        return JWTToken.Public(accesToken: accesToken, refreshToken: refreshToken, userId: userID)
       }
}

extension JWTToken {
    struct Intern: Content {
        let accesToken: String
        let refreshToken: String
    }
}

extension JWTToken {
    
    static func generateToken(userID: Int) -> (accessToken: JWTToken, refreshToken: JWTToken){
        var expDate = Date().addingTimeInterval(Constants.accessTokenLifeTime)
        let user = String(userID)
        
        let accessToken = JWTToken(exp: .init(value: expDate), sub: .init(value: user), type: .acess)
        
        expDate = Date().addingTimeInterval(Constants.refreshTokenLifeTime)
        let refreshToken = JWTToken(exp: .init(value: expDate), sub: .init(value: user), type: .refresh)
        
        return (accessToken, refreshToken)
    }
}


