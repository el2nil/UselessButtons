//
//  CustomButton.swift
//  UselessButtons
//
//  Created by Danil Denshin on 12.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
	
	@IBInspectable var fillAmount: CGFloat = 0.0 { didSet { setNeedsDisplay() } }
	@IBInspectable var fillColor: UIColor = UIColor.green { didSet { setNeedsDisplay() } }
	
	override func draw(_ rect: CGRect) {
		if 0...1 ~= fillAmount {
			let fillRect = CGRect(x: 0, y: 0, width: bounds.width * fillAmount, height: bounds.height)
			let path = UIBezierPath(rect: fillRect)
			fillColor.setFill()
			path.fill()
		}
	}
	
}
