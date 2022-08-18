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
        
        getDepositDocument { [weak self] result in
            
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
    
    func openLoanContract(viewContext: UIViewController,
                          loanDTO: LoanDTO,
                          onPresent: @escaping () ->(),
                          completion: @escaping ((Swift.Result<Void, Error>)->()))  {
        
        getLoanDocument { [weak self] result in
            
            switch result {
            case .success(let document):
                
                let prefillData: [String: String] = [
                    "first_name": loanDTO.client.username.components(separatedBy: " ").first!,
                    "second_name": loanDTO.client.username.components(separatedBy: " ").last!,
                    "loan_size": "\(loanDTO.amount)",
                    "loan_size_2": "\(loanDTO.amount)",
                ]
                
                let signers = [SNEditor.SignerDTO(roleName: "Signer 1", email: loanDTO.client.email),
                               SNEditor.SignerDTO(roleName: "Signer 2", email: "avilov.mykola+232323@pdffiller.team"),
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
    
    func getContracts() -> [ContractProvider.ContractData] {
        return contracts
    }
}

//MARK: - Private
fileprivate extension ContractProvider {
    
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
        
        
        let thumbnailUrl = URL(string: document.thumbnailsURLs.small)!
        
        DispatchQueue.global().async {
            
            if let data = try? Data(contentsOf: thumbnailUrl),
               let image = UIImage(data: data) {
                
                if let index = self.contracts.firstIndex(where: {$0.document.metaData.id == document.metaData.id}) {
                    
                    self.contracts[index].thumbnail = image
                }
            }
        }
    }
}
//MARK: - Deposit
fileprivate extension ContractProvider {
    
    func getDepositDocument(completion: @escaping (Swift.Result<SNDocument, Error>) -> ()) {
        
        let documentId = "9ec057d14dc44ab38c1a140ac7fa0761d6a1cfb7"
        documentProvider.getDocument(byId: documentId, completion: completion)
    }
}

//MARK: - Loan
fileprivate extension ContractProvider {
    
    func getLoanDocument(completion: @escaping (Swift.Result<SNDocument, Error>)->()) {
        let documentId = "4605e15358874f21ab186caf92d5a9ca02c31a0d"
        documentProvider.getDocument(byId: documentId, completion: completion)
    }
}
