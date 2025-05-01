//
//  ProfileViewController.swift
//  PROJECT_EXPENSE
//
//  Created by ARUN KUMAR YADAV on 29/04/25.
//

import UIKit

class ProfileViewController: UIViewController {
        
        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var passLabel: UILabel!
        @IBOutlet weak var editButton: UIButton!
        
        var userName: String?
        var userPass: String?

        override func viewDidLoad() {
            super.viewDidLoad()
            
            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.image = UIImage(named: "Dashboard")
            backgroundImage.contentMode = .scaleAspectFill
            view.insertSubview(backgroundImage, at: 0)

            if let userName = UserData.shared.userName {
                       nameLabel.text = userName
                   } else {
                       nameLabel.text = "N/A"
                   }

                   if let userPass = UserData.shared.userPass {
                       passLabel.text = userPass
                   } else {
                       passLabel.text = "N/A"
                   }

            // Center alignment
            nameLabel.textAlignment = .center
            passLabel.textAlignment = .center

            // Style edit button
            editButton.setTitle("Edit Profile", for: .normal)
            editButton.layer.cornerRadius = 8
            editButton.backgroundColor = .systemBlue
            editButton.setTitleColor(.white, for: .normal)
        }

        @IBAction func editButtonTapped(_ sender: UIButton) {
            let alert = UIAlertController(title: "Edit Field", message: "Select field to edit", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Email", style: .default, handler: { _ in
                self.promptForUpdate(field: "Email")
            }))
            
            alert.addAction(UIAlertAction(title: "Password", style: .default, handler: { _ in
                self.promptForUpdate(field: "Password")
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(alert, animated: true)
        }
        
        func promptForUpdate(field: String) {
            let updateAlert = UIAlertController(title: "Update \(field)", message: "Enter new \(field.lowercased())", preferredStyle: .alert)
            
            updateAlert.addTextField { textField in
                textField.placeholder = "New \(field)"
            }
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                guard let newValue = updateAlert.textFields?.first?.text, !newValue.isEmpty else { return }
                
                if field == "Email" {
                    UserData.shared.userName = newValue  // Update email
                    self.nameLabel.text = newValue
                } else {
                    UserData.shared.userPass = newValue  // Update password
                    self.passLabel.text = newValue
                }
            }
            
            updateAlert.addAction(saveAction)
            updateAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(updateAlert, animated: true)
        }
    }
