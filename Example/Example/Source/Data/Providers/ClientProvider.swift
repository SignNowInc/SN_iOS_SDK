//
//  ClientProvider.swift
//  SNSDKDemoApp
//
//  Created by Mykola on 30.08.2021.
//

import Foundation

class ClientProvider {
    
    static let shared = ClientProvider()
    
    private var clients: [Client]
    
    init() {
        
        self.clients = Client.mockClients()
    }
    
    func addClient(_ client: Client) {
        
        self.clients.append(client)
    }
    
    func getCleints() -> [Client] {
        
        return self.clients
    }
}
