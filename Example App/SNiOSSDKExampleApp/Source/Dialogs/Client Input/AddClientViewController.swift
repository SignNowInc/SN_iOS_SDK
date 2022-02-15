//
//  AddClientViewController.swift
//  SNSDKDemoApp
//
//  Created by Mykola on 05.10.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


struct AddClientDTO {
    let name: String
    let email: String
}

extension AddClientViewController {
    
    class func createInstance() -> AddClientViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "AddClient") as? AddClientViewController else {
            fatalError()
        }
        
        viewController.transitioningDelegate = transition
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .custom
        
        return viewController
    }
    
}

class AddClientViewController: UIViewController {
            
    var onDismiss:((AddClientDTO?) -> ())?
    
    private static var transition = PopupTransitionDelegate()
        
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var addButton: UIButton!
    
    private let viewModel = AddClientViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToViewModel()
    }
    
    private func bindToViewModel() {
        
        nameTextField.rx.text.asObservable().bind(to: viewModel.name).disposed(by: disposeBag)
        
        emailTextField.rx.text.asObservable().bind(to: viewModel.email).disposed(by: disposeBag)
        
        viewModel.buttonEnabled.bind { [weak self] isEnabled in
            
            self?.addButton.isEnabled = isEnabled
            self?.addButton.alpha = isEnabled ? 1.0 : 0.6
        }
        .disposed(by: disposeBag)
    }
    
    @IBAction private func onCancelButtonTap(_ sender: UIButton) {
            
        dismiss(animated: true) {
            self.onDismiss?(nil)
        }
    }
    
    @IBAction private func onAddButtonTap(_ sender: UIButton) {
        
        handleAddTapped()
    }
    
    private func handleAddTapped() {
        
        let dto = viewModel.getResult()
        
        dismiss(animated: true) {
            self.onDismiss?(dto)
        }
    }
}

extension AddClientViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField === nameTextField || !textField.text!.isEmpty {
            emailTextField.becomeFirstResponder()
            return true
        }
        
        if viewModel.buttonEnabled.value { // button isEnabled when input strings are valid
            handleAddTapped()
            return true 
        }
        
        return false
    }
}
