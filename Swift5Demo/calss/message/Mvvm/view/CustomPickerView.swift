//
//  CustomPickerView.swift
//  Swift5Demo
//
//  Created by 杨永 on 2021/10/14.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit

protocol CustomPickerViewDelegate: NSObjectProtocol {
    func onDismisser(selection: String?)
    func onSelectionMade(selection: String?)
}

protocol CustomPickerViewDatasource: NSObjectProtocol {
    func values() -> [Any]?
}


class CustomPickerView: UIView {

    weak var delegate: CustomPickerViewDelegate?
    weak var datasource: CustomPickerViewDatasource?
    
    var selection: String?

    var pickerView: UIPickerView!
    var cancleBtn: UIButton!
    var doneBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
        cancleBtn = UIButton()
        cancleBtn.setTitle("取消", for:.normal)
        cancleBtn.addTarget(self, action: #selector(cancle), for: .touchUpInside)
        addSubview(cancleBtn)
        
        doneBtn = UIButton()
        doneBtn.setTitle("确认", for:.normal)
        doneBtn.addTarget(self, action: #selector(done), for: .touchUpInside)
        addSubview(doneBtn)

        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        addSubview(pickerView)
        
        
        cancleBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(16)
            make.height.equalTo(40)
        }
        
        doneBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalTo(-16)
            make.height.equalTo(40)
        }
        
        pickerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalTo(cancleBtn.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    @objc func cancle() {
        delegate?.onDismisser(selection: nil)
    }
    @objc func done() {
        delegate?.onDismisser(selection: selection)
    }
    
}


extension CustomPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datasource?.values()?[row] as? String

    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selection = datasource?.values()?[row] as? String
        delegate?.onSelectionMade(selection: selection)
    }
}

extension CustomPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard datasource?.values() == nil else {
            return 0
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datasource?.values()?.count ?? 0
    }
    

}
