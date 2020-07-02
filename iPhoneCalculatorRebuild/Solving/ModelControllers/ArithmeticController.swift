//
//  ArithmeticController.swift
//  iPhoneCalculatorRebuild
//
//  Created by Alfredo Colon on 6/17/20.
//  Copyright © 2020 Alfredo Colon. All rights reserved.
//

import Foundation

class ArithmeticController: AddCalculatorEntry, AddParentheticalExpression, ClearAllEntries, ClearLastTerm, CloseParentheticalExpression, EvaluateArithmeticExpression {

    //MARK: - Properties

    var outputLabelDelegate: OutputLabel!
    var parentheticalExpressionIndex: Int
    var precedenceOperations: [Int: PrecedenceOperationController]

    //MARK: - Init

    init(outputLabelDelegate: OutputLabel, startingTerm: Term?) {
        self.outputLabelDelegate = outputLabelDelegate
        
        self.precedenceOperations = [ : ]

        self.parentheticalExpressionIndex = 0
        
        self.precedenceOperations[0] = PrecedenceOperationController(startingTerm: startingTerm)
        
        if startingTerm != nil {
            self.outputLabelDelegate.outputTerm = startingTerm
        }
    }

    //MARK: - Add Calculator Entry
    
    func addCalculatorEntry(constantType: CalculatorCell.Constant) {
        let termPointer: UnsafeMutablePointer<Term>! = self.lastPrecedenceTermPointer

        switch termPointer.pointee {
        case .nestedArithmeticController(let arithmeticController):
            return arithmeticController.addCalculatorEntry(constantType: constantType)
        default:
            termPointer.pointee.updateTerm(to: constantType)
        }
        
        self.outputLabelDelegate.outputTerm = termPointer.pointee
    }

    func addCalculatorEntry(decimal: CalculatorCell.Decimal) {
        let termPointer: UnsafeMutablePointer<Term>! = self.lastPrecedenceTermPointer

        switch termPointer.pointee {
        case .constantOperand:
            break
        case .mutableOperand(let mutableOperand):
            mutableOperand.addDecimal()
        case .nestedArithmeticController(let arithmeticController):
            return arithmeticController.addCalculatorEntry(decimal: decimal)
        default:
            termPointer.pointee.updateTerm(to: decimal)
        }
        
        self.outputLabelDelegate.outputTerm = termPointer.pointee
    }
    
    func addCalculatorEntry(digit: CalculatorCell.Digit) {
        let termPointer: UnsafeMutablePointer<Term>! = self.lastPrecedenceTermPointer

        switch termPointer.pointee {
        case .constantOperand:
            break
        case .mutableOperand(let mutableOperand):
            mutableOperand.addDigit(digit: digit)
        case .nestedArithmeticController(let arithmeticController):
            return arithmeticController.addCalculatorEntry(digit: digit)
        default:
            termPointer.pointee.updateTerm(startingDigit: digit)
        }
        self.outputLabelDelegate.outputTerm = termPointer.pointee
    }

    func addCalculatorEntry(double: Double?) {
        let termPointer: UnsafeMutablePointer<Term>! = self.lastPrecedenceTermPointer

        switch termPointer.pointee {
        case .nestedArithmeticController(let arithmeticController):
            return arithmeticController.addCalculatorEntry(double: double)
        default:
            termPointer.pointee.updateTerm(to: double)
        }
        
        self.outputLabelDelegate.outputTerm = termPointer.pointee
    }

    func addCalculatorEntry(functionWithOneInput: CalculatorCell) {
        let termPointer: UnsafeMutablePointer<Term>! = self.lastPrecedenceOrOutputTermPointer

        switch termPointer.pointee {
        case .nestedArithmeticController(let arithmeticController):
            return arithmeticController.addCalculatorEntry(functionWithOneInput: functionWithOneInput)
        default:
            let input1 = termPointer.pointee
            termPointer.pointee.updateTerm(functionWithOneInput: functionWithOneInput, input1: input1)
        }
        
        self.outputLabelDelegate.outputTerm = termPointer.pointee
    }
        
