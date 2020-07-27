//
//  cSavingViewController.swift
//  FinancialCalculator
//
//  Created by Shenali Samaranayake on 3/5/20.
//  Copyright © 2020 Shenali Samaranayake. All rights reserved.
//

import UIKit

enum CSavingsUnits: Double {
    case principalInvestment, futureValue, annualInterestRate, payment, compoundsPerYear, numberOfMonths
}

extension UITextField {
    
    func setCSPadding(){ //set padding inside text fields
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = padding
        self.leftViewMode = .always
    }
}


class CSavingViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var principalInvestmentTextF: UITextField!
    @IBOutlet weak var futureValTextF: UITextField!
    @IBOutlet weak var interestTextF: UITextField!
    @IBOutlet weak var paymentTextF: UITextField!
    @IBOutlet weak var compoundsPYearTextF: UITextField!
    @IBOutlet weak var noOfMonthsTextF: UITextField!
    @IBOutlet weak var depositSwitch: UISwitch!
    @IBOutlet weak var keyboard: Keyboard!
    @IBOutlet weak var switchText: UILabel!
    
    var cSavings : CompoundSavings = CompoundSavings(principalInvestment:0.0, futureValue: 0.0,annualInterestRate: 0.0, payment: 0.0,   compoundsPerYear: 0.0, numberOfMonths: 0.0)
    
    
    var switchOn = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignDelegates()
        principalInvestmentTextF.setCSPadding()
        futureValTextF.setCSPadding()
        interestTextF.setCSPadding()
        paymentTextF.setCSPadding()
        noOfMonthsTextF.setCSPadding()
        compoundsPYearTextF.setCSPadding()
    }
    
    
    func assignDelegates() {
        principalInvestmentTextF.delegate = self
        futureValTextF.delegate = self
        interestTextF.delegate = self
        paymentTextF.delegate = self
        compoundsPYearTextF.delegate = self
        noOfMonthsTextF.delegate = self
    }
    
    
    @IBAction func textValueEdited(_ sender: UITextField) {
        getTextFieldData()
    }
    
    @IBAction func switchFunctionality(_ sender: UISwitch) {
        if(sender.isOn ) {
            switchOn = true //switch is on
            switchText.text = "Deposit at End"
        } else {
            switchOn = false
            switchText.text = "Deposit at Begining"
        }
    }
    
    //clear all method functionality
    @IBAction func clearAllFields(_ sender: Any) {
        principalInvestmentTextF.text = ""
        futureValTextF.text = ""
        interestTextF.text = ""
        paymentTextF.text = ""
        noOfMonthsTextF.text = ""
        compoundsPYearTextF.text = ""
        getTextFieldData()
    }
    
    //calculate button functionalith
    @IBAction func calculateFunctionality(_ sender: Any) {
        depositFunction ()
        
    }
    
    
    func depositFunction () {
        if((self.principalInvestmentTextF.text?.isEmpty == nil ?? false) && (self.futureValTextF.text?.isEmpty == nil ?? false) && (self.interestTextF.text?.isEmpty == nil ?? false) && (self.paymentTextF.text?.isEmpty == nil ?? false) && (self.compoundsPYearTextF.text?.isEmpty == nil ?? false) &&  (self.noOfMonthsTextF.text?.isEmpty == nil ?? false) ){
            validationPopUp(error: "Keep the required field empty")
            
        } else {
            if((self.principalInvestmentTextF.text?.isEmpty == nil ?? false) || (self.futureValTextF.text?.isEmpty == nil ?? false) || (self.interestTextF.text?.isEmpty == nil ?? false) || (self.paymentTextF.text?.isEmpty == nil ?? false) || (self.compoundsPYearTextF.text?.isEmpty == nil ?? false) ||  (self.noOfMonthsTextF.text?.isEmpty == nil ?? false) ){
                
                cSavings.principalInvestment = NSString(string: principalInvestmentTextF.text!).doubleValue
                cSavings.futureValue = NSString(string: futureValTextF.text!).doubleValue
                cSavings.annualInterestRate = NSString(string: interestTextF.text!).doubleValue
                cSavings.payment = NSString(string: paymentTextF.text!).doubleValue
                cSavings.compoundsPerYear = NSString(string: compoundsPYearTextF.text!).doubleValue
                cSavings.numberOfMonths = NSString(string: noOfMonthsTextF.text!).doubleValue
                
                let monthlyInterestRate = cSavings.annualInterestRate/100
                
                if (((self.futureValTextF.text?.isEmpty == nil ?? true) && ((self.principalInvestmentTextF.text?.isEmpty == nil ?? false) && (self.interestTextF.text?.isEmpty == nil ?? false) && (self.paymentTextF.text?.isEmpty == nil ?? false) && (self.compoundsPYearTextF.text?.isEmpty == nil ?? false) &&  (self.noOfMonthsTextF.text?.isEmpty == nil ?? false)))){
                    
                    var futureVal:Double = 0.0
                    
                    if (switchOn) { // for end deposits
                        let compoundIntrestP = (cSavings.principalInvestment * pow((1 + (monthlyInterestRate/cSavings.compoundsPerYear)), (cSavings.compoundsPerYear * cSavings.numberOfMonths)))
                        let futureValOfSeries = ((
                            cSavings.payment / (monthlyInterestRate/cSavings.compoundsPerYear))  * ((pow((1 + (monthlyInterestRate/cSavings.compoundsPerYear)), (cSavings.compoundsPerYear * cSavings.numberOfMonths))) - 1)  )
                        futureVal = compoundIntrestP + futureValOfSeries
                        
                    }  else {  // for begining deposits
                        let compoundIntrestP = cSavings.principalInvestment * pow((1 + (monthlyInterestRate/cSavings.compoundsPerYear)), (cSavings.compoundsPerYear * cSavings.numberOfMonths))
                        let futureValOfSeries = (cSavings.payment  * (((pow((1 + (monthlyInterestRate/cSavings.compoundsPerYear)), (cSavings.compoundsPerYear * cSavings.numberOfMonths))) - 1) / (monthlyInterestRate/cSavings.compoundsPerYear)) * (1 + (monthlyInterestRate / cSavings.compoundsPerYear)))
                        
                        futureVal = compoundIntrestP + futureValOfSeries
                        
                    }
                    
                    if(!futureVal.isLess(than: 0.0) && !futureVal.isNaN && !futureVal.isInfinite){
                        futureValTextF.text = intToDouble(value:futureVal)
                    } else {
                        validationPopUp(error:"Invalid Future Value")
                    }
                }
                    
                else if ((self.principalInvestmentTextF.text?.isEmpty == nil ?? true) && ((self.futureValTextF.text?.isEmpty == nil ?? false) && (self.interestTextF.text?.isEmpty == nil ?? false) && (self.paymentTextF.text?.isEmpty == nil ?? false) && (self.compoundsPYearTextF.text?.isEmpty == nil ?? false) &&  (self.noOfMonthsTextF.text?.isEmpty == nil ?? false))){
                    
                    var investment:Double = 0.0
                    
                    if (switchOn) {
                        let numeratorI = (cSavings.futureValue - ((cSavings.payment/(monthlyInterestRate/cSavings.compoundsPerYear)) *
                            (pow((1 + (monthlyInterestRate/cSavings.compoundsPerYear)), (cSavings.compoundsPerYear * cSavings.numberOfMonths)) - 1)))
                        let denominatorI = (pow ((1+(monthlyInterestRate/cSavings.compoundsPerYear)) , (cSavings.compoundsPerYear * cSavings.numberOfMonths)))
                        investment = numeratorI / denominatorI
                        
                    } else {
                        let numeratorI = (cSavings.futureValue - (cSavings.payment  * (((pow((1 + (monthlyInterestRate/cSavings.compoundsPerYear)), (cSavings.compoundsPerYear * cSavings.numberOfMonths))) - 1) /
                            (monthlyInterestRate/cSavings.compoundsPerYear)) * (1 + (monthlyInterestRate / cSavings.compoundsPerYear))))
                        let denominatorI = (pow ((1+(monthlyInterestRate/cSavings.compoundsPerYear)) , (cSavings.compoundsPerYear * cSavings.numberOfMonths)))
                        investment = numeratorI / denominatorI
                        
                    }
                    
                    if(!investment.isLess(than: 0.0) && !investment.isNaN && !investment.isInfinite){
                        principalInvestmentTextF.text = intToDouble(value:investment)
                    } else {
                        validationPopUp(error:"Invalid Principal Investment")
                    }
                }
                    
                else if ((self.paymentTextF.text?.isEmpty == nil ?? true) && ((self.futureValTextF.text?.isEmpty == nil ?? false) && (self.interestTextF.text?.isEmpty == nil ?? false) && (self.principalInvestmentTextF.text?.isEmpty == nil ?? false) && (self.compoundsPYearTextF.text?.isEmpty == nil ?? false) &&  (self.noOfMonthsTextF.text?.isEmpty == nil ?? false))){
                    
                    if (cSavings.futureValue > cSavings.principalInvestment) {
                        
                        var payment:Double = 0.0
                        
                        if(switchOn){
                            let numeratorP = (cSavings.futureValue - (cSavings.principalInvestment * (pow ((1 + (monthlyInterestRate/cSavings.compoundsPerYear)),(cSavings.compoundsPerYear * cSavings.numberOfMonths)))))
                            let denominatorP = ((pow((1 + (monthlyInterestRate/cSavings.compoundsPerYear)), (cSavings.compoundsPerYear * cSavings.numberOfMonths))) - 1) /
                                (monthlyInterestRate/cSavings.compoundsPerYear)
                            payment = numeratorP / denominatorP
                            
                        } else {
                            let numeratorP = (cSavings.futureValue - (cSavings.principalInvestment * (pow ((1 + (monthlyInterestRate/cSavings.compoundsPerYear)),(cSavings.compoundsPerYear * cSavings.numberOfMonths)))))
                            let denominatorP = (((pow((1 + (monthlyInterestRate/cSavings.compoundsPerYear)), (cSavings.compoundsPerYear * cSavings.numberOfMonths))) - 1) /
                                (monthlyInterestRate/cSavings.compoundsPerYear)) * (1 + (monthlyInterestRate / cSavings.compoundsPerYear))
                            payment = numeratorP / denominatorP
                            
                        }
                        if(!payment.isLess(than: 0.0) && !payment.isNaN && !payment.isInfinite){
                            paymentTextF.text = intToDouble(value:payment)
                            
                        } else {
                            validationPopUp(error:"Invalid Payment Amount")
                        }
                    } else {
                        validationPopUp(error:"Principal Investment cannot exceed the Future Value")
                    }
                    
                }
                    
                else if (((self.noOfMonthsTextF.text?.isEmpty == nil ?? true) && ((self.futureValTextF.text?.isEmpty == nil ?? false) && (self.interestTextF.text?.isEmpty == nil ?? false) && (self.principalInvestmentTextF.text?.isEmpty == nil ?? false) && (self.compoundsPYearTextF.text?.isEmpty == nil ?? false) &&  (self.paymentTextF.text?.isEmpty == nil ?? false))) ){
                    
                    if (cSavings.futureValue > cSavings.principalInvestment) {
                        
                        var years:Double = 0.0
                        
                        if (switchOn) {
                            let numeratorM = log((cSavings.futureValue + ((cSavings.payment * cSavings.compoundsPerYear) / monthlyInterestRate )) /
                                (cSavings.principalInvestment + ((cSavings.payment * cSavings.compoundsPerYear) / monthlyInterestRate )))
                            let denominatorM = cSavings.compoundsPerYear * log(1+(monthlyInterestRate/cSavings.compoundsPerYear))
                            print(denominatorM)
                            years = numeratorM / denominatorM
                            
                        } else {
                            let numeratorM = log((cSavings.futureValue + ((cSavings.payment / (monthlyInterestRate/cSavings.compoundsPerYear)) *
                                (1+(monthlyInterestRate/cSavings.compoundsPerYear)))) / (cSavings.principalInvestment + ((cSavings.payment / (monthlyInterestRate/cSavings.compoundsPerYear)) * (1+(monthlyInterestRate/cSavings.compoundsPerYear)))))
                            let denominatorM = cSavings.compoundsPerYear * log(1+(monthlyInterestRate/cSavings.compoundsPerYear))
                            years = numeratorM / denominatorM
                            
                        }
                        if(!years.isLess(than: 0.0)  && !years.isNaN && !years.isInfinite){  // handles invalid months
                            noOfMonthsTextF.text = "\(String(format: "%.0f", years))" as String
                            
                        } else {
                            validationPopUp(error:"Invalid Number of months")
                        }
                        
                    } else {
                        validationPopUp(error:"Principal Investment cannot exceed Future Value")
                    }
                    
                }
                else if (((self.interestTextF.text?.isEmpty == nil ?? true) && ((self.futureValTextF.text?.isEmpty == nil ?? false) && (self.noOfMonthsTextF.text?.isEmpty == nil ?? false) && (self.principalInvestmentTextF.text?.isEmpty == nil ?? false) && (self.compoundsPYearTextF.text?.isEmpty == nil ?? false) &&  (self.paymentTextF.text?.isEmpty == nil ?? false))) ) {
                    validationPopUp(error:"Function not available")
                }
                    
                else if (((self.compoundsPYearTextF.text?.isEmpty == nil ?? true) && ((self.futureValTextF.text?.isEmpty == nil ?? false) && (self.noOfMonthsTextF.text?.isEmpty == nil ?? false) && (self.principalInvestmentTextF.text?.isEmpty == nil ?? false) && (self.interestTextF.text?.isEmpty == nil ?? false) &&  (self.paymentTextF.text?.isEmpty == nil ?? false))) ) {
                    
                    if (cSavings.futureValue > cSavings.principalInvestment) {
                         compoundsPYearTextF.text = "12"
                    } else {
                        validationPopUp(error:"Principal Investment cannot exceed Future Value")
                    }
                   
                }
                    
                else {
                    validationPopUp(error:"More than one field is empty")
                    
                }
                
            } else {
                validationPopUp(error: "Fill in the required fields")
                
            }
            
        }
        
    }
    
    // Save all text field data to defaults
    func getTextFieldData (){
        let principalInvestCS = principalInvestmentTextF.text
        let futureValCS = futureValTextF.text
        let interestCS = interestTextF.text
        let paymentCS = paymentTextF.text
        let monthsCS = noOfMonthsTextF.text
        let compoundsCS = compoundsPYearTextF.text
        
        UserDefaults.standard.set(principalInvestCS, forKey: "principalInvestCS")
        UserDefaults.standard.set(futureValCS, forKey: "futureValCS")
        UserDefaults.standard.set(interestCS, forKey: "interestCS")
        UserDefaults.standard.set(paymentCS, forKey: "paymentCS")
        UserDefaults.standard.set(monthsCS, forKey: "monthsCS")
        UserDefaults.standard.set(compoundsCS, forKey: "compoundsCS")
    }
    
    
    //Load all text field data from defaults
    override func viewDidAppear(_ animated: Bool) {
        if let savedPrincipalVal = UserDefaults.standard.object(forKey: "principalInvestCS") as? String {
            principalInvestmentTextF.text = String(savedPrincipalVal);
        }
        if let savedFutureVal = UserDefaults.standard.object(forKey: "futureValCS") as? String {
            futureValTextF.text = String(savedFutureVal);
        }
        if let savedInterest = UserDefaults.standard.object(forKey: "interestCS") as? String {
            paymentTextF.text = String(savedInterest);
        }
        if let savedPayment = UserDefaults.standard.object(forKey: "paymentCS") as? String {
            interestTextF.text = String(savedPayment);
        }
        if let savedMonths = UserDefaults.standard.object(forKey: "monthsCS") as? String {
            noOfMonthsTextF.text = String(savedMonths);
        }
        if let savedCompounds = UserDefaults.standard.object(forKey: "compoundsCS") as? String {
            compoundsPYearTextF.text = String(savedCompounds);
        }
    }
    
    //Converts all double values to two decimal places
    func  intToDouble(value:Double )-> String{
        let answer = "\(String(format: "%.02f", value))" as String
        return answer
    }
    
    func validationPopUp(error:String){
        let vc = CustomPopUpViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.errorMessage = error
        self.present(vc, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboard.activeTextField = textField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
        
    }
    
}
