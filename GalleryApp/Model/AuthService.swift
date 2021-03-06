//
//  AuthService.swift
//  GalleryApp
//
//  Created by Yulia Popova on 31/3/2022.
//

import Foundation
import SwiftyVK

class AuthService {
    
    static let shared = AuthService()

    
    public func signIn(completion: @escaping (AuthResult) -> ()) {
        VK.sessions.default.logIn(
            onSuccess: { result in
                print(result)
                print(type(of: result))
                completion(AuthResult.success)
            },
            onError: {error in
                if case VKError.sessionAlreadyAuthorized = error {
                    completion(AuthResult.success)
                }
                completion(AuthResult.failure)
            }
        )
    }
    
    public func signOut() {
        VK.sessions.default.logOut()
    }
}
