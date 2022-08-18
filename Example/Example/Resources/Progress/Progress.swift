//
//  OCProgress.swift
//  ObjectsCity
//
//
import UIKit

class Progress {
	
	class func setup() {
		
		MKProgress.config.hudType = .radial
		MKProgress.config.width = 64.0
		MKProgress.config.height = 64.0
		MKProgress.config.hudColor = UIColor(white: 1, alpha: 0.85)
		MKProgress.config.backgroundColor = UIColor(white: 0, alpha: 0.55)
		MKProgress.config.cornerRadius = 16.0
		MKProgress.config.fadeInAnimationDuration = 0.2
		MKProgress.config.fadeOutAnimationDuration = 0.25
		MKProgress.config.hudYOffset = 15

		MKProgress.config.circleRadius = 24.0
		MKProgress.config.circleBorderWidth = 2.0
		MKProgress.config.circleBorderColor = .darkGray
		MKProgress.config.circleAnimationDuration = 0.9
		MKProgress.config.circleArcPercentage = 0.85
		MKProgress.config.logoImage  = nil
		MKProgress.config.logoImageSize = CGSize(width: 40, height: 40)

		MKProgress.config.activityIndicatorStyle = .large
		MKProgress.config.activityIndicatorColor = .black
		MKProgress.config.preferredStatusBarStyle = .lightContent
		MKProgress.config.prefersStatusBarHidden = false
	}
	
	class func show() {
				
		MKProgress.show()
	}
	
	class func dismiss() {
		
		MKProgress.hide()
	}
}
