//
//  AddTransactionViewController.swift
//  PROJECT_EXPENSE
//

import UIKit

class AddTransactionViewController: UIViewController {
    
    weak var delegate: AddTransactionDelegate?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Dashboard")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        title = "Add Transaction"
        setupUI()
    }

    func setupUI() {
        saveButton.layer.cornerRadius = 8
        saveButton.backgroundColor = UIColor.systemBlue
        saveButton.setTitleColor(.white, for: .normal)

        titleTextField.placeholder = "Enter Title"
        amountTextField.placeholder = "Enter Amount"
        amountTextField.keyboardType = .numberPad
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
//
        guard let expenseTitle = titleTextField.text, !expenseTitle.isEmpty,
                  let expenseText = amountTextField.text, let expenseAmount = Int(expenseText)
            else {
                // Optional: show an alert if input is invalid
                return
            }
        let newTransaction = Transaction(description: expenseTitle, amount: expenseAmount)
        UserData.shared.addTransaction(description: expenseTitle, amount: expenseAmount)

            if let dashboardVC = presentingViewController as? ViewController {
                if dashboardVC.transactions.isEmpty || dashboardVC.transactions.first?.description == "Your Expenses will be displayed here" {
                    dashboardVC.transactions.removeAll()
                }

                dashboardVC.transactions.append(newTransaction)
                dashboardVC.totalExpenses += expenseAmount
                dashboardVC.updateBalance()
                dashboardVC.tableView.reloadData()
                dashboardVC.updateTableViewHeight()
            }

            // Dismiss the modal
            dismiss(animated: true)
    }
}
