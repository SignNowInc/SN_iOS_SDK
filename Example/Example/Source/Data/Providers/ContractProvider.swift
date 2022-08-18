//
//  ContractProvider.swift
//  Example
//
//  Created by Mykola on 01.09.2021.
//

import Foundation
import UIKit
import SNiOSDocumentsSDK

extension ContractProvider {
    
    struct ContractData {
        let document: SNDocument
        let client: Client
        var thumbnail: UIImage?
    }
    
    enum ContractError: Error {
        case documentNotFound
    }
}


class ContractProvider {
    
    static let shared = ContractProvider()
    
    private var contracts: [ContractData] = []
    
    private let documentProvider = SNDocumentProvider()
    private let folderProvider = SNFolderProvider()
    
    private var sessionBegan = false
    
    func openDepositContract(viewContext: UIViewController,
                             depositDTO: DepositDTO,
                             onPresent: @escaping () -> (),
                             completion: @escaping ((Swift.Result<Void, Error>)->())) {
        
        let group = DispatchGroup()
        
        group.enter()
        
        if sessionBegan {
            group.leave()
            return
        }
        
        startSession(viewContext: viewContext) { [weak self] in
            
            self?.sessionBegan = true
            
            group.leave()
        }

        
        group.notify(queue: .main) { [weak self] in
            
            self?.getDepositDocument { result in
                
                switch result {
                case .success(let document):
                    
                    let prefillData: [String: String] = [
                        "first_name": depositDTO.client.username.components(separatedBy: " ").first!,
                        "second_name": depositDTO.client.username.components(separatedBy: " ").last!,
                        "email": depositDTO.client.email,
                        "amount": "\(depositDTO.amount)"
                    ]
                    
                    let signers = [SNEditor.SignerDTO(roleName: "Signer 1", email: depositDTO.client.email),
                                   SNEditor.SignerDTO(roleName: "Signer 2", email: "avilov.mykola@pdffiller.team")]
                    
                    SNEditor.openEditor(document: document,
                                        prefillData: prefillData,
                                        signers: signers,
                                        presentationContext: viewContext,
                                        onPresent: onPresent) { result in
                        
                        
                        switch result {
                            
                        case .success(_):
                            
                            self?.saveContract(documentId: document.metaData.id,
                                               client: depositDTO.client)
                            
                            viewContext.navigationController?.popToRootViewController(animated: true)
                            completion(.success(()))
                            
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
    
    func openLoanContract(viewContext: UIViewController,
                          loanDTO: LoanDTO,
                          onPresent: @escaping () ->(),
                          completion: @escaping ((Swift.Result<Void, Error>)->()))  {
        
        startSession(viewContext: viewContext) { [weak self] in
            
            self?.getLoanDocument { result in
                
                switch result {
                case .success(let document):
                    
                    let prefillData: [String: String] = [
                        "first_name": loanDTO.client.username.components(separatedBy: " ").first!,
                        "second_name": loanDTO.client.username.components(separatedBy: " ").last!,
                        "loan_size": "\(loanDTO.amount)",
                        "loan_size_2": "\(loanDTO.amount)",
                    ]
                    
                    let signers = [SNEditor.SignerDTO(roleName: "Signer 1", email: loanDTO.client.email),
                                   SNEditor.SignerDTO(roleName: "Signer 2", email: "roman.pavliuk@pdffiller.team"),
                                   SNEditor.SignerDTO(roleName: "Signer 3", email: "directed.explosion@gmail.com")]
                    
                    SNEditor.openEditor(document: document,
                                        prefillData: prefillData,
                                        signers: signers,
                                        presentationContext: viewContext,
                                        onPresent: onPresent) { result in
                        
                        
                        switch result {
                        case .success(_):
                            
                            self?.saveContract(documentId: document.metaData.id,
                                              client: loanDTO.client)
                            
                            viewContext.navigationController?.popToRootViewController(animated: true)
                            
                            completion(.success(()))
                            
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
    
    func getContracts() -> [ContractProvider.ContractData] {
        return contracts
    }
}

//MARK: - Private
fileprivate extension ContractProvider {
    
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
    
    func authorize(viewContext: UIViewController, completion: @escaping (Swift.Result<SNAuthorization.Result, Error>)->()) {
        
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
    
    func saveContract(documentId: String, client: Client) {
        
        documentProvider.getDocument(byId: documentId) { result in
            
            switch result {
            case .success(let document):
                
                let contractData = ContractData(document: document, client: client, thumbnail: nil)
                
                self.contracts.append(contractData)
                self.loadThumbnail(for: document)
                
            case .failure(let error):
                
                print("get document failed with error: \(error.localizedDescription)")
                
                fatalError()
            }
        }
    }
    
    func loadThumbnail(for document: SNDocument) {
        
        
//        let thumbnailUrl = URL(string: document.thumbnailsURLs.small)!
//        
//        DispatchQueue.global().async {
//            
//            if let data = try? Data(contentsOf: thumbnailUrl),
//               let image = UIImage(data: data) {
//                
//                if let index = self.contracts.firstIndex(where: {$0.document.metaData.id == document.metaData.id}) {
//                    
//                    self.contracts[index].thumbnail = image
//                }
//            }
//        }
    }
}
//MARK: - Deposit
fileprivate extension ContractProvider {
    
    func getDepositDocument(completion: @escaping (Swift.Result<SNDocument, Error>) -> ()) {
        
        let documentId = "c88948a7e5294674a1f30b72b0609b1baf96ffd9"
        documentProvider.getDocument(byId: documentId, completion: completion)
    }
}

//MARK: - Loan
fileprivate extension ContractProvider {
    
    func getLoanDocument(completion: @escaping (Swift.Result<SNDocument, Error>)->()) {
        
        let documentId = "8a900a73e8d242c2a8c316fe1b61325d40005046"
        documentProvider.getDocument(byId: documentId, completion: completion)
    }
}
