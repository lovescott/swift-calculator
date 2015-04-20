//
//  ViewController.swift
//  Calculator
//
//  Created by Scott Love on 4/17/15.
//  Copyright (c) 2015 Scott Love. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()
    
    
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
    
    var operandStack = Array<Double>()
    var displayValue: Double {
        get{
           return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        }else{
            displayValue = 0
        }
        //trackHistory(display.text!)
        //println("operandStack = \(operandStack)")
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
//        trackHistory(operation)
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            }else{
                displayValue = 0
            }
        }
//        switch operation {
//        case "×": performOperation { $0 * $1 }
//        case "÷": performOperation { $1 / $0 }
//        case "+": performOperation { $0 + $1 }
//        case "−": performOperation { $1 - $0 }
//        case "√": performOperation { sqrt($0) }
//        case "sin": performOperation { sin($0 * M_PI / 180) }
//        case "cos": performOperation { cos($0 * M_PI / 180) }
//        case "π": performOperation (M_PI)
//        default: break
//        }
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
        operandStack.removeAll(keepCapacity: false)
        display.text = "0"
        history.text = " "
        
    }
    
    private func performOperation (operation: (Double, Double) -> Double){
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    private func performOperation (operation: Double -> Double){
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    private func performOperation (specialOperation: Double){
        displayValue = specialOperation
        enter()
    }
    func trackHistory(historyItem: String){
        history.text = history.text! + " " + historyItem
    }
}