    func addCalculatorEntry(functionWithTwoInputs: CalculatorCell) {
        self.addLastTermToEmptyParentheticalStackOrRemoveLastOperatorIfNeeded(functionWithTwoInputs: true)
        let termPointer: UnsafeMutablePointer<Term>! = self.lastPrecedenceTermPointer
        let input1 = termPointer.pointee
        
        switch termPointer.pointee {
        case .nestedArithmeticController(let arithmeticController):
            return arithmeticController.addCalculatorEntry(functionWithTwoInputs: functionWithTwoInputs)
        default:
            termPointer.pointee.updateTerm(functionWithTwoInputs: functionWithTwoInputs, input1: input1)
        }
        
        self.outputLabelDelegate.outputTerm.updateTerm(to: input1)
    }

    func addCalculatorEntry(operatorType: CalculatorCell.Operator) {
        self.addLastTermToEmptyParentheticalStackOrRemoveLastOperatorIfNeeded(functionWithTwoInputs: false)
        let termPointer: UnsafeMutablePointer<Term>! = self.lastPrecedenceTermPointer
        
        switch termPointer?.pointee {
        case .nestedArithmeticController(let arithmeticController):
            return arithmeticController.addCalculatorEntry(operatorType: operatorType)
        default:
            self.precedenceOperations[self.parentheticalExpressionIndex]?.updatePrecedenceOperations(for: operatorType)
        }
        
        let currentPrecedenceOperation = self.precedenceOperations[self.parentheticalExpressionIndex]?.currentPrecedenceOperation
        let double = currentPrecedenceOperation?.leftTerm.doubleValue
    
        self.outputLabelDelegate.outputTerm.updateTerm(to: double)
    }

    func addCalculatorEntry(percentageFunction: CalculatorCell.PercentageFunction) {
        let termPointer: UnsafeMutablePointer<Term>! = self.lastPrecedenceOrOutputTermPointer

        switch termPointer.pointee {
        case .percentageFunction(let function):
            function.update()
        case .nestedArithmeticController(let arithmeticController):
            return arithmeticController.addCalculatorEntry(percentageFunction: percentageFunction)
        default:

            let precedenceOperationsController: PrecedenceOperationController! = self.precedenceOperations[self.parentheticalExpressionIndex]
            let precedenceOperation: PrecedenceOperation = precedenceOperationsController.currentPrecedenceOperation
            /*
             Setting up the percentageFunction is tricky
                a. It will either be  1% of term's doubleValue
                    - if the last operator's precedence was 1 (multiply/divide)
                    - or the outputTerm is being updated
                b. It will be the currentTerm's doubleValue % (doubleValue / 100) of the lastTerm's doubleValue
                    - if the last operator's precedence was 0 (add/subtract)
             */
            let percentageFunction: PercentageFunction = {
                //OutputTerm and *,/ check
                if precedenceOperation.lastEntryWasOperator || precedenceOperationsController.high.operationStarted || (self.parentheticalExpressionIndex == 0 && precedenceOperationsController.low.leftTermIsSet){
                    let of: Double? = termPointer.pointee.doubleValue
                    return PercentageFunction(of: of)
                }
                //+, - check
                else if precedenceOperationsController.low.rightTermIsSet {
                    let of: Double? = precedenceOperationsController.low.leftTerm.doubleValue
                    let percent: Double? = termPointer.pointee.doubleValue
                    
                    return PercentageFunction(of: of, percent: percent)
                }
                //Tricky check because if a leftTerm was added in a new parentheticalExpression stack, then a loop has to be used to find the last operator
                var of: Double?
                //Loop backwards to find the last operator
                //if any of the precedence operations has a 0 precedence, return the leftTerm's double value
                for index in stride(from: self.parentheticalExpressionIndex - 1, through: 0, by: -1) {
                    let pastPrecedenceOperationsController: PrecedenceOperationController! = self.precedenceOperations[index]
                    
                    guard pastPrecedenceOperationsController.high.operator_ == nil else { break }
                    
                    if pastPrecedenceOperationsController.low.operator_ != nil {
                        of = pastPrecedenceOperationsController.low.leftTerm.doubleValue
                    }
                }
                
                if let of = of {
                    let percent: Double? = termPointer.pointee.doubleValue
                    return PercentageFunction(of: of, percent: percent)
                }
                else {
                    let of: Double? = termPointer.pointee.doubleValue
                    return PercentageFunction(of: of)
                }
            }()
        
            //Update termPointer
            termPointer.pointee.updateTerm(to: percentageFunction)
         
            //outputTerm
            self.outputLabelDelegate.outputTerm = termPointer.pointee
        }
    }

