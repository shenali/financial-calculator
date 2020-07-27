//
//  CompoundSavings.swift
//  FinancialCalculator
//
//  Created by Shenali Samaranayake on 3/10/20.
//  Copyright © 2020 Shenali Samaranayake. All rights reserved.
//

import Foundation


class CompoundSavings {
    var principalInvestment : Double
    var futureValue : Double
    var annualInterestRate : Double
    var payment : Double
    var compoundsPerYear : Double
    var numberOfMonths : Double

    
    init(principalInvestment: Double,futureValue: Double,  annualInterestRate: Double,payment: Double, compoundsPerYear: Double, numberOfMonths: Double) {
        self.principalInvestment = principalInvestment
        self.futureValue = futureValue
        self.annualInterestRate = annualInterestRate
        self.payment = payment
        self.compoundsPerYear = compoundsPerYear
        self.numberOfMonths = numberOfMonths
    
    }
}
