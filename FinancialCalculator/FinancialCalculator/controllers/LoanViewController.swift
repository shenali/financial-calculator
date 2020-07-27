//
//  LoanViewController.swift
//  FinancialCalculator
//
//  Created by Shenali Samaranayake on 3/5/20.
//  Copyright © 2020 Shenali Samaranayake. All rights reserved.
//

import Foundation
import UIKit

enum LoanUnits: Int {
    case loans, interest, payment, months
}

extension UITextField {

    func setLPadding(){  //sets padding to textfields
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = padding
        self.leftViewMode = .always
    }
}

class LoanViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loanAmountTextF: UITextField!
    @IBOutlet weak var interestTextF: UITextField!
    @IBOutlet weak var paymentTextF: UITextField!
    @IBOutlet weak var noOfMonthsTextF: UITextField!
    @IBOutlet weak var keyboard: Keyboard!
    
    var loans : Loans = Loans(loan: 0.0, interest: 0.0, payment: 0.0, months: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignDelegates()
        loanAmountTextF.setLPadding()
        interestTextF.setLPadding()
        paymentTextF.setLPadding()
        noOfMonthsTextF.setLPadding()
    }
    
    func assignDelegates() {
           loanAmountTextF.delegate = self
           interestTextF.delegate = self
           paymentTextF.delegate = self
           noOfMonthsTextF.delegate = self
       }
    @IBAction func textValueEdited(_ sender: UITextField) {
        getTextFieldData ();
    }
    
    //clears all the fields on all clear button click
    @IBAction func clearAllFields(_ sender: UIBarButtonItem) {
        loanAmountTextF.text = ""
        interestTextF.text = ""
        paymentTextF.text = ""
        noOfMonthsTextF.text = ""
        getTextFieldData ();
    }
    
    //calculate functionality
    @IBAction func calculateFunction(_ sender: Any) {
        if((self.loanAmountTextF.text?.isEmpty == nil ?? false) && (self.interestTextF.text?.isEmpty == nil ?? false) && (self.paymentTextF.text?.isEmpty == nil ?? false) && (self.noOfMonthsTextF.text?.isEmpty == nil ?? false)) { //handles if all fields are full
             validationPopUp(error: "Keep the required field empty")
        } else {
            if((self.loanAmountTextF.text?.isEmpty == nil ?? false) || (self.interestTextF.text?.isEmpty == nil ?? false) ||  (self.paymentTextF.text?.isEmpty == nil ?? false) || (self.noOfMonthsTextF.text?.isEmpty == nil ?? false)){
            
            loans.loan = NSString(string: loanAmountTextF.text!).doubleValue
            loans.interest = NSString(string: interestTextF.text!).doubleValue
            loans.payment = NSString(string: paymentTextF.text!).doubleValue
            loans.months = NSString(string: noOfMonthsTextF.text!).doubleValue
            
            let monthlyInterestRate = loans.interest/1200
               
              if ((self.loanAmountTextF.text?.isEmpty == nil ?? true) && ((self.interestTextF.text?.isEmpty == nil ?? false) && (self.paymentTextF.text?.isEmpty == nil ?? false) && (self.noOfMonthsTextF.text?.isEmpty == nil ?? false))){
                
               var loan:Double = 0.0
               if(!(loans.interest == 0.0)){  // handles cases where interest is zero
                    loan = ( loans.payment / monthlyInterestRate) * (1 - (1/pow((1 + monthlyInterestRate), loans.months)))
                } else {
                loan = loans.payment * loans.months
                }
               if(!loan.isLess(than: 0.0) && !loan.isNaN && !loan.isInfinite){
                   loanAmountTextF.text = intToDouble(value:loan)
                   print("loan ", Double(loan))
               } else {
                validationPopUp(error:"Invalid Loan Amount")
                }
              }
               
             else if ((self.noOfMonthsTextF.text?.isEmpty == nil ?? true) && ((self.loanAmountTextF.text?.isEmpty == nil ?? false) && (self.interestTextF.text?.isEmpty == nil ?? false) && (self.paymentTextF.text?.isEmpty == nil ?? false))){
                var months:Double = 0.0
                
                if(!(loans.interest == 0.0)){ // handles cases where interest is zero
                    months = log((loans.payment/monthlyInterestRate) / ((loans.payment/monthlyInterestRate) - loans.loan)) /
                    log(1 + monthlyInterestRate)
               
                } else {
                    months = loans.loan / loans.payment
                }
                if(!months.isLess(than: 0.0) && !months.isNaN && !months.isInfinite){
                    noOfMonthsTextF.text = "\(String(format: "%.0f", months))" as String
                    print("months ", months)
                } else {
                    validationPopUp(error:"Invalid Number of Months")
                }
             }

               
            else if ((self.paymentTextF.text?.isEmpty == nil ?? true) && ((self.noOfMonthsTextF.text?.isEmpty == nil ?? false) && (self.loanAmountTextF.text?.isEmpty == nil ?? false) && (self.interestTextF.text?.isEmpty == nil ?? false))){
                
                var payment:Double = 0.0
                if(!(loans.interest == 0.0)){ //handles cases where interest is zero
                    payment = (loans.loan * monthlyInterestRate) * (pow((1 + monthlyInterestRate), loans.months)) /
                    (pow((1 + monthlyInterestRate), loans.months) - 1)
                } else {
                    payment = loans.loan / loans.months
                }

                if(!payment.isLess(than: 0.0) && !payment.isNaN && !payment.isInfinite){
                    paymentTextF.text = intToDouble(value:payment)
                   print("payment ", Double(payment))
                } else {
                    validationPopUp(error:"Invalid Payment Amount")
                }
            }
                
            else if ((self.interestTextF.text?.isEmpty == nil ?? true) && ((self.noOfMonthsTextF.text?.isEmpty == nil ?? false) && (self.loanAmountTextF.text?.isEmpty == nil ?? false) && (self.paymentTextF.text?.isEmpty == nil ?? false))){
                    //validationPopUp(error: "This function is not available")
                   var currentInterest:Double = 0.0
                   var f:Double = 0.0
                   var fDash:Double = 0.0
                   var assumedInterest:Double = 0.0
                               
                   assumedInterest = 1 + (((loans.payment * loans.months/loans.loan)-1) / 12 ) //initiall guess of the interest
                   currentInterest = assumedInterest

                   let precision = Double(0.000001)
                   
                   func F (x:Double)->Double {
                    f = (loans.loan * pow(x, (loans.months + 1))) - ((loans.loan + loans.payment) * pow(x, loans.months) ) + loans.payment
                    return f
                   
                   }
                   
                   func FDash(x:Double)->Double {
                    fDash = (loans.loan * (loans.months + 1) * (pow(x,loans.months))) - (loans.loan + loans.payment) *
                            loans.months * (pow(x, (loans.months - 1)))
                    return fDash
                    
                   }
                  
                   while (abs(F(x: currentInterest)) > precision){
                       currentInterest = currentInterest - F(x: currentInterest)/FDash(x: currentInterest)
                       
                   }
            
                let finalInterest = (12 * (currentInterest - 1) * 100)
                
                if(!finalInterest.isNaN && !finalInterest.isInfinite ){  //validate interest values
                    
                    if (finalInterest < 0.0 || finalInterest > 100.00) {
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
                validationPopUp(error:"Fill in the required fields");
            }
        }
        
    }
        
    //save all data to user defaults
    func getTextFieldData (){
        let loanT = loanAmountTextF.text
        let interestT = interestTextF.text
        let paymentT = paymentTextF.text
        let monthsT = noOfMonthsTextF.text
        
        UserDefaults.standard.set(loanT, forKey: "loanL")
        UserDefaults.standard.set(interestT, forKey: "interestL")
        UserDefaults.standard.set(paymentT, forKey: "paymentL")
        UserDefaults.standard.set(monthsT, forKey: "monthsL")
    }
    
    
    //Load all text field data from user defaults
    override func viewDidAppear(_ animated: Bool) {
        if let savedLoan = UserDefaults.standard.object(forKey: "loanL") as? String {
            loanAmountTextF.text = String(savedLoan);
        }
        if let savedIntrest = UserDefaults.standard.object(forKey: "interestL") as? String {
            interestTextF.text = String(savedIntrest);
        }
        if let savedPayment = UserDefaults.standard.object(forKey: "paymentL") as? String {
            paymentTextF.text = String(savedPayment);
        }
        if let savedMonths = UserDefaults.standard.object(forKey: "monthsL") as? String {
            noOfMonthsTextF.text = String(savedMonths);
        }
    }
    
    //convert double values to two decimal places
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



