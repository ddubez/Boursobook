//
//  UserAuthAPI.swift
//  Boursobook
//
//  Created by David Dubez on 06/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class UserAuthAPI {
    // Manage the acces of "user" authentication

    // MARK: Properties
    private var userRemoteAuthenticationRequest: RemoteAuthenticationRequest = FireBaseAuthenticationRequest()

    // MARK: Initialisation
    init() {}
    init(userRemoteAuthenticationRequest: RemoteAuthenticationRequest) {
        self.userRemoteAuthenticationRequest = userRemoteAuthenticationRequest
    }

    // MARK: Functions
    func signInUser(email: String, password: String, completionHandler: @escaping (Error?, User?) -> Void) {
        userRemoteAuthenticationRequest.signInUser(email: email, password: password) { (error, userLogin: User?) in
            if let error = error {
                completionHandler(error, nil)
            } else {
                guard let userLogin = userLogin else {
                    completionHandler(UAAPIError.other, nil)
                    return
                }
                completionHandler(nil, userLogin)
            }
        }
    }

    func createUser(email: String, password: String, completionHandler: @escaping (Error?, User?) -> Void) {
        userRemoteAuthenticationRequest.createUser(email: email, password: password) { (error, userLogin: User?) in
            if let error = error {
                completionHandler(error, nil)
            } else {
                guard let userLogin = userLogin else {
                    completionHandler(UAAPIError.other, nil)
                    return
                }
                completionHandler(nil, userLogin)
            }
        }
    }

    func signOut(completionHandler: @escaping (Error?) -> Void) {
        userRemoteAuthenticationRequest.signOut { (error) in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
    }
}

extension UserAuthAPI {
    /**
     'UAAPIError' is the error type returned by UserAuthAPI.
     It encompasses a few different types of errors, each with
     their own associated reasons.
     */
    enum UAAPIError: String, Error {
        case other = "Sorry, there is an error !"
    }
}
