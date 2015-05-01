//
//  CalculatorBrain.swift
//  Calculator
//
//  Copyright (c) 2015 Scott Love. All rights reserved.
//

import Foundation

class CalculatorBrain{
    private enum Op: Printable{
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case SpecialOperation(String, () -> Double)
        
        var description: String {
            get{
                switch self{
                case .Operand(let operend):
                    return "\(operend)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .SpecialOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    init(){
        func learnOp(op: Op){
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−"){ $1 - $0 })
        learnOp(Op.BinaryOperation("÷"){ $1 / $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.SpecialOperation("π"){M_PI})
        learnOp(Op.UnaryOperation("sin"){ sin($0 * M_PI / 180) })
        learnOp(Op.UnaryOperation("cos"){ cos($0 * M_PI / 180) })
        println("\(knownOps)")
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return(operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return(operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .SpecialOperation(_, let operation):
                return (operation(), remainingOps);
            }
        }
       
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
       let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
        
    }
    func clearStack(){
        opStack.removeAll(keepCapacity: false)
    }
    func descriptionOfStack () -> String{
        return "\(opStack)"
    }
}