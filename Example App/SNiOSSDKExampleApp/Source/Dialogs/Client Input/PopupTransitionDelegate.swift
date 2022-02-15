//
//  PopupTransitionDelegate.swift
//  SNSDKDemoApp
//
//  Created by Mykola on 05.10.2021.
//

import Foundation
import UIKit


class PopupTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PopupPresentationController(presentedViewController: presented,
                                           presenting: presenting)
    }
}
