//
//  PopupPresentationController.swift
//  SNSDKDemoApp
//
//  Created by Mykola on 05.10.2021.
//

import Foundation
import UIKit

class PopupPresentationController: UIPresentationController {
    
    private let shadowViewTag = 1101
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        return getPresentationContainerFrame()
    }
    
    override func presentationTransitionWillBegin() {
        
        guard let containerView = containerView else { return }
        
        presentingViewController.view.layer.cornerRadius = 8.0
        presentingViewController.view.clipsToBounds = true
        
        containerView.autoresizingMask = []
        
        let shadowView = UIView(frame: containerView.bounds)
        shadowView.isUserInteractionEnabled = true
        shadowView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        shadowView.alpha = 0.0
        shadowView.tag = shadowViewTag
        containerView.insertSubview(shadowView, at: 0)
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            shadowView.alpha = 1.0
        }, completion: nil)
        
    }
    
    override func dismissalTransitionWillBegin() {
                
        guard let shadowView = containerView?.subviews.filter({$0.tag == shadowViewTag}).first else {
            return
        }
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            shadowView.alpha = 0.0
        }, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            
            self.containerView?.subviews.filter({ $0.tag == self.shadowViewTag}).first?.frame = UIScreen.main.bounds
            self.presentedViewController.view.frame = self.getPresentationContainerFrame()

        }) { _ in }
    }
    
    fileprivate func getPresentationContainerFrame() -> CGRect {

        let screenBounds = UIScreen.main.bounds
        
        let size = CGSize(width: screenBounds.width - 40.0, height: 250.0)
        let screenCenterPoint = CGPoint(x: screenBounds.midX, y: screenBounds.midY)
        
        let origin = CGPoint(x: screenCenterPoint.x - size.width/2,
                             y: screenCenterPoint.y - size.height/2)
        
        return CGRect(origin: origin, size: size)
    }
}
