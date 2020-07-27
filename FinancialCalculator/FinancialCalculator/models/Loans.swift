//
//  Loans.swift
//  FinancialCalculator
//
//  Created by Shenali Samaranayake on 3/10/20.
//  Copyright © 2020 Shenali Samaranayake. All rights reserved.
//

import Foundation

class Loans {
    var loan : Double
    var interest : Double
    var payment : Double
    var months : Double
    
    init(loan: Double, interest: Double, payment: Double,months: Double) {
        self.loan = loan
        self.interest = interest
        self.payment = payment
        self.months = months
    }
}
