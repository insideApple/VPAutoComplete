# VPAutoComplete
VPAutoComplete is Autocomplete for textField
It is written in swift 4 and support `UITableView`

## Demo

Project containing Example for implemented it in `ViewController` and `UITableView`.
I used `IQKeyBoardManager` for working with scroll as well

![](https://i.imgur.com/1eEtDsP.png)
![](https://i.imgur.com/rKZ6o39.png)

### Requirment

Xcode 9 and iOS 11.0
Code is written in swift 4



### Example

A step by step series of examples that tell you have to get a development env running

For `UIViewController`

```
        let dropDown = VPAutoComplete()
        dropDown.dataSource = ["Data 1", "Data 2", "Data 3"]
        dropDown.onTextField = textField // Your TextField
        dropDown.onView = self.view // ViewController's View
        dropDown.show { (str, index) in
            print("string : \(str) and Index : \(index)")
            self.textField.text = str
        }
```

Quick Run

```
         _ = VPDropDown.init(onTextField: textField, dataSource: ["Data 1", "Data 2", "Data 3"], onView: self.view, completionHandler: { (str, index) in
         print("string : \(str) and Index : \(index)")
         self.textField.text = str
         })
```
For `UITableView` in `cellForRowAt`

```
        let dropDown = VPAutoComplete()
        dropDown.dataSource = ["One", "Two", "Three","Foure"]
        dropDown.onTextField = cell.textField // Your TextField 
        dropDown.isSearchBig = false // High Light search Text
        dropDown.show(onTableView: tableView, atIndexPath: indexPath) { (str, index) in
            cell.textField = str
        }
        
```


## Installation

Copy VPAutoComplete-Source folder in Your project and start using


## Authors
* **Vive Padaya**

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
