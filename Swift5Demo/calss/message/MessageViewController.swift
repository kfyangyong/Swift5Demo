//
//  MessageViewController.swift
//  Swift5Demo
//
//  Created by 杨永 on 2019/9/24.
//  Copyright © 2019 com.ayong.myapp. All rights reserved.
//

import UIKit

enum PickerDataSource {
    case yearPicker
    case typePicker
    
    var values: [String] {
        switch self {
        case .yearPicker:
            var _years:[String] = []
            let start = 1975
            var year = start
            while year < 2021 {
                _years.append("\(year)")
                year = year + 1
            }
            return _years
        case .typePicker:
            return ["movie", "series", "episode"]
        }
    }
}

protocol SearchViewControllerProtocol {
    func searchCriteriaSelected(title:String, type: String?, year: String?)
}

class MessageViewController: BaseViewController {
    
    var doneButton: UIButton!
    var titleField: UITextField!
    var typeField: UITextField!
    var yearField: UITextField!
    
    fileprivate var pickerType:PickerDataSource?
    
    var delegate: SearchViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subUI()
    }
    
    func subUI() {
        titleField = UITextField(frame: CGRect(x: 10, y: 100, width: 300, height: 30))
        typeField = UITextField(frame: CGRect(x: 10, y: 150, width: 300, height: 30))
        yearField = UITextField(frame: CGRect(x: 10, y: 200, width: 300, height: 30))
        doneButton = UIButton(frame: CGRect(x: 10, y: 300, width: 300, height: 30))
        doneButton.setTitle("搜索", for:.normal)
        doneButton.backgroundColor = .blue
        doneButton.addTarget(self, action: #selector(search), for: .touchUpInside)
        
        titleField.delegate = self
        typeField.delegate = self
        yearField.delegate = self

        view.addSubview(titleField)
        view.addSubview(typeField)
        view.addSubview(yearField)
        view.addSubview(doneButton)
    }
    
    @objc func search() {
        delegate?.searchCriteriaSelected(title: titleField.text ?? "", type: typeField.text, year: yearField.text)
    }
    
    private lazy var typeCustomPickerView: CustomPickerView = {
        let pickerView = CustomPickerView(frame: CGRect(x: 0, y: self.view.frame.height - 256, width: self.view.frame.width, height: 256))
        pickerView.delegate = self
        pickerView.datasource = self
        return pickerView
    }()

    private lazy var yearCustomPickerView: CustomPickerView = {
        let pickerView = CustomPickerView(frame: CGRect(x: 0, y: self.view.frame.height - 256, width: self.view.frame.width, height: 256))
        pickerView.delegate = self
        pickerView.datasource = self
        return pickerView
    }()
}

extension MessageViewController: CustomPickerViewDelegate {
    func onDismisser(selection: String?) {
        typeCustomPickerView.removeFromSuperview()
        yearCustomPickerView.removeFromSuperview()
        if pickerType == PickerDataSource.typePicker {
            typeField.text = selection
        }
        if pickerType == PickerDataSource.yearPicker {
            yearField.text = selection
        }
    }
    
    func onSelectionMade(selection: String?) {
        if pickerType == PickerDataSource.typePicker {
            typeField.text = selection
        }
        if pickerType == PickerDataSource.yearPicker {
            yearField.text = selection
        }
    }
}

extension MessageViewController: CustomPickerViewDatasource {
    func values() -> [Any]? {
        return pickerType?.values
    }
}

extension MessageViewController:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == typeField {
            pickerType = PickerDataSource.typePicker
            view.addSubview(typeCustomPickerView)
            yearCustomPickerView.removeFromSuperview()
        }
        
        if textField == yearField {
            pickerType = PickerDataSource.yearPicker
            view.addSubview(yearCustomPickerView)
            typeCustomPickerView.removeFromSuperview()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == titleField {
            let length = (textField.text?.count)! - range.length + string.count
            if length == 0 {
                doneButton.isEnabled = false
            }
            else {
                doneButton.isEnabled = true
            }
        }
        return true
    }
}
