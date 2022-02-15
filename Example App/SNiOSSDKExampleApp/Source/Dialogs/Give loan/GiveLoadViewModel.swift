//
//  GiveLoadViewModel.swift
//  SNSDKDemoApp
//
//  Created by Mykola on 01.09.2021.
//

import Foundation
import RxSwift
import RxRelay


class GiveLoadViewModel {
    
    var continueButtonEnabled: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var inputText: BehaviorRelay<String?> = BehaviorRelay(value: "")
    var client: BehaviorRelay<Client?> = BehaviorRelay(value: nil)
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var amount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    private let disposeBag = DisposeBag()
    
    init() {
        
        inputText.bind { [weak self] text in
            
            let amount = (text as NSString?)?.integerValue ?? 0
            self?.amount.accept(amount)
        }
        .disposed(by: disposeBag)
        
        amount.bind { [weak self] amount in
            
            guard let self = self else { return }
            self.continueButtonEnabled.accept(amount > 0 && self.client.value != nil)
        }
        .disposed(by: disposeBag)
    }
    
    func handleContinueTap(viewContext: UIViewController) {
        
        isLoading.accept(true)
        
        guard let client = client.value,
              amount.value > 0 else { return }
        
        let dto = LoanDTO(client: client, amount: amount.value)
        
        ContractProvider.shared.openLoanContract(viewContext: viewContext,
                                                 loanDTO: dto) { [weak self] in
            
            self?.isLoading.accept(false)
            
        } completion: { result in
            
            switch result {
            case .success(_):
                
                print("Document opened")
                
            case .failure(let error):
                
                print("Create document failed with error: \(error.localizedDescription)")
            }
        }
    }
}
