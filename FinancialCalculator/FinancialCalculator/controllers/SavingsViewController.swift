//
//  SecondViewController.swift
//  FinancialCalculator
//
//  Created by Shenali Samaranayake on 2/21/20.
//  Copyright © 2020 Shenali Samaranayake. All rights reserved.
//

import UIKit

enum SavingsUnits: Double {
    case futureValue, payment, annualInterestRate, numberOfYears, compoundsPerYear
}

extension UITextField {
    
    func setSPadding(){ //set padding inside text fields
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = padding
        self.leftViewMode = .always
    }
}

class SavingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var futureValueTextF: UITextField!
    @IBOutlet weak var paymentPerYearTextF: UITextField!
    @IBOutlet weak var annualInterestTextF: UITextField!
    @IBOutlet weak var noOfYearsTextF: UITextField!
    @IBOutlet weak var compoundsTextF: UITextField!
    @IBOutlet weak var keyboard: Keyboard!
    
    var savings : Savings = Savings(futureValue: 0.0, payment: 0.0, annualInterestRate: 0.0, numberOfYears: 0.0, compoundsPerYear: 0.0)
     
    
    override func viewDidLoad() {
           super.viewDidLoad()
           self.assignDelegates()
           futureValueTextF.setSPadding()
           paymentPerYearTextF.setSPadding()
           annualInterestTextF.setSPadding()
           noOfYearsTextF.setSPadding()
           compoundsTextF.setSPadding()
       }
    
    func assignDelegates() {
        futureValueTextF?.delegate = self
        paymentPerYearTextF?.delegate = self
        annualInterestTextF?.delegate = self
        noOfYearsTextF?.delegate = self
        compoundsTextF?.delegate = self
    }
    
    @IBAction func textValueEdited(_ sender: UITextField) {
        getTextFieldData();
    }
    
    //Clear all the fields
    @IBAction func clearAllFields(_ sender: UIBarButtonItem) {
        futureValueTextF.text = ""
        paymentPerYearTextF.text = ""
        annualInterestTextF.text = ""
        noOfYearsTextF.text = ""
        compoundsTextF.text = ""
        getTextFieldData()
    }
    
    //savings caculation method
    @IBAction func calculateFunction(_ sender: Any) {
        if((self.futureValueTextF.text?.isEmpty == nil ?? false) && (self.paymentPerYearTextF.text?.isEmpty == nil ?? false) && (self.annualInterestTextF.text?.isEmpty == nil ?? false) && (self.noOfYearsTextF.text?.isEmpty == nil ?? false) && (self.compoundsTextF.text?.isEmpty == nil ?? false) ) {
                   validationPopUp(error: "Empty the required field") //Handles if all fields are not empty
        } else {
            
            if((self.futureValueTextF.text?.isEmpty == nil ?? false) || (self.paymentPerYearTextF.text?.isEmpty == nil ?? false) || (self.annualInterestTextF.text?.isEmpty == nil ?? false) || (self.noOfYearsTextF.text?.isEmpty == nil ?? false) || (self.compoundsTextF.text?.isEmpty == nil ?? false) ){
                
                savings.futureValue = NSString(string: futureValueTextF.text!).doubleValue
                savings.payment = NSString(string: paymentPerYearTextF.text!).doubleValue
                savings.annualInterestRate = NSString(string: annualInterestTextF.text!).doubleValue
                savings.numberOfYears = NSString(string: noOfYearsTextF.text!).doubleValue
                savings.compoundsPerYear = NSString(string: compoundsTextF.text!).doubleValue
            
            let interestRate = savings.annualInterestRate/100  //annual interest rate
                
            if ((self.futureValueTextF.text?.isEmpty == nil ?? true) && ((self.paymentPerYearTextF.text?.isEmpty == nil ?? false) && (self.annualInterestTextF.text?.isEmpty == nil ?? false) && (self.noOfYearsTextF.text?.isEmpty == nil ?? false) && (self.compoundsTextF.text?.isEmpty == nil ?? false))){
                let futureVal = (savings.payment * (pow((1 + (interestRate/savings.compoundsPerYear)), (savings.compoundsPerYear * savings.numberOfYears))))
                 
                //handles if the value is null infinite or lesser than 0
                if(!futureVal.isLess(than: 0.0) && !futureVal.isNaN && !futureVal.isInfinite){
                     futureValueTextF.text = intToDouble(value:futureVal)
                } else {
                    validationPopUp(error: "Invalid Annual Insterest")
                }
                    
            }
            else if ((self.annualInterestTextF.text?.isEmpty == nil ?? true) && ((self.futureValueTextF.text?.isEmpty == nil ?? false) && (self.paymentPerYearTextF.text?.isEmpty == nil ?? false) && (self.noOfYearsTextF.text?.isEmpty == nil ?? false) && (self.compoundsTextF.text?.isEmpty == nil ?? false))){
                
                if (savings.futureValue > savings.payment) {  // the future value cannot be lesser than the payment
                 let aIterestRate = savings.compoundsPerYear * ( pow((savings.futureValue/savings.payment), (1/(savings.compoundsPerYear * savings.numberOfYears))) - 1)

                 if(!aIterestRate.isLess(than: 0.0) && !aIterestRate.isNaN && !aIterestRate.isInfinite){
                     annualInterestTextF.text = intToDouble(value:aIterestRate*100)
                 } else {
                    validationPopUp(error: "Invalid Annual Interest")
                }
                } else {
                     validationPopUp(error:"Principal Investment cannot exceed Future Value")
                }
                }
            
            else if ((self.paymentPerYearTextF.text?.isEmpty == nil ?? true) && ((self.futureValueTextF.text?.isEmpty == nil ?? false) && (self.annualInterestTextF.text?.isEmpty == nil ?? false) && (self.noOfYearsTextF.text?.isEmpty == nil ?? false) && (self.compoundsTextF.text?.isEmpty == nil ?? false))){
                let payment = savings.futureValue / (pow((1 + (interestRate/savings.compoundsPerYear)), (savings.compoundsPerYear * savings.numberOfYears)))

                if(!payment.isLess(than: 0.0) && !payment.isNaN && !payment.isInfinite){
                    paymentPerYearTextF.text = intToDouble(value:payment)
                } else {
                    validationPopUp(error: "Invalid Payment Amount")
                }

                }
            
            else if ((self.noOfYearsTextF.text?.isEmpty == nil ?? true) && ((self.futureValueTextF.text?.isEmpty == nil ?? false) && (self.annualInterestTextF.text?.isEmpty == nil ?? false) && (self.paymentPerYearTextF.text?.isEmpty == nil ?? false) && (self.compoundsTextF.text?.isEmpty == nil ?? false))){
                
                if (savings.futureValue > savings.payment) {
                let years = (log(savings.futureValue/savings.payment)) / (savings.compoundsPerYear * (log(1 + (interestRate/savings.compoundsPerYear))))

                if(!years.isLess(than: 0.0) && !years.isNaN && !years.isInfinite){
                  noOfYearsTextF.text = "\(String(format: "%.0f", years))" as String
                } else {
                    validationPopUp(error: "Invalid Number of Years")
                }
                } else {
                    validationPopUp(error:"Principal Investment cannot exceed Future Value")
                }
             }
                
            else if ((self.compoundsTextF.text?.isEmpty == nil ?? true) && ((self.futureValueTextF.text?.isEmpty == nil ?? false) && (self.annualInterestTextF.text?.isEmpty == nil ?? false) && (self.paymentPerYearTextF.text?.isEmpty == nil ?? false) && (self.noOfYearsTextF.text?.isEmpty == nil ?? false))){
                
                if (savings.futureValue > savings.payment) {
                    compoundsTextF.text = "12"
                } else {
                    validationPopUp(error:"Principal Investment cannot exceed Future Value")
                }
                
             
            } else {
                validationPopUp(error:"More than one field is empty")
                
                }
            } else {
                validationPopUp(error: "Fill in the required fields")
                
            }
            
        }
        
    }
    
    func getTextFieldData (){
        let futureValS = futureValueTextF.text
        let paymentS = paymentPerYearTextF.text
        let interestS = annualInterestTextF.text
        let yearsS = noOfYearsTextF.text
        let compoundsS = compoundsTextF.text
        
        UserDefaults.standard.set(futureValS, forKey: "futureValS")
        UserDefaults.standard.set(paymentS, forKey: "paymentS")
        UserDefaults.standard.set(interestS, forKey: "interestS")
        UserDefaults.standard.set(yearsS, forKey: "yearsS")
        UserDefaults.standard.set(compoundsS, forKey: "compoundsS")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let savedFutureVal = UserDefaults.standard.object(forKey: "futureValS") as? String {
            futureValueTextF.text = String(savedFutureVal);
        }
        if let savedPayment = UserDefaults.standard.object(forKey: "paymentS") as? String {
            paymentPerYearTextF.text = String(savedPayment);
        }
        if let savedinterest = UserDefaults.standard.object(forKey: "interestS") as? String {
            annualInterestTextF.text = String(savedinterest);
        }
        if let savedYears = UserDefaults.standard.object(forKey: "yearsS") as? String {
            noOfYearsTextF.text = String(savedYears);
        }
        if let savedCompounds = UserDefaults.standard.object(forKey: "compoundsS") as? String {
            compoundsTextF.text = String(savedCompounds);
               }
    }
    
    // sets the double value to two decimal places
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
