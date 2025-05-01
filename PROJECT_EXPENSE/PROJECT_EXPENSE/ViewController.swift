//
//  ViewController.swift
//  PROJECT_EXPENSE
//

import UIKit

// Moved protocol declaration outside
protocol AddTransactionDelegate: AnyObject {
    func didAddExpense(_ expense: Double)
}

class ViewController: UIViewController, UITableViewDataSource, AddTransactionDelegate {
    
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTransactionButton: UIButton!
    
    @IBOutlet weak var incomeSlider: UISlider!
    
    var userName: String?
    var userPass: String?
        var totalExpenses: Int = 0
    
    var incomeAmount: Int = 0
    
    var transactions: [Transaction] = []
    
    var tableViewHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Dashboard")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        
        addTransactionButton.layer.cornerRadius = 8
        addTransactionButton.backgroundColor = UIColor.systemGreen
        addTransactionButton.setTitleColor(.white, for: .normal)


        title = "Expense Tracker"
        setupLabels()
        setupTableView()
        updateBalance()
    }
    
    @IBAction func unwindToDashboardWithSegue(segue: UIStoryboardSegue) {
            // Code to refresh data if needed
            // This will be called when the unwind segue is triggered
            updateBalance()
        }

    func goToProfile() {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
        UserData.shared.shouldResetData = true

           if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
               // Pass data to ProfileViewController
               profileVC.userName = userName
               profileVC.userPass = userPass
               profileVC.modalPresentationStyle = .fullScreen
               self.present(profileVC, animated: true, completion: nil)
           }
       }
    
    func setupLabels() {
        updateBalance()
        
        [incomeLabel, expenseLabel, balanceLabel].forEach { label in
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.textColor = .darkGray
            label.textAlignment = .center
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            transactions = UserData.shared.transactions
            totalExpenses = transactions.reduce(0) { $0 + $1.amount }  // <-- Correctly sum expenses
            incomeAmount = UserData.shared.income
            updateBalance()
            tableView.reloadData()
            updateTableViewHeight()
    }
    
    func updateBalance() {
        incomeLabel.text = "Income: ₹\(Int(incomeAmount))"
        expenseLabel.text = "Expenses: ₹\(Int(totalExpenses))"
        let income = UserData.shared.income
        balanceLabel.text = "Balance: ₹\(Int(income - totalExpenses))"
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.rowHeight = 50

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: CGFloat(transactions.count) * tableView.rowHeight)
        tableViewHeightConstraint?.isActive = true
    }

    // MARK: - AddTransactionDelegate
    func didAddExpense(_ expense: Double) {
        totalExpenses += Int(expense)
        let newTransaction = Transaction(description: "New Expense", amount: Int(expense))
        transactions.append(newTransaction)
        updateBalance()
        tableView.reloadData()
        updateTableViewHeight()
    }

    func updateTableViewHeight() {
        let height = CGFloat(transactions.count) * tableView.rowHeight
        tableViewHeightConstraint?.constant = height
    }

    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.isEmpty ? 1 : transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if transactions.isEmpty {
            cell.textLabel?.text = "Your Expenses will be displayed here"
            cell.textLabel?.textColor = .lightGray
            cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 16)
        } else {
            let transaction = transactions[indexPath.row]
                        cell.textLabel?.text = "\(transaction.description) - ₹\(transaction.amount)"
            cell.textLabel?.textColor = .black
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        }
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = .clear
        return cell
    }
    
    @IBAction func incomeSliderChanged(_ sender: UISlider) {
        handleSliderSelection(Int(sender.value.rounded()))
    }
    
    func handleSliderSelection(_ selectedIndex: Int) {
        let predefinedIncomes = [0, 1000, 2000, 3000, 4000]

        if selectedIndex < predefinedIncomes.count {
            incomeAmount = predefinedIncomes[selectedIndex]
            UserData.shared.income = incomeAmount
            updateBalance()
        } else {
            // Show alert for custom income
            let alert = UIAlertController(title: "Custom Income", message: "Enter your income amount", preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "Income in ₹"
                textField.keyboardType = .numberPad
            }

            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                if let text = alert.textFields?.first?.text, let income = Double(text) {
                    self.incomeAmount = Int(income)
                    UserData.shared.income = self.incomeAmount
                    self.updateBalance()
                }
            }

            alert.addAction(saveAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        }
    }

    @IBAction func goToProfileTapped(_ sender: UIButton) {
        goToProfile()
    }
    

    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toAddTransaction",
//           let navVC = segue.destination as? UINavigationController,
//           let destinationVC = navVC.topViewController as? AddTransactionViewController {
//            destinationVC.delegate = self
//        }
//    }
}
