//
//  Mortage.swift
//  FinancialCalculator
//
//  Created by Shenali Samaranayake on 3/10/20.
//  Copyright © 2020 Shenali Samaranayake. All rights reserved.
//

import Foundation

class Mortage {
    var loan : Double
    var interest : Double
    var payment : Double
    var years : Double
    
    init(loan: Double, interest: Double, payment: Double,years: Double) {
        self.loan = loan
        self.interest = interest
        self.payment = payment
        self.years = years
    }
}
 
