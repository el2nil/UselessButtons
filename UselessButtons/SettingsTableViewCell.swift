//
//  SettingsTableViewCell.swift
//  UselessButtons
//
//  Created by Danil Denshin on 12.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell, UITextFieldDelegate {

	@IBOutlet weak var rowTextField: UITextField! { didSet { rowTextField.delegate = self } }
	@IBOutlet weak var fillAmountTextField: UITextField! { didSet { fillAmountTextField.delegate = self } }
	@IBOutlet weak var okButton: UIButton!
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}

}
