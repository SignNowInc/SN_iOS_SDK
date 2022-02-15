//
//  CreateDepositViewController.swift
//  SNSDKDemoApp
//
//  Created by Mykola on 27.08.2021.
//

import Foundation
import UIKit
import RxSwift


extension CreateDepositViewController {
    
    class func createInstance() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "CreateDepositViewController") as? CreateDepositViewController {
            
            return viewController
        }
        
        fatalError()
    }
}

class CreateDepositViewController: UIViewController {
    
    private let viewModel = CreateDepositViewModel()
    
    @IBOutlet private weak var percentLabel: UILabel!
    @IBOutlet private weak var interestLabel: UILabel!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var minusButton: UIButton!
    
    @IBOutlet private weak var monthLabel: UILabel!
    
    @IBOutlet private weak var emptyClientView: UIView!
    @IBOutlet private weak var clientView: UIView!
    
    @IBOutlet private weak var createDepositButton: UIButton!
    
    @IBOutlet private weak var clientImageView: UIImageView!
    @IBOutlet private weak var clientNameLabel: UILabel!
    
    @IBOutlet private weak var borderedView: UIView!
    @IBOutlet private var shadowedViews: [UIView]!
    
    @IBOutlet private weak var continueButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToViewModel()
        setupUI()
    }
    
    func subscribeToViewModel() {
        
        viewModel.monthValue.subscribe { [weak self] value in
            
            self?.monthLabel.text = "\(value.element!) months"
        }
        .disposed(by: disposeBag)
        
        viewModel.percentValue.bind { [weak self] rate in
            self?.percentLabel.text = "\(rate)"
            self?.interestLabel.text = "Invest rate - \(rate)%"
        }
        .disposed(by: disposeBag)

        viewModel.plusButtonEnabled.subscribe { [weak self] isEnabled in
            
            self?.plusButton.isEnabled = isEnabled
        }
        .disposed(by: disposeBag)

        viewModel.minusButtonEnabled.subscribe { [weak self] isEnabled in
            
            self?.minusButton.isEnabled = isEnabled
        }
        .disposed(by: disposeBag)
        
        viewModel.client.bind { [weak self] client in
            
            self?.emptyClientView.isHidden = client != nil
            self?.clientView.isHidden = client == nil
            
            self?.clientNameLabel.text = client?.username
            self?.clientImageView.image = client?.userpic
            self?.setCreateDepositButton(enabled: client != nil)

        }
        .disposed(by: disposeBag)
        
        viewModel.continueButtonEnabled.bind { [weak self] isEnabled in
            
            self?.continueButton.isEnabled = isEnabled
            self?.continueButton.alpha = isEnabled ? 1.0 : 0.5
        }
        .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        
        shadowedViews.forEach { view in
            view.layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
            view.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
            view.layer.shadowRadius = 4.0
            view.layer.shadowOpacity = 0.5
            view.layer.masksToBounds = false
        }
        
        borderedView.layer.borderWidth = 1.0
        borderedView.layer.borderColor = UIColor(named:"border")?.withAlphaComponent(0.4).cgColor
        setCreateDepositButton(enabled: false)
    }
    
    private func setCreateDepositButton(enabled: Bool) {
        createDepositButton.isEnabled = enabled
        createDepositButton.alpha = enabled ? 1.0 : 0.5
    }
}

extension CreateDepositViewController: ClientListViewControllerOutput {
    
    func clientListDidSelect(client: Client) {
        
        viewModel.client.accept(client)
    }
}

extension CreateDepositViewController {
    
    @IBAction func onCreateDepositTap(_ sender: UIButton) {
        performNext()
    }
    
    @IBAction func onPlusButtonTap(_ sender: UIButton) {
        viewModel.handlePlusTapped()
    }
    
    @IBAction func onMinusButtonTap(_ sender: UIButton) {
        viewModel.handleMinusTapped()
    }
    
    @IBAction func onClientUsernameTap(_ sender: UITapGestureRecognizer) {
        presentClientPicker()
    }
    
    @IBAction func onBackTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

fileprivate extension CreateDepositViewController {
    
    func performNext() {
        
        let dto = viewModel.getResultDTO()
        
        let viewController = DepositAmountViewController.createInstance(depositDTO: dto)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentClientPicker() {
        
        let viewController = ClientListViewController.createInstance(readonlyMode: true, output: self)
        present(viewController, animated: true, completion: nil)
    }
    
}
