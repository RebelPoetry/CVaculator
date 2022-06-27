//
//  Parser.swift
//  CVaculator
//
//  Created by Kazakh on 27.06.2022.
//

import Foundation


// MARK: - Stack

struct Stack<Element> {

    // MARK: - Properties

    /// Stack elements holder
    var array: [Element] = []

    /// Checks if the array is empty
    var isEmpty: Bool {
        array.isEmpty
    }

    /// Elements count
    var count: Int {
        array.count
    }

    // MARK: - Useful

    /// Push a new element to the stack
    /// - Parameter element: a new element
    mutating func push(_ element: Element) {
        array.append(element)
    }

    /// Pop the top element from the stack
    /// - Returns: the top element from the stack
    @discardableResult mutating func pop() -> Element? {
        array.popLast()
    }

    /// Return a top element from the stack
    /// - Returns: a top element from the stack
    func peek() -> Element? {
        array.last
    }
}

// MARK: - BinaryOperation

enum BinaryOperation: String, CaseIterable, Equatable {

    case power = "^"
    case division = "/"
    case addition = "+"
    case subtruction = "-"
    case multiplication = "*"

    var priority: Int {
        switch self {
        case .addition, .subtruction:
            return 1
        case .division, .multiplication:
            return 2
        case .power:
            return 3
        }
    }
}

// MARK: - Brackets

enum Brackets: String, Equatable {
    case openingBracket = "("
    case closingBracket = ")"
}

// MARK: - Constants

enum Constant: String, CaseIterable, Equatable {
    
    case pi = "pi"
    case fi = "fi"
    case e = "e"
    
    var value: Double {
        switch self {
        case .pi:
            return Double.pi
        case .fi:
            return 1.6180339
        case .e:
            return 2.7182818
        }
    }
}

enum Function: String, CaseIterable, Equatable {
    case sin = "sin"
    case cos = "cos"
}


// MARK: - Token

enum Token: Equatable, CustomDebugStringConvertible {

    case number(Double)
    case constant(Constant)
    case binaryOperation(BinaryOperation)
    case bracket(Brackets)
    case function(Function)

    var debugDescription: String {
        switch self {
        case .number(let double):
            return String(double)
        case .binaryOperation(let binaryOperation):
            return binaryOperation.rawValue
        case .bracket(let brackets):
            return brackets.rawValue
        case .constant(let constant):
            return constant.rawValue
        case .function(let function):
            return function.rawValue
        }
    }
}

func parse(expression: String) -> [Token] {
    var str = expression
    var result: [Token] = []
    var number = ""
    while !str.isEmpty {
        let a = String(str.removeFirst())
        if Int(a) != nil || a == "." {
            number += a
        } else {
            if let number = Double(number) {
                result.append(.number(number))
            }
            number = ""
            if let operation = BinaryOperation(rawValue: a) {
                result.append(.binaryOperation(operation))
            } else if let brackett = Brackets(rawValue: a) {
                result.append(.bracket(brackett))
            }
            if Character(a).isLetter {
                var name: String = "\(a)"
                while let b = str.first, b.isLetter {
                    name += String(str.removeFirst())
                }
                if let constant = Constant(rawValue: name) {
                    result.append(.number(constant.value))
                } else if let function = Function(rawValue: name) {
                    result.append(.function(function))
                }
            }
        }
    }
    if let number = Double(number) {
        result.append(.number(number))
    }
    return result
}

func toRPN(expression: [Token]) -> [Token] {

    var result: [Token] = []

    var stack = Stack<Token>()
    
    
for element in expression {
        switch element {
        case .number:
            result.append(element)
        case .bracket(.openingBracket):
            stack.push(element)
        case .bracket(.closingBracket):
            while let top = stack.pop(), top != .bracket(.openingBracket) {
                result.append(top)
            }
        case .binaryOperation(let currentOperation):
            while let top = stack.peek() {
                if case let .binaryOperation(topOperation) = top, topOperation.priority >= currentOperation.priority {
                    result.append(top)
                    stack.pop()
                } else {
                    break
                }
            }
            stack.push(element)
        case .function:
            stack.push(element)
        default:
            print("Сюда теперь тоже не добираемся")
        }
    }
    while let top = stack.pop() {
        result.append(top)
    }
    return result
}


func calculateRPN(expression: [Token]) -> Double {

    var stack = Stack<Double>()

    for element in expression {
        switch element {
        case .number(let number):
            stack.push(number)
        case .binaryOperation:
            guard
                let num2 = stack.pop(),
                let num1 = stack.pop()
            else { continue }
            switch element {
            case .binaryOperation(.addition):
                stack.push(num1 + num2)
            case .binaryOperation(.subtruction):
                stack.push(num1 - num2)
            case .binaryOperation(.multiplication):
                stack.push(num1 * num2)
            case .binaryOperation(.division):
                stack.push(num1 / num2)
            case .binaryOperation(.power):
                stack.push(pow(num1, num2))
            default:
                print("Встречен некорректный символ")
            }
        case .function:
            if let num = stack.pop() {
                stack.push(sin(num))
            }
        default:
            print("Будем верить, что до этого не дойдет")
        }
    }
    return stack.pop() ?? 0

}
