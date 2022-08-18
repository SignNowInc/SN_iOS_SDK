//
//  AuthHelper.swift
//  Example
//
//  Created by Mykola on 18.08.2022.
//

import Foundation
import UIKit
import SNiOSDocumentsSDK

class AuthenticationHelper {
    
    func startSession(viewContext: UIViewController, completion: @escaping ()->()) {
        
        authorize(viewContext: viewContext) { result in
            
            switch result {
                
            case .success(let authResult):
                
                SNUserSession.current.start(authorizationResult: authResult) { sessionResult in
                    
                    switch sessionResult {
                     
                    case .success(_):
                        completion()
                        
                    case .failure(let error):
                        
                        fatalError()
                    }
                }
            case .failure(let error):
                
                fatalError()
            }
        }
    }
    
    private func authorize(viewContext: UIViewController, completion: @escaping (Swift.Result<SNAuthorization.Result, Error>)->()) {
        
        SNWebAuthorization.authorize(configuration: .defaultAppConfig,
                                     viewContext: viewContext) { webAuthResult in
            
            switch webAuthResult {
            case .success(let code):
                
                SNAuthorization.authorize(configuration: .defaultAppConfig, code: code) { authResult in
                    
                    switch authResult {
                        
                    case .success(let result):
                        completion(.success(result))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                
                completion(.failure(error))
            }
        }
    }
    
}
