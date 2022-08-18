//
//  ClientListViewController.swift
//  SNSDKDemoApp
//
//  Created by Mykola on 30.08.2021.
//

import Foundation
import UIKit

protocol ClientListViewControllerOutput: AnyObject {
    
    func clientListDidSelect(client: Client)
}

extension ClientListViewController {
    
    class func createInstance(readonlyMode: Bool,
                              output: ClientListViewControllerOutput?) -> ClientListViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ClientList") as? ClientListViewController {
            
            viewController.readonlyMode = readonlyMode
            viewController.output = output
            
            return viewController
        }
        
        fatalError()
    }
}

class ClientListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var bottomContainerHeight: NSLayoutConstraint!
    @IBOutlet private weak var topContainerHeight: NSLayoutConstraint!
    
    fileprivate var readonlyMode: Bool = false
    fileprivate var output: ClientListViewControllerOutput?
    
    private var clients: [Client] {
        return ClientProvider.shared.getCleints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        
        tableView.allowsSelection = output != nil
        tableView.rowHeight = UITableView.automaticDimension
        
        if readonlyMode {
            bottomContainerHeight.constant = 0.0
        }
        
        if let _ = navigationController {
            topContainerHeight.constant = 0.0
        } else {
            view.layer.cornerRadius = 8.0
            view.clipsToBounds = true
        }
    }
    
    @IBAction private func onAddButtonTap(_ sender: AnyObject) {
        presentAddClientDialog()
    }
    
    @IBAction private func onBackButtonTap(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    private func presentAddClientDialog() {
        
        let addViewController = AddClientViewController.createInstance()
        
        addViewController.onDismiss = { [weak self] dto in
            
            if let dto = dto {
                self?.handleAddClient(clientDTO: dto)
            }            
        }

        present(addViewController, animated: true, completion: nil)
    }
    
    private func handleAddClient(clientDTO: AddClientDTO) {
        
        let client = Client(username: clientDTO.name, email: clientDTO.email, rating: 0)
        
        ClientProvider.shared.addClient(client)
        
        tableView.reloadData()
    }
}

extension ClientListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return clients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell") as? ClientListTableViewCell {
            
            let client = clients[indexPath.row]
            cell.client = client
            
            return cell
        }
        
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let client = clients[indexPath.row]
        
        if let output = output {
            
            output.clientListDidSelect(client: client)
            dismiss()
        }
    }
    
    private func dismiss() {
        
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
