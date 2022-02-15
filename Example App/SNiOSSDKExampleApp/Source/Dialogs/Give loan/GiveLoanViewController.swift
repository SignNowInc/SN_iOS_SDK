//
//  GiveLoanViewController.swift
//  SNSDKDemoApp
//
//  Created by Mykola on 01.09.2021.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

struct LoanDTO {
    
    let client: Client
    let amount: Int
}

extension GiveLoanViewController {
    
    class func createInstance() -> GiveLoanViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "GiveLoan") as? GiveLoanViewController {
            
            return viewController
        }
        
        fatalError()
    }
}

class GiveLoanViewController: UIViewController {
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var button: UIButton!
    
    @IBOutlet private weak var textInput: UILabel!
    
    @IBOutlet private weak var emptyClientView: UIView!
    @IBOutlet private weak var clientView: UIView!
    
    @IBOutlet private weak var clientImageView: UIImageView!
    @IBOutlet private weak var clientNameLabel: UILabel!
    
    @IBOutlet private var shadowedViews: [UIView]!
    
    @IBOutlet private weak var buttonBottomConstraint: NSLayoutConstraint!
    
    private let viewModel = GiveLoadViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subsribeToViewModel()
        observeKeyboard()
        setupUI()
        
        textField.becomeFirstResponder()
    }
}

fileprivate extension GiveLoanViewController {
    
    func subsribeToViewModel() {
            
        textField.rx.text.bind(to: viewModel.inputText).disposed(by: disposeBag)
        
        viewModel.amount.bind { [weak self] amount in
            self?.textInput.text = "\(amount)"
        }
        .disposed(by: disposeBag)
        
        viewModel.continueButtonEnabled.bind { [weak self] isEnabled in
            
            self?.button.isEnabled = isEnabled
            self?.button.alpha = isEnabled ? 1.0 : 0.5
        }
        .disposed(by: disposeBag)
        
        viewModel.client.bind { [weak self] client in
            
            self?.emptyClientView.isHidden = client != nil
            self?.clientView.isHidden = client == nil
            
            self?.clientNameLabel.text = client?.username
            self?.clientImageView.image = client?.userpic
        }
        .disposed(by: disposeBag)
        
        viewModel.isLoading.bind { isLoading in
            
            if isLoading {
                Progress.show()
            } else {
                Progress.dismiss()
            }
        }
        .disposed(by: disposeBag)
    }
    
    func setupUI() {
        
        shadowedViews.forEach { view in
            view.layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
            view.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
            view.layer.shadowRadius = 4.0
            view.layer.shadowOpacity = 0.5
            view.layer.masksToBounds = false
        }
    }
    
    func presentClientPicker() {
        
        let viewController = ClientListViewController.createInstance(readonlyMode: true, output: self)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func observeKeyboard() {
        
        NotificationCenter.default.rx.notification(UIApplication.keyboardWillShowNotification).bind { [weak self] notification in
            
            if let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                
                let height = value.cgRectValue.height
                
                self?.buttonBottomConstraint.constant = height + 20.0
                self?.view.layoutIfNeeded()
            }
        }
        .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIApplication.keyboardWillHideNotification).bind { [weak self] _ in
            
            self?.buttonBottomConstraint.constant = 40.0
            self?.view.layoutIfNeeded()
            
        }
        .disposed(by: disposeBag)
    }
}

extension GiveLoanViewController: ClientListViewControllerOutput {
    
    func clientListDidSelect(client: Client) {
        viewModel.client.accept(client)
    }
}

fileprivate extension GiveLoanViewController {
    
    @IBAction func onClientViewTap(_ sender: UITapGestureRecognizer) {
        presentClientPicker()
    }
    
    @IBAction func onContinueButtonTap(_ sender: UIButton) {
        
        viewModel.handleContinueTap(viewContext: self)
    }
    
    @IBAction private func onBackTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