    func addCalculatorEntry(trigonometricFunction: CalculatorCell, siUnit: CalculatorCell.SIUnit) {
        let termPointer: UnsafeMutablePointer<Term>! = self.lastPrecedenceOrOutputTermPointer

        switch termPointer.pointee {
        case .nestedArithmeticController(let arithmeticController):
            return arithmeticController.addCalculatorEntry(trigonometricFunction: trigonometricFunction, siUnit: siUnit)
        default:
            let input1 = termPointer.pointee
            termPointer.pointee.updateTerm(trigonometricFunction: trigonometricFunction, input1: input1, siUnit: siUnit)
        }
        self.outputLabelDelegate.outputTerm = termPointer.pointee
    }
    
    //MARK: - Opening Parenthesis
    /*
        Three things can happen here:
            1. A new parenthetical expression will be added to the this arithmeticController
            2. An input2 will be converted to a nestedArithmeticController
            3. The addParentheticalExpression will be added to the nestedInputController
     */
    func addParentheticalExpression() {
        let precedenceOperationsController: PrecedenceOperationController! = self.precedenceOperations[self.parentheticalExpressionIndex]
        let precedenceOperation: PrecedenceOperation = precedenceOperationsController.currentPrecedenceOperation
        
        //1.Check for a nestedArithmeticController
        let termPointer: UnsafeMutablePointer<Term> = precedenceOperation.pointerToTermToUpdate
        
        switch termPointer.pointee {
        
        case .functionWithTwoInputs(let function):
            switch function.input2 {
            case .ThisTermNeedsToBeSet:
                //Start an empty nestedArithmeticController
                let arithmeticController = ArithmeticController(outputLabelDelegate: self.outputLabelDelegate, startingTerm: nil)
                
                return function.input2.updateTerm(to: arithmeticController)
            case .nestedArithmeticController(let arithmeticController):
                return arithmeticController.addParentheticalExpression()
            default:
                //Start a nestedArithmeticController with the current input2Term acting as the starting term
                let startingTerm: Term! = function.input2
                let arithmeticController = ArithmeticController(outputLabelDelegate: self.outputLabelDelegate, startingTerm: startingTerm)

                return function.input2 = Term(nestedArithmeticController: arithmeticController)
            }
        default:
            break
        }
        
        //2.Add parentheticalExpression to the current stack
        let startingTerm: Term? = precedenceOperationsController.getStartingTerm()
        self.parentheticalExpressionIndex += 1
        self.precedenceOperations[self.parentheticalExpressionIndex] = PrecedenceOperationController(startingTerm: startingTerm)
    }
    
    //MARK: - ClearAllEntries

    func clearAllEntries(startingTerm: Term = Term(startingDigit: CalculatorCell.Digit.Zero)) {
        self.precedenceOperations.removeAll()
        self.precedenceOperations = [ : ]
        self.parentheticalExpressionIndex = 0
        self.precedenceOperations[0] = PrecedenceOperationController(startingTerm: startingTerm)
        self.outputLabelDelegate.outputTerm = startingTerm
    }

    //MARK: - ClearLastTerm

    func clearLastTerm() {
        let termPointer: UnsafeMutablePointer<Term>! = self.lastPrecedenceOrOutputTermPointer

        switch termPointer.pointee {
        case .nestedArithmeticController(let arithmeticController):
            return arithmeticController.clearLastTerm()
        default:
            termPointer.pointee.updateTerm(startingDigit: CalculatorCell.Digit.Zero)
        }
        
        self.outputLabelDelegate.outputTerm = termPointer.pointee
    }
    
    //MARK: - CloseParentheticalExpression

    func closeParentheticalExpression() {
        //1. if current index if zero check if nestedArithmeticController should be closed
        guard self.parentheticalExpressionIndex > 0 else { return self.closeNestedArithmeticControllerIfNeeded() }
        
        //2.Add outputTerm if needed
        self.addOutputTermIfNeeded()
        
        //3.Evaluate last parenthetical stack
        let precedenceOperationController: PrecedenceOperationController! = self.precedenceOperations[self.parentheticalExpressionIndex]
        
        let solver = ShuntingYardsSolver()
        let precedenceOperations: [Int : PrecedenceOperationController] = [0 : precedenceOperationController]
        
        //Send the last precedenceOperationsController to be evaluated
        solver.updateProperties(with: precedenceOperations, index: 0)
        
        //Setup a term with the evaluated total
        let evaluatedTotalDouble: Double? = solver.solve()
        let term: Term! = Term.init(double: evaluatedTotalDouble)
        
        //4.Reduce the index
        self.precedenceOperations.removeValue(forKey: self.parentheticalExpressionIndex)
        self.parentheticalExpressionIndex -= 1
        
        //5.Add the evaluated total to the current precedence operation
        self.precedenceOperations[self.parentheticalExpressionIndex]?.addTerm(term: term)
        
        //6.Output the total of the evaluated parenthetical expression
        self.outputLabelDelegate.outputTerm = term
    }
    
