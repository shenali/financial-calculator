//
//  MortageViewController.swift
//  FinancialCalculator
//
//  Created by Shenali Samaranayake on 3/5/20.
//  Copyright © 2020 Shenali Samaranayake. All rights reserved.
//

import Foundation
import UIKit

enum MortageUnits: Double {
    case loan, interest, payment, years
}

extension UITextField {
    
    func setMPadding(){ //set padding inside text fields
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = padding
        self.leftViewMode = .always
    }
}

class MortageViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var loanAmountTextF: UITextField!
    @IBOutlet weak var interestTextF: UITextField!
    @IBOutlet weak var paymentTextF: UITextField!
    @IBOutlet weak var noOfMonthsTextF: UITextField!
    @IBOutlet weak var keyboard: Keyboard!
    
    var mortage : Mortage = Mortage(loan: 0.0, interest: 0.0, payment: 0.0, years: 0.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignDelegates()
        loanAmountTextF.setMPadding()
        interestTextF.setMPadding()
        paymentTextF.setMPadding()
        noOfMonthsTextF.setMPadding()
    }
    
    func assignDelegates() {
        loanAmountTextF?.delegate = self
        interestTextF?.delegate = self
        paymentTextF?.delegate = self
        noOfMonthsTextF?.delegate = self
    }
    
    
    @IBAction func edtingEnd(_ sender: UITextField) {
        getTextFieldData ();   //Get the values of the textfields when they are done editing
    }
    
    
    //Clear all the fields
    @IBAction func clearAllFields(_ sender: UIBarButtonItem) {
        loanAmountTextF.text = ""
        interestTextF.text = ""
        paymentTextF.text = ""
        noOfMonthsTextF.text = ""
        getTextFieldData ();
    }
    
    //Calculate functionality for the mortages
    @IBAction func calculateAction(_ sender: Any) {
        if((self.loanAmountTextF.text?.isEmpty == nil ?? false) && (self.interestTextF.text?.isEmpty == nil ?? false) && (self.paymentTextF.text?.isEmpty == nil ?? false) && (self.noOfMonthsTextF.text?.isEmpty == nil ?? false)) {
            validationPopUp(error: "Keep the required field empty") //Handles if all fields are not empty

        } else {
            
            if((self.loanAmountTextF.text?.isEmpty == nil ?? false) || (self.interestTextF.text?.isEmpty == nil || false) || (self.paymentTextF.text?.isEmpty == nil ?? false) || (self.noOfMonthsTextF.text?.isEmpty == nil ?? false) ){
                
                mortage.loan = NSString(string: loanAmountTextF.text!).doubleValue
                mortage.interest = NSString(string: interestTextF.text!).doubleValue
                mortage.payment = NSString(string: paymentTextF.text!).doubleValue
                mortage.years = NSString(string: noOfMonthsTextF.text!).doubleValue
                
                let monthlyInterestRate = mortage.interest/1200 //interest is converted to monthly rate
                let yearToMonths = mortage.years * 12
                
                if ((self.paymentTextF.text?.isEmpty == nil ?? true) && ((self.noOfMonthsTextF.text?.isEmpty == nil ?? false) && (self.loanAmountTextF.text?.isEmpty == nil ?? false) && (self.interestTextF.text?.isEmpty == nil ?? false))){
                    
                    var payment:Double = 0.0
                    
                    if(!(mortage.interest == 0.0)){
                        payment = ((mortage.loan * monthlyInterestRate) * pow((1 + monthlyInterestRate),yearToMonths)) /
                            (pow((1 + monthlyInterestRate),yearToMonths) - 1)
                    } else {
                        payment = mortage.loan / yearToMonths
                    }
                    
                    if(!payment.isLess(than: 0.0) && !payment.isNaN && !payment.isInfinite){
                        paymentTextF?.text = intToDouble(value:payment)
                        
                    } else {
                        validationPopUp(error:"Invalid Payment Amount")
                    }
                }
                    
                else if ((self.loanAmountTextF.text?.isEmpty == nil ?? true) && ((self.interestTextF.text?.isEmpty == nil ?? false) && (self.paymentTextF.text?.isEmpty == nil ?? false) && (self.noOfMonthsTextF.text?.isEmpty == nil ?? false))){
                    
                    var loan:Double = 0.0
                    
                    if(!(mortage.interest == 0.0)){
                        loan = (mortage.payment * (pow((1 + monthlyInterestRate), yearToMonths)-1) /
                            (monthlyInterestRate * pow((1 + monthlyInterestRate), yearToMonths)))
                    } else {
                        loan = mortage.payment * yearToMonths
                    }
                    
                    if(!loan.isLess(than: 0.0) && !loan.isNaN && !loan.isInfinite){
                        loanAmountTextF?.text = intToDouble(value:loan)
                        
                    } else {
                        validationPopUp(error:"Invalid Loan Amount")
                    }
                }
                    
                else if ((self.noOfMonthsTextF.text?.isEmpty == nil ?? true) && ((self.loanAmountTextF.text?.isEmpty == nil ?? false) && (self.interestTextF.text?.isEmpty == nil ?? false) && (self.paymentTextF.text?.isEmpty == nil ?? false))){
                    
                    var months:Double = 0.0
                    
                    if(!(mortage.interest == 0.0)){
                        months = log(mortage.payment / (mortage.payment - (mortage.loan * monthlyInterestRate))) /
                            (log(1 + monthlyInterestRate))
                    } else {
                        months = mortage.loan / mortage.payment
                    }
                    
                    if(!months.isLess(than: 0.0) && !months.isNaN && !months.isInfinite){
                        noOfMonthsTextF?.text = "\(String(format: "%.0f", (months/12)))" as String
                        print("months" , months)
                        
                    } else {
                        validationPopUp(error:"Invalid Number of Years")
                    }
                    
                }
                    
                else if ((self.interestTextF.text?.isEmpty == nil ?? true) && ((self.noOfMonthsTextF.text?.isEmpty == nil ?? false) && (self.loanAmountTextF.text?.isEmpty == nil ?? false) && (self.paymentTextF.text?.isEmpty == nil ?? false))){
                    
                    var currentInterest:Double = 0.0
                    var f:Double = 0.0
                    var fDash:Double = 0.0
                    var assumedInterest:Double = 0.0
                    
                    assumedInterest = 1 + (((mortage.payment * yearToMonths/mortage.loan)-1) / 12 ) //guesses the interest rate
                    currentInterest = assumedInterest
                    
                    let precision = Double(0.000001)
                    
                    func F (x:Double)->Double {
                        f = (mortage.loan * pow(x, (yearToMonths + 1))) - ((mortage.loan + mortage.payment) * pow(x, yearToMonths) ) + mortage.payment
                        return f
                    }
                    func FDash(x:Double)->Double {
                        fDash = (mortage.loan * (yearToMonths + 1) * (pow(x,yearToMonths))) - (mortage.loan + mortage.payment) *
                            yearToMonths * (pow(x, (yearToMonths - 1)))
                        
                        return fDash
                        
                    }
                    
                    while (abs(F(x: currentInterest)) > precision){
                        currentInterest = currentInterest - F(x: currentInterest)/FDash(x: currentInterest)
                    }
                    
                    let finalInterest = (12 * (currentInterest - 1) * 100)
                    if(!finalInterest.isNaN && !finalInterest.isInfinite ){ //Handles if interst is nan or infinite
                        
                        if (finalInterest < 0.0 || finalInterest > 100.00) { //handles if interest not between 0 to 100
                            validationPopUp(error:"Invalid Interest Rate")
                        } else {
                            interestTextF?.text = intToDouble(value:finalInterest)
                        }
                        
                    } else {
                        validationPopUp(error:"Invalid Interest Rate")
                    }
                    
                } else {
                    validationPopUp(error:"More than one field is empty")
                }
                
            } else {
                validationPopUp(error:"Fill in the required fields")
            }
            
        }
        
    }
    
    // Save all the text field data before saving in the user defaults
    func getTextFieldData (){
        let loanT = loanAmountTextF.text
        let interestT = interestTextF.text
        let paymentT = paymentTextF.text
        let monthsT = noOfMonthsTextF.text
        
        UserDefaults.standard.set(loanT, forKey: "loanM")
        UserDefaults.standard.set(interestT, forKey: "interestM")
        UserDefaults.standard.set(paymentT, forKey: "paymentM")
        UserDefaults.standard.set(monthsT, forKey: "monthsM")
    }
    
    //Load all the text field values when the screen appears
    override func viewDidAppear(_ animated: Bool) {
        if let savedLoan = UserDefaults.standard.object(forKey: "loanM") as? String {
            loanAmountTextF?.text = String(savedLoan);
        }
        if let savedIntrest = UserDefaults.standard.object(forKey: "interestM") as? String {
            interestTextF?.text = String(savedIntrest);
        }
        if let savedPayment = UserDefaults.standard.object(forKey: "paymentM") as? String {
            paymentTextF?.text = String(savedPayment);
        }
        if let savedMonths = UserDefaults.standard.object(forKey: "monthsM") as? String {
            noOfMonthsTextF?.text = String(savedMonths);
        }
    }

    //converts all the double values to two decimal places
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

