//
//  DepositAmountViewModel.swift
//  SNSDKDemoApp
//
//  Created by Mykola on 31.08.2021.
//

import Foundation
import RxRelay
import RxSwift
import SNiOSSDK

class DepositAmountViewModel {
    
    var amount: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var continueButtonEnabled: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    private var depositDTO: DepositDTO
    private let disposeBag = DisposeBag()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    init(depositDTO: DepositDTO) {
        
        self.depositDTO = depositDTO
        
        amount.bind { [weak self] amount in
            
            self?.continueButtonEnabled.accept(amount >= 1000)
        }
        .disposed(by: disposeBag)
    }
    
    func handleContinueTap(context: UIViewController) {
        
        isLoading.accept(true)
        
        depositDTO.setAmount(amount.value)
        
        ContractProvider.shared.openDepositContract(viewContext: context,
                                                    depositDTO: depositDTO) { [weak self] in
            
            self?.isLoading.accept(false)
            
        } completion: { [weak self] result in
            
            self?.isLoading.accept(false)
            
            switch result {
            case .success(()):
                
                print("Success")
                break
                
            case .failure(let error):
                
                print("Create document failed with error: \(error.localizedDescription)")
                fatalError()
            }
        }
    }
}