    func closeNestedArithmeticControllerIfNeeded() {
        let precedenceOperationsController: PrecedenceOperationController! = self.precedenceOperations[self.parentheticalExpressionIndex]
        let precedenceOperation: PrecedenceOperation = precedenceOperationsController.currentPrecedenceOperation
        guard precedenceOperation.operationStarted == true else { return }
        guard precedenceOperation.lastEntryWasOperator == false else { return }

        let term: Term = precedenceOperation.rightTermIsSet ? precedenceOperation.rightTerm : precedenceOperation.leftTerm
        
        switch term {
        case .functionWithTwoInputs(let function):
            switch function.input2 {
            case .nestedArithmeticController(let arithmeticController):
                if arithmeticController.precedenceOperationsHaveStarted == false {
                    function.input2 = Term.ThisTermNeedsToBeSet
                }
                else if arithmeticController.parentheticalExpressionIndex == 0 {
                    //Add output term if needed
                    arithmeticController.addOutputTermIfNeeded()
                    
                    //Send the lst precedenceOperationsController to be evaluated
                    let precedenceOperations: [Int : PrecedenceOperationController] = [0 : arithmeticController.precedenceOperations[self.parentheticalExpressionIndex]!]
                    let solver = ShuntingYardsSolver()
                    
                    solver.updateProperties(with: precedenceOperations, index: 0)
                    
                    //add the evaluatedTotal as input2
                    let evaluatedTotalDouble: Double? = solver.solve()
                    function.input2.updateTerm(to: evaluatedTotalDouble)
                    
                    //Output
                    self.outputLabelDelegate.outputTerm.updateTerm(to: evaluatedTotalDouble)
                }
                else {
                    return arithmeticController.closeParentheticalExpression()
                }
            default:
                break
            }
        default:
            break
        }
    }


    //MARK: - EvaluateArithmeticExpression
    
    func evaluateArithmeticExpression() {
        let precedenceOperationsController: PrecedenceOperationController! = self.precedenceOperations[self.parentheticalExpressionIndex]
        let precedenceOperation: PrecedenceOperation = precedenceOperationsController.currentPrecedenceOperation
        let termPointer: UnsafeMutablePointer<Term>! = precedenceOperation.pointerToTermToUpdate

        //1.If last term is a final term, update it
        switch termPointer.pointee {
        case .finalExpression(var term):
            return self.updateFinalTerm(finalTermPointer: UnsafeMutablePointer<Term>(&term))
        default:
            break
        }
        
        //2.Add value if needed
        self.addOutputTermIfNeeded()
        
        //3.Setup Solver
        let solver: ShuntingYardsSolver = ShuntingYardsSolver()
        solver.updateProperties(with: self.precedenceOperations, index: self.parentheticalExpressionIndex)
        
        //4.Solve/Setup final term
        var finalTerm: Term!
        
        if solver.terms.count == 1 {
            solver.reduceSingleTermInputsIfNeeded()
            finalTerm = Term.finalExpression(solver.terms[0])
        }
        else {
            //operation
            let leftTerm: Double? = solver.terms.removeFirst().doubleValue
            let operator_: CalculatorCell.Operator = solver.operators.removeFirst()
            /*
                The right term will come fromn
                    - the remaining term
                    - or if there is more than one parenthetical expression,
                        - the evaluatedReseult of those expressions will act as the rightTerm in the final operation
                e.g. 1 + (2 + (3 + 4 => 1 + 9
            */
            let rightTerm: Double? = solver.solve()
            let operation: Operation = Operation(leftTermDouble: leftTerm, operatorType: operator_, rightTermDouble: rightTerm)
            
            finalTerm = Term.finalExpression(Term.operation(operation))
        }
        
        //5.Reset the currentStack, setting the starting term as the final term
        self.clearAllEntries(startingTerm: finalTerm)
    }
    
