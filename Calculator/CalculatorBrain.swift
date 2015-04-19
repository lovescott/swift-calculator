//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Scott Love on 4/19/15.
//  Copyright (c) 2015 Scott Love. All rights reserved.
//

import Foundation

class CalculatorBrain{
    private enum Op{
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    init(){
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["÷"] = Op.BinaryOperation("÷"){ $1 / $0 }
        knownOps["÷"] = Op.UnaryOperation("√", sqrt)
    }
    
    func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        
        if !ops.isEmpty{
            let op = ops.removeLast()
        }
       
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        
        
    }
    
    func pushOperand(operand: Double){
        opStack.append(Op.Operand(operand))
    }
    
    func performOperation(symbol: String){
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        
    }
}