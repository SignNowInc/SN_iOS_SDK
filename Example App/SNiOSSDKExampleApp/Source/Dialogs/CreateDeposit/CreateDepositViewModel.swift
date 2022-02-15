//
//  CreateDepositViewModel.swift
//  SNSDKDemoApp
//
//  Created by Mykola on 27.08.2021.
//

import Foundation
import RxSwift
import RxRelay

class CreateDepositViewModel {
    
    var client: BehaviorRelay<Client?> = BehaviorRelay(value: nil)
    
    var percentValue: BehaviorRelay<Int>
    var monthValue: BehaviorRelay<Int>
    
    var plusButtonEnabled: BehaviorRelay<Bool>
    var minusButtonEnabled: BehaviorRelay<Bool>
    
    var continueButtonEnabled: BehaviorRelay<Bool>
    
    private let maxMonthCount: Int = 12
    private let minMonthCount: Int = 7
    
    private let disposeBag = DisposeBag()
    
    init() {
        
        monthValue = BehaviorRelay(value: maxMonthCount)
        percentValue = BehaviorRelay(value: 1)
        
        plusButtonEnabled = BehaviorRelay(value: true)
        minusButtonEnabled = BehaviorRelay(value: true)
        continueButtonEnabled = BehaviorRelay(value: false)
        
        monthValue.subscribe { [weak self] value in
            
            self?.recalculate()
        }
        .disposed(by: disposeBag)
        
        client.bind { [weak self] client in
            
            self?.continueButtonEnabled.accept(client != nil)
        }
        .disposed(by: disposeBag)
    }
    
    func handlePlusTapped() {
        
        let newValue = monthValue.value + 1
        monthValue.accept(newValue)
    }
    
    func handleMinusTapped() {
        
        let newValue = monthValue.value - 1
        monthValue.accept(newValue)
    }
    
    func getResultDTO() -> DepositDTO {
        
        guard let client = client.value else { fatalError() }
        
        return DepositDTO(client: client, months: monthValue.value)
    }
        
    private func recalculate() {
        
        let month = monthValue.value
        let rate = month - 6

        percentValue.accept(rate)
        
        plusButtonEnabled.accept(month < maxMonthCount)
        minusButtonEnabled.accept(month > minMonthCount)
    }
}