    func updateFinalTerm(finalTermPointer: UnsafeMutablePointer<Term>) {
        switch finalTermPointer.pointee {
        case .functionWithOneInput(let function):
            let double: Double? = function.doubleValue()
            let term: Term = Term(double: double)
            
            function.input1 = term
        case .functionWithTwoInputs(let function):
            let double: Double? = function.doubleValue()
            let term: Term = Term(double: double)
            
            function.input1 = term
        case .operation(let operation):
            let double: Double? = operation.doubleValue()
            
            operation.leftTermDouble = double
        default:
            break
        }
        
        self.outputLabelDelegate.outputTerm = finalTermPointer.pointee
    }
    
    //MARK: - SecondSetOfFunctionsToggled

    func removeToggledFunctionIfNeeded() {
        let precedenceOperationsController: PrecedenceOperationController! = self.precedenceOperations[self.parentheticalExpressionIndex]
        let precedenceOperation: PrecedenceOperation = precedenceOperationsController.currentPrecedenceOperation
        let termPointer: UnsafeMutablePointer<Term> = precedenceOperation.pointerToTermToUpdate

        switch termPointer.pointee {
        case .functionWithTwoInputs(let function):
            //Instead of checking if this is logy, I'll just check if it has a toggled value
            //logy is the only function with two inputs with a toggled value
            if function.functionName.toggledValue != nil {
                termPointer.pointee.updateTerm(to: function.input1)
                self.outputLabelDelegate.outputTerm = termPointer.pointee
            }
        case .nestedArithmeticController(let arithmeticController):
            return arithmeticController.removeToggledFunctionIfNeeded()
        default:
            break
        }
    }

    //MARK: - ToggleNumberSign

    func toggleNumberSign() {
        let termPointer: UnsafeMutablePointer<Term>! = self.lastPrecedenceTermPointer

        switch termPointer.pointee {
        case .constantOperand(let constant):
            constant.toggleSign.toggle()
        case .fixedOperand(let fixedOperand):
            fixedOperand.toggleSign.toggle()
        case .functionWithOneInput(let function):
            function.toggleSign.toggle()
        case .mutableOperand(let mutableOperand):
            mutableOperand.toggleSign.toggle()
        case .nestedArithmeticController(let arithmeticController):
            return arithmeticController.toggleNumberSign()
        case .operation(let operation):
            operation.toggleSign.toggle()
        case .percentageFunction(let function):
            function.toggleSign.toggle()
        case .ThisTermNeedsToBeSet:
            termPointer.pointee.updateTerm(to: nil, startingDigit: CalculatorCell.Digit.Zero, toggleSign: true)
        case .trigonometricFunction(let function):
            function.toggleSign.toggle()
        default:
            break
        }
        self.outputLabelDelegate.outputTerm = termPointer.pointee
    }
    
    
    
    //MARK: - Methods
    
    var precedenceOperationsHaveStarted: Bool {
        get {
            for index in 0...parentheticalExpressionIndex {
                if self.precedenceOperations[index]?.precedenceOperationStarted == true {
                    return true
                }
            }
            return false
        }
    }

    func moveLastPrecedenceOperationToCurrentPrecedenceOperation() {
        let currentPrecedenceOperations: PrecedenceOperationController! = self.precedenceOperations[self.parentheticalExpressionIndex]
        let lastPrecedenceOperation: PrecedenceOperation! = self.precedenceOperations[self.parentheticalExpressionIndex - 1]?.removeCurrentPrecedenceOperation()

        lastPrecedenceOperation.operator_ = nil

        currentPrecedenceOperations.replaceCurrentPrecedenceOperation(with: lastPrecedenceOperation)
    }
    
    func addLastTermToEmptyParentheticalStackOrRemoveLastOperatorIfNeeded(functionWithTwoInputs: Bool) {
        let currentPrecedenceOperations: PrecedenceOperationController! = self.precedenceOperations[self.parentheticalExpressionIndex]
        let currentPrecedenceOperation: PrecedenceOperation! = currentPrecedenceOperations.currentPrecedenceOperation
        
        if self.parentheticalExpressionIndex > 0 && currentPrecedenceOperation.operationStarted == false {
            self.moveLastPrecedenceOperationToCurrentPrecedenceOperation()
        }
        
        if functionWithTwoInputs && currentPrecedenceOperation.operator_ !=  nil {
            currentPrecedenceOperation.operator_ = nil
        }
        
        //
        //replace function with two inputs to input1
        var termPointer: UnsafeMutablePointer<Term>! = currentPrecedenceOperation.pointerToTermToUpdate
        switch termPointer.pointee {
        case .functionWithTwoInputs(let function):
            switch function.input2 {
            case .nestedArithmeticController(let arithmeticController):
                if arithmeticController.precedenceOperationsHaveStarted == false {
                    fallthrough
                }
                else {
                    termPointer = UnsafeMutablePointer<Term>(&function.input2)
                }
            case .ThisTermNeedsToBeSet:
                termPointer.pointee.updateTerm(to: function.input1)
            default:
                break
            }
        default:
            break
        }
    }
    
