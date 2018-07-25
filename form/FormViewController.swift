//
//  FormViewController.swift
//  form
//
//  Created by Ali on 7/23/18.
//  Copyright © 2018 Ali. All rights reserved.
//

import UIKit

class FormViewController: UIViewController, UITextFieldDelegate {
    
    var pageTitle = 0       //if 1 want to add form, if 2 want to edit a form
    var keyValue = 0        //the key value for plist dictionary
    var plistPath = ""
    
    var gender = "Male"
    var lastChild = "1"
    var tall = "1.7"
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var familyTextField: UITextField!
    
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    
    @IBAction func genderChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            // Male
            gender = "Male"
        }else{
            // Female
            gender = "Female"
        }
    }
    
    @IBOutlet weak var switchControl: UISwitch!
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.isOn{
            lastChild = "0"
        }else{
            lastChild = "1"
        }
    }
    
    @IBOutlet weak var sliderLabel: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let currentValue = sender.value
        
        tall = String(currentValue)
        sliderLabel.text = String(currentValue)
    }
    
    @IBOutlet weak var cancleButton: UIButton!
    
    @IBAction func saveButtonTouched(_ sender: UIButton) {
        if let name = nameTextField.text, name != "", let family = familyTextField.text, family != ""{
            if pageTitle == 1{
                let array = [name, family,gender,lastChild,tall]
                let formDictionary = NSMutableDictionary.init(contentsOfFile: plistPath)
                formDictionary?.setValue(array, forKey: "\(keyValue)")
                formDictionary?.write(toFile: plistPath, atomically: true)
            }else if pageTitle == 2{
                let array = [name, family,gender,lastChild,tall]
                let formDictionary = NSMutableDictionary.init(contentsOfFile: plistPath)
                formDictionary?.setValue(array, forKey: "\(keyValue)")
                formDictionary?.write(toFile: plistPath, atomically: true)
            }
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tableViewController") as UIViewController
            self.present(viewController, animated: false, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self
        self.familyTextField.delegate = self
        // Do any additional setup after loading the view.
        
        
        if pageTitle == 2 {
            let formDictionary = NSMutableDictionary.init(contentsOfFile: plistPath)
            let ArrayFromDic: NSArray = NSArray.init(object: formDictionary!.object(forKey: "\(keyValue)") as Any)
            let ValueArray = ArrayFromDic.object(at: 0) as? NSArray
            nameTextField.text = ValueArray?[0] as? String
            familyTextField.text = ValueArray?[1] as? String
            if (ValueArray?[2] as? String) == "Male"{
                genderSegmentControl.selectedSegmentIndex = 0
            }else{
                genderSegmentControl.selectedSegmentIndex = 1
            }
            
            if (ValueArray?[3] as? String) == "1"{
                switchControl.isOn = false
            }else{
                switchControl.isOn = true
            }
            slider.value = Float(ValueArray?[4] as! String)!
            sliderLabel.text = ValueArray?[4] as? String
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
