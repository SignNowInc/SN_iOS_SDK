//
//  ContractsViewController.swift
//  SNSDKDemoApp
//
//  Created by Mykola on 29.09.2021.
//

import Foundation
import UIKit


extension ContractsViewController {
    
    class func createInstance() -> ContractsViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "Contracts") as? ContractsViewController {
            
            return viewController
        }
        
        fatalError()
    }
}

class ContractsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var contracts: [ContractProvider.ContractData] = []
    
    @IBAction private func onBackButtonTap(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }
    
    private func reloadData() {
        contracts = ContractProvider.shared.getContracts()
        tableView.reloadData()
    }
}

extension ContractsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contracts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let contractData = contracts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ContractCell") as? ContractTableViewCell {
            
            cell.contract = contractData
            
            //set status text and color
            
            return cell
        }
        
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104.0
    }
}
