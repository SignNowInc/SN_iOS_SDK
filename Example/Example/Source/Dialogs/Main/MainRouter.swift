//
//  MainRouter.swift
//  SNSDKDemoApp
//
//  Created by Mykola on 27.08.2021.
//

import Foundation
import UIKit


extension MainViewController {
    
    class Router {
        
        private unowned let context: UIViewController!
        
        init(context: UIViewController) {
            
            self.context = context
        }
        
        func routeToCreateDeposit() {
            
            let viewController = CreateDepositViewController.createInstance()
            
            context.navigationController?.pushViewController(viewController, animated: true)
        }
        
        func routeToClients() {
            
            let viewController = ClientListViewController.createInstance(readonlyMode: false,
                                                                         output: nil)
            
            context.navigationController?.pushViewController(viewController, animated: true)
        }
        
        func routeToLoan() {
            
            let viewController = GiveLoanViewController.createInstance()
            
            context.navigationController?.pushViewController(viewController, animated: true)
        }
        
        func routeToContracts() {
            
            let viewController = ContractsViewController.createInstance()
            
            context.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
