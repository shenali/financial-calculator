//
//  SplashScreenViewController.swift
//  FinancialCalculator
//
//  Created by Shenali Samaranayake on 3/16/20.
//  Copyright © 2020 Shenali Samaranayake. All rights reserved.
//

import UIKit
import Foundation

class SplashScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10){
            self.performSegue(withIdentifier: "startPage", sender: nil)
    }

    }

}
