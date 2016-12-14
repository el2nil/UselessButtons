//
//  ButtonListTableViewTableViewController.swift
//  UselessButtons
//
//  Created by Danil Denshin on 12.12.16.
//  Copyright © 2016 el2Nil. All rights reserved.
//

import UIKit

struct CellData {
	var index: Int
	var fillAmount: CGFloat
}

class ButtonListTableViewTableViewController: UITableViewController {
	
	var delegate: ButtonListTableViewTableViewController?
	
	var buttonFills: [CellData] = {
		var newArray = Array<CellData>()
		for i in 0...99 {
			newArray.append(CellData(index: i, fillAmount: 0.0))
		}
		return newArray
	}()
	{
		didSet {
			tableView.reloadData()
		}
	}
	
	var changeHistory: [CellData] = []
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttonFills.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ButtonCell, for: indexPath)
		
		if let buttonCell = cell as? ButtonTableViewCell {
			buttonCell.label?.text = String(buttonFills[indexPath.row].index)
			buttonCell.button?.fillAmount = buttonFills[indexPath.row].fillAmount
			
			if isSettingsVC(controller: self as UITableViewController) {
				buttonCell.accessoryType = .none
			}
		}

        return cell
    }
	
	private func isSettingsVC(controller: UITableViewController?) -> Bool {
		return controller?.tableView.tableHeaderView != nil
	}
	
	func changeButtonFill(inRow row: Int, withAmount amount: CGFloat) {
		buttonFills[row].fillAmount = amount
		changeHistory.append(CellData(index: row, fillAmount: amount))
	}
	
	@IBAction func setupRow(_ sender: UIButton) {
		if let settingsCell = tableView.tableHeaderView?.subviews.first as? SettingsTableViewCell {
			settingsCell.endEditing(true)
			if let row = Int(settingsCell.rowTextField?.text ?? ""), 0...99 ~= row,
				let fillAmount = Double(settingsCell.fillAmountTextField.text ?? ""), 0...1 ~= fillAmount {
				
				delegate?.changeButtonFill(inRow: row, withAmount: CGFloat(fillAmount))
				buttonFills += [CellData(index: row, fillAmount: CGFloat(fillAmount))]
				
			} else {
				let alert = UIAlertController(title: nil, message: "Row must be in 0..99 and fill amount in 0..1", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
				present(alert, animated: true, completion: nil)
			}
		}
	}
	
	@IBAction func settings(sender: UIButton) {
		if let buttonListTVC = storyboard?.instantiateViewController(withIdentifier: "ButtonsTableViewController") as? ButtonListTableViewTableViewController {
			buttonListTVC.buttonFills = []
			if let headerView = tableView.dequeueReusableCell(withIdentifier: Constants.SettingsCell) as? SettingsTableViewCell {
				headerView.okButton.addTarget(buttonListTVC, action: #selector(setupRow(_:)), for: .touchUpInside)
				
				// баг Xcode - без враппера headerView исчезнет
				let wrapperView = UIView(frame: headerView.frame)
				wrapperView.addSubview(headerView)
				buttonListTVC.tableView.tableHeaderView = wrapperView
				
				buttonListTVC.buttonFills = changeHistory
				buttonListTVC.navigationItem.titleView = nil
				buttonListTVC.delegate = self
				navigationController?.pushViewController(buttonListTVC, animated: true)
			}
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if !isSettingsVC(controller: self) {
			performSegue(withIdentifier: Constants.DetailSegue, sender: tableView.cellForRow(at: indexPath))
		}
	}
	
	override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		return !isSettingsVC(controller: self)
	}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let identifier = segue.identifier, identifier == Constants.DetailSegue {
			if let cell = sender as? ButtonTableViewCell,
				let indexPath = tableView.indexPath(for: cell),
				let detailVC = segue.destination as? DetailViewController {
				
					detailVC.labelText = String(buttonFills[indexPath.row].index)
					detailVC.fillAmount = buttonFills[indexPath.row].fillAmount
				
			}
		}
    }
	
	private struct Constants {
		static let ButtonCell = "Button Cell"
		static let DetailSegue = "Detail Segue"
		static let SettingsCell = "Settings Cell"
	}

}
