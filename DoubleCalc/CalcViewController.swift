//
//  ViewController.swift
//  CalculatorTutorial
//
//  Created by CallumHill on 4/12/20.
//

import UIKit

extension NSExpression {

    func toFloatingPoint() -> NSExpression {
        switch expressionType {
        case .constantValue:
            if let value = constantValue as? NSNumber {
                return NSExpression(forConstantValue: NSNumber(value: value.doubleValue))
            }
        case .function:
           let newArgs = arguments.map { $0.map { $0.toFloatingPoint() } }
           return NSExpression(forFunction: operand, selectorName: function, arguments: newArgs)
        case .conditional:
           return NSExpression(forConditional: predicate, trueExpression: self.true.toFloatingPoint(), falseExpression: self.false.toFloatingPoint())
        case .unionSet:
            return NSExpression(forUnionSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .intersectSet:
            return NSExpression(forIntersectSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .minusSet:
            return NSExpression(forMinusSet: left.toFloatingPoint(), with: right.toFloatingPoint())
        case .subquery:
            if let subQuery = collection as? NSExpression {
                return NSExpression(forSubquery: subQuery.toFloatingPoint(), usingIteratorVariable: variable, predicate: predicate)
            }
        case .aggregate:
            if let subExpressions = collection as? [NSExpression] {
                return NSExpression(forAggregate: subExpressions.map { $0.toFloatingPoint() })
            }
        case .anyKey:
            fatalError("anyKey not yet implemented")
        case .block:
            fatalError("block not yet implemented")
        case .evaluatedObject, .variable, .keyPath:
            break // Nothing to do here
        }
        return self
    }
}

class CornerRadiusButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}

protocol CalcViewControllerDelegate: AnyObject {
    func currentActive(_ vc: CalcViewController)
}

class CalcViewController: UIViewController {

    @IBOutlet weak var calculatorWorkings: UILabel!
    @IBOutlet weak var calculatorResults: UILabel!

    var workings: String = ""
    var currentResult: Double = 0.0
    var isActive: Bool = false
    weak var delegate: CalcViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        clearAll()
    }

    func clearAll() {
        workings = ""
        calculatorWorkings.text = ""
        calculatorResults.text = ""
    }

    @IBAction func equalsTap(_ sender: Any) {
        self.calculate()
    }

    func calculate() {
        if workings.isEmpty {
            return
        }
        if validInput() {
            let checkedWorkingsForPercent = workings.replacingOccurrences(of: "%", with: "*0.01").replacingOccurrences(of: "X", with: "*")
            let expression = NSExpression(format: checkedWorkingsForPercent)
            if let result = expression.toFloatingPoint().expressionValue(with: nil, context: nil) as? Double {
                let resultString = formatResult(result: result)
                self.currentResult = result
                calculatorResults.text = resultString
            }

        } else {
            let alert = UIAlertController(
                title: "Invalid Input",
                message: "Calculator unable to do math based on input",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func validInput() -> Bool {
        var count = 0
        var funcCharIndexes = [Int]()

        for char in workings {
            if specialCharacter(char: char) {
                funcCharIndexes.append(count)
            }
            count += 1
        }

        var previous: Int = -1

        for index in funcCharIndexes {
            if index == 0 {
                return false
            }

            if index == workings.count - 1 {
                return false
            }

            if previous != -1 {
                if index - previous == 1 {
                    return false
                }
            }
            previous = index
        }

        return true
    }

    func specialCharacter (char: Character) -> Bool {
        if char == "X" {
            return true
        }
        if char == "/" {
            return true
        }
        if char == "+" {
            return true
        }
        return false
    }

    func formatResult(result: Double) -> String {
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", result)
        } else {
            return String(format: "%f", result)
        }
    }

    @IBAction func allClearTap(_ sender: Any) {
        clearAll()
    }

    @IBAction func changeSign(_ sender: Any) {
        calculate()
        currentResult = 0.0 - currentResult
        calculatorResults.text =  formatResult(result: currentResult)
        workings =  formatResult(result: currentResult)
        calculatorWorkings.text = workings
    }

    func delete() {
        if !workings.isEmpty {
            workings.removeLast()
            calculatorWorkings.text = workings
        }
    }

    func addToWorkings(value: String) {
        self.delegate?.currentActive(self)
        workings += value
        calculatorWorkings.text = workings
    }

    func inputResult(_ result: Double) {
        self.currentResult = result
        calculatorResults.text =  formatResult(result: result)
        workings =  formatResult(result: currentResult)
        calculatorWorkings.text = workings
    }

    @IBAction func percentTap(_ sender: Any) {
        addToWorkings(value: "%")
    }

    @IBAction func divideTap(_ sender: Any) {
        addToWorkings(value: "/")
    }

    @IBAction func timesTap(_ sender: Any) {
        addToWorkings(value: "X")
    }

    @IBAction func minusTap(_ sender: Any) {
        addToWorkings(value: "-")
    }

    @IBAction func plusTap(_ sender: Any) {
        addToWorkings(value: "+")
    }

    @IBAction func decimalTap(_ sender: Any) {
        addToWorkings(value: ".")
    }

    @IBAction func zeroTap(_ sender: Any) {
        addToWorkings(value: "0")
    }

    @IBAction func oneTap(_ sender: Any) {
        addToWorkings(value: "1")
    }

    @IBAction func twoTap(_ sender: Any) {
        addToWorkings(value: "2")
    }

    @IBAction func threeTap(_ sender: Any) {
        addToWorkings(value: "3")
    }

    @IBAction func fourTap(_ sender: Any) {
        addToWorkings(value: "4")
    }

    @IBAction func fiveTap(_ sender: Any) {
        addToWorkings(value: "5")
    }

    @IBAction func sixTap(_ sender: Any) {
        addToWorkings(value: "6")
    }

    @IBAction func sevenTap(_ sender: Any) {
        addToWorkings(value: "7")
    }

    @IBAction func eightTap(_ sender: Any) {
        addToWorkings(value: "8")
    }

    @IBAction func nineTap(_ sender: Any) {
        addToWorkings(value: "9")
    }
}
