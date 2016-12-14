//
//  DetailViewController.swift
//  UselessButtons
//
//  Created by Danil Denshin on 12.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	
	var fillAmount: CGFloat? { didSet { updateUI() } }
	var labelText: String? { didSet { updateUI() } }
	
	@IBOutlet private weak var button: CustomButton!
	@IBOutlet private weak var label: UILabel!
	
	private func updateUI() {
		button?.fillAmount = fillAmount ?? 0
		label?.text = labelText ?? ""
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		updateUI()
	}
	
}
