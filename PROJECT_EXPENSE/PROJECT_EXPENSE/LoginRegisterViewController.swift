//
//  LoginRegisterViewController.swift
//  PROJECT_EXPENSE
//
//  Created by ARUN KUMAR YADAV on 26/04/25.
//

import UIKit

class LoginRegisterViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var loginView: UIView!
    
    
    
    @IBOutlet weak var loginEmailField: UITextField!
    
    @IBOutlet weak var loginPasswordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var registerEmailField: UITextField!
    @IBOutlet weak var registerPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginError: UILabel!
    @IBOutlet weak var registerError: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Dashboard")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        loginView.backgroundColor = .clear
        registerView.backgroundColor = .clear
        loginError.textColor = .red
        registerError.textColor = .red
        loginError.text = "Proceed with Login"
        registerError.text = "Proceed with Registration"
        loginError.textAlignment = .center
        registerError.textAlignment = .center
        registerPasswordField.textContentType = .oneTimeCode
        confirmPasswordField.textContentType = .oneTimeCode
        switchView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switchView()
    }
    
    func switchView() {
            let isLogin = segmentedControl.selectedSegmentIndex == 0
            loginView.isHidden = !isLogin
            registerView.isHidden = isLogin
        }
    func navigateToDashboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let dashboardVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            // Pass the data to ViewController's properties
            dashboardVC.userName = UserData.shared.userName
            dashboardVC.userPass = UserData.shared.userPass
            dashboardVC.modalPresentationStyle = .fullScreen
            self.present(dashboardVC, animated: true, completion: nil)
        }
    }

    
    @IBAction func loginTapped(_ sender: UIButton) {
        let email = loginEmailField.text ?? ""
            let password = loginPasswordField.text ?? ""

            if email.isEmpty || password.isEmpty {
                loginError.text = "Please fill all login fields"
            } else {
                loginError.textColor = .green
                loginError.text = "Logging in with email: \(email)"

                // Assuming username is derived from email before @
                UserData.shared.userName = email
                UserData.shared.userPass = password

                // Pass the data to ViewController
                navigateToDashboard()
            }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        let email = registerEmailField.text ?? ""
                    let password = registerPasswordField.text ?? ""
                    let confirmPassword = confirmPasswordField.text ?? ""

                    // Example registration logic
                    if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                        registerError.text = "Please fill all registration fields"
                    } else if password != confirmPassword {
                        registerError.text = "Passwords do not match"
                    } else {
                        registerError.textColor = .green
                        registerError.text = "Registering with email: \(email)"

                        // Assuming username is derived from email before @
                        UserData.shared.userName = email
                        UserData.shared.userPass = password

                        // Pass the data to ViewController
                        navigateToDashboard()
                    }
            }
    
}
