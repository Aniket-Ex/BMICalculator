//
//  ViewController.swift
//  BMICalculator
//
//  Created by Aniket Saxena on 2024-09-28.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // Outlets
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var measurementSegmentedControl: UISegmentedControl!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
    }
    
    // UI Setup
    func setupUI() {
        heightTextField.placeholder = "Enter height"
        weightTextField.placeholder = "Enter weight"
        measurementSegmentedControl.setTitle("SI (kg, cm)", forSegmentAt: 0)
        measurementSegmentedControl.setTitle("Imperial (lb, in)", forSegmentAt: 1)
        calculateButton.setTitle("Calculate BMI", for: .normal)
        resultLabel.text = "Your BMI:"
        categoryLabel.text = "Category:"
        descriptionLabel.text = ""
    }
    
    func setupDelegates() {
        heightTextField.delegate = self
        weightTextField.delegate = self
    }
    
    // Actions
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        calculateBMI()
    }
    
    // BMI Calculation
    func calculateBMI() {
        guard let heightText = heightTextField.text,
              let weightText = weightTextField.text,
              let height = Double(heightText),
              let weight = Double(weightText),
              height > 0, weight > 0 else {
            showAlert(message: "Please enter valid height and weight values.")
            return
        }
        
        let bmi: Double
        if measurementSegmentedControl.selectedSegmentIndex == 0 {
            // SI units
            bmi = weight / ((height / 100) * (height / 100))
        } else {
            // Imperial units
            bmi = (weight / (height * height)) * 703
        }
        
        displayResult(bmi: bmi)
    }
    
    func displayResult(bmi: Double) {
        let roundedBMI = round(bmi * 10) / 10
        resultLabel.text = "Your BMI: \(roundedBMI)"
        
        let (category, description) = getBMICategory(bmi: bmi)
        categoryLabel.text = "Category: \(category)"
        descriptionLabel.text = description
    }
    
    func getBMICategory(bmi: Double) -> (String, String) {
        switch bmi {
        case ..<18.5:
            return ("Underweight", "You are underweight. You need to gain weight.")
        case 18.5..<25:
            return ("Normal", "You are normal. You are within the normal range.")
        case 25..<30:
            return ("Overweight", "You are overweight. You need to lose weight.")
        default:
            return ("Obese", "You are obese. You need to lose weight.")
        }
    }
    
    // Helper Methods
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    //  Touch Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

