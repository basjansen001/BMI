//
//  ViewController.swift
//  BMI
//
//  Created by Bas Jansen on 16-05-15.
//  Copyright (c) 2015 Bas Jansen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
	
    let listOfWeightsInKg = Array(80...240).map({ Double($0) * 0.5 })
    let listOfHeightsInMeters = Array(140...220).map({ Double($0) * 0.01 })
  
    // 
    // MARK: Stored properties
    //
	
    var weight: Double?
    var height: Double?
	
    //
    // MARK: Computed properties
    //
	
    var bmi: Double? { 
        get {
	    if weight != nil && height != nil {
                return weight! / (height! * height!)
            } else {
                return nil
            }
        }
     }
	
     //
     // MARK: IBOutlets
     //
	
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var bmiLabel: UILabel!
  
    @IBOutlet weak var heightPickerView: UIPickerView!
    @IBOutlet weak var weightPickerView: UIPickerView!
	
     //
     // MARK: ViewControllers generated methods
     //
	
    override func viewDidLoad() {
	super.viewDidLoad()
        // Zet de datasources en delegate's voor de pickerview's
        self.heightPickerView.delegate = self
        self.heightPickerView.dataSource = self
        self.weightPickerView.delegate = self
        self.weightPickerView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    //
    // MARK: TextField delegate and data source methods
    //
  
    func textFieldDidBeginEditing(textField: UITextField) {
        println("We zijn begonnen met het editen")
    }
  
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
	updateUI()
	return true
    }
  
    func textFieldDidEndEditing(textField: UITextField) {
	// Dit is een closure. Hij convert de string naar een number anders return die nil als dat niet lukt.
	let conv = {
		NSNumberFormatter().numberFromString($0)?.doubleValue
	}
    
	switch textField {
	case self.weightTextField:
		self.weight = conv(textField.text)
	case self.heightTextField:
		self.height = conv(textField.text)
	default:
		println("There went something horribly wrong")
	}

      updateUI()
     }
	
     //
     // MARK: PickerView delegate and datasources methods.
     //
  
     // Returns the number of 'columns' to display.
     func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
	return 1
     }
  
     // returns the # of rows in each component..
     func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         switch pickerView {
	 case self.heightPickerView:
		return listOfHeightsInMeters.count
	 case self.weightPickerView:
		return listOfWeightsInKg.count
	 default:
		return 0
	 }
     }
  
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
	switch pickerView {
	case self.heightPickerView:
		return String(format: "%4.2f", listOfHeightsInMeters[row])
	case self.weightPickerView:
		return String(format: "%4.2f", listOfWeightsInKg[row])
	default:
		return ""
	}
    }
  
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
	switch pickerView {
	case self.heightPickerView:
		let height: Double = self.listOfHeightsInMeters[row]
		self.height = height
	case self.weightPickerView:
		let weight: Double = self.listOfWeightsInKg[row]
		self.weight = weight
	default:
		println("Error")
	}
    
	updateUI()
     }
	
     //
     // MARK: Method for updating the UI
     //
	
     func updateUI() {
         if let b = self.bmi {
	     self.bmiLabel.text = String(format: "%4.1f", b)
	 }
      }
}

