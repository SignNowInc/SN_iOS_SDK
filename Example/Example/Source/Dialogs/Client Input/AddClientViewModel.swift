//
//  AddClientViewModel.swift
//  SNSDKDemoApp
//
//  Created by Mykola on 05.10.2021.
//

import Foundation
import RxSwift
import RxRelay


class AddClientViewModel {
    
    var name: BehaviorRelay<String?> = BehaviorRelay(value: "")
    var email: BehaviorRelay<String?> = BehaviorRelay(value: "")
    
    var buttonEnabled: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    private let disposesBag = DisposeBag()
    
    init() {        
        
        Observable.merge(
            name.asObservable(),
            email.asObservable()
        ).bind(onNext: { [weak self] _ in
            
            guard let name = self?.name.value,
                  let email = self?.email.value else { return }
            
            self?.buttonEnabled.accept(!name.isEmpty && email.isValidEmailString())
                        
        })
        .disposed(by: disposesBag)
    }
    
    func getResult() -> AddClientDTO {
        
        return AddClientDTO(name: name.value!, email: email.value!)
    }
}

extension String {
    
    func isValidEmailString() -> Bool {
        
        guard !self.isEmpty else { return false }
        
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z0-9.-]{2,}"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return test.evaluate(with: self)
    }
}
