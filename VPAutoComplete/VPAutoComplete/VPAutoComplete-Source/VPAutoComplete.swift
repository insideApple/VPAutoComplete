//
//  VPAutoComplete.swift
//  VPAutoComplete
//
//  Created by Vivek on 25/01/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit

class VPAutoComplete: UIView {

    // Data source for show DropDown.
    public var dataSource : [String] = [String]()
    // Textfield for DropDown to show.
    public var onTextField : UITextField!
    // Completion Block For Selection in DropDown.
    public var completionHandler: CompletionHandler?
    // TableView For DropDown.
    var tableView : UITableView?
    public var dropDownHeight : CGFloat?
    // Parents View for Show DropDown.
    public var onView : UIView?
    // Filter data when writing on textfield.
    var filterDataSource : [String] = [String]()
    public var indexPath : IndexPath?
    // MultiLine for DropDown List (For Now dosent added properly and tested)
    private var isMultiLine  = false
    // Cell Height for DropDown
    public var cellHeight : CGFloat!
    // Make Searched Text Bold Or Not.
    public var isSearchBig = true
    
    var is_filter  = false
    var isOnTop = false
    
    // Arrow Indicator For DropDown.
    fileprivate lazy var arrowIndication: UIImageView = {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 20, height: 10), false, 0)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 10))
        path.addLine(to: CGPoint(x: 20, y: 10))
        path.addLine(to: CGPoint(x: 10, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 10))
        UIColor.black.setFill()
        path.fill()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let tintImg = img?.withRenderingMode(.alwaysTemplate)
        let imgv = UIImageView(image: tintImg)
        imgv.frame = CGRect(x: 0, y: -10, width: 15, height: 10)
        return imgv
    }()
    
    // Completion BLock.
    typealias CompletionHandler = (_ text: String , _ index : Int) -> Void
    
    // Remove observer
    deinit{
        self.deregisterFromKeyboardNotifications()
    }
    
    // Override Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        // SetUp View
        self.setUp()
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(onTextField: UITextField , dataSource : [String], onView: UIView, completionHandler: @escaping CompletionHandler){
        self.init()
        self.dataSource = dataSource
        self.onTextField = onTextField
        self.onView = onView
        self.tableView?.frame = CGRect(x: 0, y: 0, width: onTextField.frame.width, height: 150)
        self.frame = CGRect(x: onTextField.frame.minX, y: onTextField.frame.maxY, width: onTextField.frame.width, height: 150)
        
        self.addSubview(tableView!)
        onView.addSubview(self)
        self.tableView?.reloadData()
        
        self.onTextField.addTarget(self, action: #selector(didBeganText(textField:)), for: .editingDidBegin)
        self.onTextField.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        self.onTextField.addTarget(self, action: #selector(didEndText(textField:)), for: .editingDidEnd)
        
        self.isShowView(is_show: false)
        self.completionHandler = completionHandler
    }
    
    // MARK: - Show DropDown.(Add DropDown)
    /********** For Show DropDown for View And get selection in
     completion block.***********/
    public func show(completionHandler: @escaping CompletionHandler){
        
        self.tableView?.frame = CGRect(x: 0, y: 0, width: onTextField.frame.width, height: 150)
        self.frame = CGRect(x: onTextField.frame.minX, y: onTextField.frame.maxY, width: onTextField.frame.width, height: 150)
        
        onTextField.addTarget(self, action: #selector(didBeganText(textField:)), for: .editingDidBegin)
        onTextField.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        onTextField.addTarget(self, action: #selector(didEndText(textField:)), for: .editingDidEnd)
        
        self.addSubview(tableView!)
        self.onView?.addSubview(self)
        
        self.alpha = 0
        self.isHidden = true
        
        self.tableView?.alpha = 0
        self.tableView?.isHidden = true
        
        self.completionHandler = completionHandler
    }
    
    /********** For Show DropDown for TableView And get selection in
     completion block.***********/
    public func show(onTableView : UITableView, atIndexPath: IndexPath, completionHandler: @escaping CompletionHandler){
        
        self.tableView?.frame = CGRect(x: 0, y: 0, width: onTextField.frame.width, height: cellHeight * 3)
        
        let cellRectInTable: CGRect = onTableView.rectForRow(at: atIndexPath)
        let cellInSuperview: CGRect = onTableView.convert(cellRectInTable, to: onTableView)
        self.frame = CGRect(x: onTextField.frame.minX, y: cellInSuperview.minY + onTextField.frame.maxY, width: onTextField.frame.width, height: cellHeight * 3)
        
        self.onView = onTableView
        
        onTextField.addTarget(self, action: #selector(didBeganText(textField:)), for: .editingDidBegin)
        onTextField.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        onTextField.addTarget(self, action: #selector(didEndText(textField:)), for: .editingDidEnd)
        
        self.addSubview(tableView!)
        onTableView.addSubview(self)
        
        self.alpha = 0
        self.isHidden = true
        
        self.tableView?.alpha = 0
        self.tableView?.isHidden = true
        
        self.completionHandler = completionHandler
    }
    
    static func hide(){
        
    }
    
    // MARK: - SetUp View
    
    func setUp(){
        self.tableView = UITableView()
        self.tableView?.register(UINib(nibName: "VPAutoCompleteViewCell", bundle: nil), forCellReuseIdentifier: "VPAutoCompleteViewCell")
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()
        
        self.tableView?.layer.cornerRadius = 10
        self.tableView?.clipsToBounds = true
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.cellHeight = 50
        
        self.addShadow(customView: self)
        self.registerForKeyboardNotifications()
    }
    
    // Shadow for DropDown
    public func addShadow(customView: UIView){
        
        customView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        customView.layer.shadowOffset = CGSize(width: 0, height: 1)
        customView.layer.shadowOpacity = 1.0
        customView.layer.shadowRadius = 2.0
        customView.layer.masksToBounds = false
    }
    
    
    
    @objc func didChangeText(textField: UITextField) {
        if let textInField = onTextField.text {
            if textInField.count == 0{
                is_filter = false
                self.tableView?.reloadData()
            }else{
                is_filter = true
                let tempData = dataSource.filter { $0.localizedCaseInsensitiveContains(textInField) }
                filterDataSource = tempData
                self.isShowView(is_show: true)
                self.tableView?.reloadData()
            }
        }
    }
    
    @objc func didBeganText(textField: UITextField) {
        self.isShowView(is_show: true);
    }
    
    @objc func didEndText(textField: UITextField) {
        is_filter = false
        self.isShowView(is_show: false)
        self.tableView?.reloadData()
    }
    
    func isShowView(is_show : Bool){
        
        if !self.isHidden && is_show{
            return
        }
        
        if is_show {
            self.alpha = 0
            self.isHidden = false
            
            self.tableView?.alpha = 0
            self.tableView?.isHidden = false
            
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1
                self.tableView?.alpha = 1
            }
            
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView?.alpha = 0
                self.alpha = 0
            }) { (finished) in
                self.tableView?.isHidden = finished
                self.isHidden = finished
            }
        }
        
    }
    
    func changeHeightForCount(count: Int){
        if cellHeight == nil {
            return
        }
        var newFrame = self.frame
        newFrame.size.height = cellHeight * CGFloat(count)
        if isOnTop {
            newFrame.origin.y = self.frame.maxY - newFrame.size.height
        }
        self.frame = newFrame
        self.tableView?.frame = CGRect(x: 0, y: 0, width: newFrame.width, height: newFrame.height)
        print("self frame :\(self.frame)")
        self.setNeedsLayout()
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedStringKey.font: font])
        let boldFontAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font.withSize(font.pointSize + 3)]
        let range = (string as NSString).range(of: boldString, options: .caseInsensitive)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    
}


