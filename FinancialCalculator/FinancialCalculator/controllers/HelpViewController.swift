//
//  HelpViewController.swift
//  FinancialCalculator
//
//  Created by Shenali Samaranayake on 3/9/20.
//  Copyright © 2020 Shenali Samaranayake. All rights reserved.
//

import UIKit

class HelpViewController : UIViewController {
    
     let tableView:UITableView = {
           let tb = UITableView()
            tb.translatesAutoresizingMaskIntoConstraints = false
            return tb
        }()

        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupTableView()
        
        }
        
        fileprivate func setupTableView() {
            view.addSubview(tableView)
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant:110).isActive = true
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
            tableView.backgroundColor = UIColor.clear
            tableView.register(HelpViewCell.self, forCellReuseIdentifier: "cell")
            tableView.delegate = self
            tableView.dataSource = self
        }

        let data = [
            HelpViewCellData(title: "Savings", content: "The savings category is considered  as a type of savings where the sum of the investment ifs fixed and there will be no futher payments. User has to enter the details to the text fields while keeping the desired field empty. The app will calculate the accurate value for the nearest to decimal points"),
            HelpViewCellData(title: "Compound Savings", content: "The Compound category is considered  as a type of savings where the sum will be invested with a susequent furthure monthly contribution. The user is capable of calculating compound savings when the deposists are made at the end of the periods as well as the begining of the period."),
            HelpViewCellData(title: "Loans", content: "The loans category is considered  as a type of loan with a compound interest combined with regular payment. User has to enter the details to the text fields while keeping the desired field empty. The app will calculate the accurate value for the nearest to decimal points"),
            HelpViewCellData(title: "Mortages", content: "The Mortages category is proved to calculate the loan in which the a property or a real estate is used as a collateral. User has to enter the details to the text fields while keeping the desired field empty. The app will calculate the accurate value for the nearest to decimal points"),
            HelpViewCellData(title: "How to Calculate", content: "The value of the field that needs to be calculated by the user has to be kept empty while all other fields are filled. Then click on the calculate button to obtain the accurate result for the entered amounts. In the compound Savings the switch should be used to select between deposist at end and begining."),
            HelpViewCellData(title: "About Us", content: "This is a financial app that allows a user to calculate savings, compound savings loans and mortages.This app provides accurate solutions for all the financial calculations.It consists of a custom keyboard whcich allows the user to perform the calculations on the textfields as needed.")
        ]

        var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
        
    }

    struct HelpViewCellData {
        var title: String
        var content: String
    }

    extension HelpViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if selectedIndex == indexPath { return 300 }
            return 75
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HelpViewCell
            tableCell.data = data[indexPath.row]
            tableCell.selectionStyle = .none
            tableCell.backgroundColor = UIColor.clear
            tableCell.animate()
            return tableCell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedIndex = indexPath
            
            tableView.beginUpdates()
            tableView.reloadRows(at: [selectedIndex], with: .none)
            tableView.endUpdates()
        }
        
        
    
}
