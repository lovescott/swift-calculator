//
//  ViewController.swift
//  Calculator
//
//  Copyright (c) 2015 Scott Love. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var userIsInTheMiddleOfTypingANumber = false
    var operandStack = Array<Double>()
    var brain = CalculatorBrain()
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var history: UILabel!
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if(userIsInTheMiddleOfTypingANumber){
            display.text = display.text! + digit
        }
        else{
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue){
            displayValue = result
            trackHistory()
        }else{
            displayValue = 0
            history.text = " "
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                displayValue = result
                trackHistory()
            }else{
                displayValue = 0
                history.text = " "
            }
        }
    }
    
    @IBAction func decimalPressed() {
        let decimalLocation = display.text!.rangeOfString(".")
        
        if userIsInTheMiddleOfTypingANumber{
            display.text = decimalLocation == nil ? display.text! + "." : display.text!
        }
        else{
            display.text = "0" + "."
            userIsInTheMiddleOfTypingANumber = true
        }

    }
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        brain.clearStack()
        operandStack.removeAll(keepCapacity: false)
        display.text = "0"
        history.text = " "
        
    }
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    func trackHistory(){
        history.text = brain.descriptionOfStack()
    }
}

