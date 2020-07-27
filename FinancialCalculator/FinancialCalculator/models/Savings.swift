//
//  Savings.swift
//  FinancialCalculator
//
//  Created by Shenali Samaranayake on 3/10/20.
//  Copyright © 2020 Shenali Samaranayake. All rights reserved.
//

import Foundation

class Savings {
    var futureValue : Double
    var payment : Double
    var annualInterestRate : Double
    var numberOfYears : Double
    var compoundsPerYear : Double
    
    init(futureValue: Double, payment: Double, annualInterestRate: Double,numberOfYears: Double, compoundsPerYear: Double) {
        self.futureValue = futureValue
        self.payment = payment
        self.annualInterestRate = annualInterestRate
        self.numberOfYears = numberOfYears
        self.compoundsPerYear = compoundsPerYear
    }
}
