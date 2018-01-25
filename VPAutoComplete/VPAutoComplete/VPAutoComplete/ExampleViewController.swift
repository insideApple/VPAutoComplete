//
//  ExampleViewController.swift
//  VPAutoComplete
//
//  Created by Vivek on 25/01/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {

    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var midTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.topTextField.placeholder = "Top-TextField"
        self.midTextField.placeholder = "Mid-TextField"
        self.bottomTextField.placeholder = "Bottom-TextField"
        self.addDropDown()
    }
    
    func addDropDown(){
        
        // For Top textField
        let dropDownTop = VPAutoComplete()
        dropDownTop.dataSource = ["Top-One", "Top-Two", "Top-Three"]
        dropDownTop.onTextField = topTextField
        dropDownTop.onView = self.view
        dropDownTop.show { (str, index) in
            print("string : \(str) and Index : \(index)")
            self.topTextField.text = str
        }
        
        // For Mid textField
        let dropDownMid = VPAutoComplete()
        dropDownMid.dataSource = ["Mid-One", "Mid-Two", "Mid-Three"]
        dropDownMid.onTextField = midTextField
        dropDownMid.onView = self.view
        dropDownMid.show { (str, index) in
            print("string : \(str) and Index : \(index)")
            self.midTextField.text = str
        }
        
        // For Bottom textField
        let dropDownBottom = VPAutoComplete()
        dropDownBottom.dataSource = ["Bottom-One", "Bottom-Two", "Bottom-Three"]
        dropDownBottom.onTextField = bottomTextField
        dropDownBottom.onView = self.view
        dropDownBottom.show { (str, index) in
            print("string : \(str) and Index : \(index)")
            self.bottomTextField.text = str
        }
        
        /*******  Simple method to add DropDown
         _ = VPDropDown.init(onTextField: bottomTextField, dataSource: ["Bottom-one", "Bottom-two", "Bottom-three"], onView: self.view, completionHandler: { (str, index) in
         print("string : \(str) and Index : \(index)")
         self.bottomTextField.text = str
         })
         *****/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