    var lastPrecedenceTermPointer: UnsafeMutablePointer<Term> {
        get {
            let currentPrecedenceOperation: PrecedenceOperation! = self.precedenceOperations[self.parentheticalExpressionIndex]!.currentPrecedenceOperation
            
            var termPointer: UnsafeMutablePointer<Term>! = currentPrecedenceOperation?.pointerToTermToUpdate
            
            switch termPointer.pointee {
            case .functionWithTwoInputs(let function):
                termPointer = UnsafeMutablePointer<Term>(&function.input2)
            default:
                break
            }
            
            return termPointer
        }
    }

    var lastPrecedenceOrOutputTermPointer: UnsafeMutablePointer<Term> {
        get {
            let currentPrecedenceOperations: PrecedenceOperationController! = self.precedenceOperations[self.parentheticalExpressionIndex]
            let currentPrecedenceOperation: PrecedenceOperation! = currentPrecedenceOperations.currentPrecedenceOperation

            //Return a pointer to the output term if the last entry was an operator or the an operation hasn't been started
            if currentPrecedenceOperation.lastEntryWasOperator || currentPrecedenceOperation.operationStarted == false {
                let termPointer: UnsafeMutablePointer<Term>! = UnsafeMutablePointer<Term> (&outputLabelDelegate.outputTerm)
                return termPointer
            }

            //Get a pointer to the term that should be updated
            var termPointer: UnsafeMutablePointer<Term>! = currentPrecedenceOperation.pointerToTermToUpdate

            //If there is a nested te
            switch termPointer.pointee {
            case .functionWithTwoInputs(let function):
                switch function.input2 {
                case .ThisTermNeedsToBeSet:
                    termPointer.pointee.updateTerm(to: function.input1)
                case .nestedArithmeticController(let arithmeticController):
                    termPointer = arithmeticController.precedenceOperationsHaveStarted ?
                    UnsafeMutablePointer<Term> (&self.outputLabelDelegate.outputTerm)
                    :
                    UnsafeMutablePointer<Term>(&function.input2)
                    
                default:
                    termPointer = UnsafeMutablePointer<Term>(&function.input2)
                }
            default:
                break
            }

            return termPointer
        }
    }
    
    func addOutputTermIfNeeded() {
        let currentPrecedenceOperations: PrecedenceOperationController! = self.precedenceOperations[self.parentheticalExpressionIndex]
        let currentPrecedenceOperation: PrecedenceOperation! = currentPrecedenceOperations.currentPrecedenceOperation
        
        /*
         OutputTerms are added after an = or ) calculatorCell is pressed.
         They are added for:
            - Empty parenthetical stack
            - when the last entry was an operator
            - or as a input2 if no term has been set
         */
        //- Empty parenthetical stack
        if self.precedenceOperationsHaveStarted == false {
            return self.addCalculatorEntry(double: self.outputLabelDelegate.outputTerm.doubleValue)
        }
        //- when the last entry was an operator
        else if currentPrecedenceOperation.lastEntryWasOperator || currentPrecedenceOperation.operationStarted == false {
            return self.addCalculatorEntry(double: self.outputLabelDelegate.outputTerm.doubleValue)
        }
        
        let termPointer: UnsafeMutablePointer<Term> = currentPrecedenceOperation.pointerToTermToUpdate
        
        switch termPointer.pointee {
        //- or as a input2 if no term has been set
        case .ThisTermNeedsToBeSet:
            termPointer.pointee.updateTerm(to: self.outputLabelDelegate.outputTerm.doubleValue)
        case .functionWithTwoInputs(let function):
            switch function.input2 {
            case .ThisTermNeedsToBeSet:
                function.input2.updateTerm(to: self.outputLabelDelegate.outputTerm.doubleValue)
            case .nestedArithmeticController(let arithmeticController):
                arithmeticController.addOutputTermIfNeeded()
            default:
                break
            }
        default:
            break
        }
    }
}
