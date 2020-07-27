//
//  CustomPopUpViewController.swift
//  FinancialCalculator
//
//  Created by Shenali Samaranayake on 3/10/20.
//  Copyright © 2020 Shenali Samaranayake. All rights reserved.
//

import UIKit

class CustomPopUpViewController: UIViewController {
    
    @IBOutlet weak var errorText: UILabel!
    var errorMessage:String = ""
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true) //dissmiss popup view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorText.text! = errorMessage
    }

   

}
