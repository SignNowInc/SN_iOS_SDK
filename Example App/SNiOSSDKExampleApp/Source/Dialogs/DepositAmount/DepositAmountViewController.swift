//
//  DepositAmountViewController.swift
//  SNSDKDemoApp
//
//  Created by Mykola on 30.08.2021.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift


struct DepositDTO {
    var client: Client
    var months: Int
    var amount: Int = 0
    
    mutating func setAmount(_ amount: Int) {
        self.amount = amount
    }
}

extension DepositAmountViewController {
    
    class func createInstance(depositDTO: DepositDTO) -> DepositAmountViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "DepositAmount") as? DepositAmountViewController {
            
            let viewModel = DepositAmountViewModel(depositDTO: depositDTO)
            viewController.viewModel = viewModel
            
            return viewController
        }
        
        fatalError()
    }
}

class DepositAmountViewController: UIViewController {
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var inputLabel: UILabel!
    
    @IBOutlet private weak var buttonBottomConstraint: NSLayoutConstraint!
    
    private var viewModel: DepositAmountViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeKeyboard()
        
        textField.becomeFirstResponder()
        subsribeToViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    private func subsribeToViewModel() {

        viewModel.continueButtonEnabled.bind { [weak self] isEnabled in
            
            self?.continueButton.isEnabled = isEnabled
            self?.continueButton.alpha = isEnabled ? 1.0 : 0.5
        }
        .disposed(by: disposeBag)
        
        textField.rx.text.map({ ($0 as NSString?)?.integerValue ?? 0 }).bind(to: viewModel.amount).disposed(by: disposeBag)
        
        viewModel.amount.bind(onNext: { [weak self] amount in
            self?.inputLabel.text = "\(amount)"
        })
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
    
    @IBAction func onContinueButtonTap(_ sender: UIButton) {
        
        viewModel.handleContinueTap(context: self)
    }
    
    @IBAction func onBackTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
