//
//  ExampleTableViewController.swift
//  VPAutoComplete
//
//  Created by Vivek on 25/01/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit

class ExampleTableViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension ExampleTableViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension ExampleTableViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell")
        
        let textField = cell?.viewWithTag(101) as! UITextField
        textField.placeholder = "Cell \(indexPath.row)"
        textField.clearButtonMode = .whileEditing
        
        let dropDown = VPAutoComplete()
        dropDown.dataSource = ["One", "Two", "Three","Foure"]
        dropDown.onTextField = textField
        dropDown.isSearchBig = false
        dropDown.show(onTableView: tableView, atIndexPath: indexPath) { (str, index) in
            textField.text = str
        }
        
        
        return cell!
    }
    
}
