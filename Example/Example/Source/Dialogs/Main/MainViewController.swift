//
//  MainViewController.swift
//  SNSDKDemoApp
//
//  Created by Mykola on 27.08.2021.
//

import Foundation
import UIKit


class MainViewController: UIViewController {
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var welcomeLabel: UILabel!
    
    private lazy var authHelper = AuthenticationHelper()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    private lazy var router: Router = {
        return Router(context: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        setupLabels()
        performAuth()
    }
    
    private func setupLabels() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        dateLabel.text = dateFormatter.string(from: Date())
        
        let welcomeText = NSMutableAttributedString(string: "Hello, Jennifer",
                                                    attributes: [.font: UIFont(name: "SFProText-Regular", size: 16.0) as Any,
                                                                 .foregroundColor: UIColor(named: "Trolley Gray 800") as Any])
        
        welcomeText.addAttributes([.font: UIFont(name: "SFProText-Semibold", size: 18.0) as Any],
                                  range: NSRange(location: 7, length: 8))
        welcomeLabel.attributedText = welcomeText
    }
    
    private func performAuth() {
        
        authHelper.startSession(viewContext: self) {
            print("session began")
        }
    }
}

extension MainViewController {
    
    @IBAction func onCreateDepositTap(_ sender: UIButton) {
        router.routeToCreateDeposit()
    }
    
    @IBAction func onClientsTap(_ sender: UIButton) {
        router.routeToClients()
    }
    
    @IBAction func onGiveLoanTap(_ sender: UIButton) {
        router.routeToLoan()
    }
    
    @IBAction func onContractsTap(_ sender: UIButton) {
        router.routeToContracts()
    }
}