// MARK: - TableView Delegate.

extension VPAutoComplete : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if !isMultiLine {
            return cellHeight
        }
        
        if is_filter{
            let selectedStr = filterDataSource[indexPath.row]
            return selectedStr.height(constraintedWidth: self.onTextField.frame.width, font: self.onTextField.font!)
        }
        let selectedStr = dataSource[indexPath.row]
        return selectedStr.height(constraintedWidth: self.onTextField.frame.width, font: self.onTextField.font!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if is_filter{
            let selectedStr = filterDataSource[indexPath.row]
            let selectedIndex = dataSource.index(of: selectedStr)
            self.isShowView(is_show: false)
            self.completionHandler!(selectedStr, selectedIndex!)
            return
        }
        let selectedStr = dataSource[indexPath.row]
        let selectedIndex = indexPath.row
        self.isShowView(is_show: false)
        self.completionHandler!(selectedStr, selectedIndex)
    }
    
    
}

// MARK: - TableView DataSource.

extension VPAutoComplete : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if is_filter{
            self.changeHeightForCount(count: self.filterDataSource.count < 4 ? self.filterDataSource.count : 3)
            return self.filterDataSource.count
        }
        self.changeHeightForCount(count: self.dataSource.count < 4 ? self.dataSource.count : 3)
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VPAutoCompleteViewCell") as! VPAutoCompleteViewCell
        if is_filter {
            cell.lblTitle.text = filterDataSource[indexPath.row]
        }else{
            cell.lblTitle.text = dataSource[indexPath.row]
        }
        if isSearchBig {
            let formattedString = self.attributedText(withString: cell.lblTitle.text!, boldString: onTextField.text!, font: onTextField.font!)
            cell.lblTitle.attributedText = formattedString
        }
        return cell
    }
}

extension VPAutoComplete {
    
    func heightForLabel(text:String) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x:0, y:0, width: self.onTextField.frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.onTextField.font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height + 20
    }
    
    func addIndicator(color: UIColor, onRight: Bool, forView: UIView){
        
        self.arrowIndication.frame = CGRect(x: 10, y: onRight ? forView.frame.width - 20 : 20, width: 10  , height: 10)
        self.arrowIndication.tintColor = color
        forView.addSubview(self.arrowIndication)
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboarDidShown(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    @objc func keyboarDidShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        
        var aRect : CGRect = (self.onView?.frame)!
        aRect.size.height -= keyboardSize!.height
        if (self.onTextField) != nil {
            print("self frame : \(self.frame.origin)")
            if aRect.height < (self.frame.origin.y + self.frame .height) {
                if !isOnTop {
                    self.frame = CGRect(x: onTextField.frame.minX, y: self.frame.origin.y - self.frame.height - self.onTextField.frame.height, width: onTextField.frame.width, height: self.frame.height)
                    isOnTop = true
                    self.setNeedsDisplay()
                }
                
            }
        }
    }
    
}


// MARK: - Height for text.
extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height + 30
    }
}

