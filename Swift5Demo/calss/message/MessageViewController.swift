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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let arr = [12,2,555,35,154,33,25,65,3]
//        quickSort(arr: arr)
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


//算法
extension MessageViewController {
        
    //冒泡排序 时间复杂度 O(n^2)
    func bubblesort(arr: [Int]) -> [Int] {
        guard !arr.isEmpty else {
            return []
        }
        var preArray = arr
        for i in 0 ..< preArray.count {
            print(i)
            for j in 0 ..< preArray.count - i - 1  {
                if preArray[j] > preArray[j + 1] {
                    let temp = preArray[j + 1]
                    preArray[j + 1] = preArray[j]
                    preArray[j] = temp
                }
            }
        }
        return preArray
    }

    //冒泡排序 优化
    func bubbleSortBetter(arr: [Int]) -> [Int] {
        guard !arr.isEmpty else {
            return []
        }
        var preArray = arr
        for i in 0 ..< preArray.count {
            print(i)
            var exchange = false
            for j in 0 ..< preArray.count - i - 1  {
                if preArray[j] > preArray[j + 1] {
                    let temp = preArray[j + 1]
                    preArray[j + 1] = preArray[j]
                    preArray[j] = temp
                    exchange = true
                }
            }
            if !exchange {
                return preArray
            }
        }
        return preArray
    }
    
    //选择排序 O(n^2)
    func selectionSort(arr: [Int]) -> [Int] {
        guard !arr.isEmpty else {
            return []
        }
        var preArray = arr
        for i in 0 ..< preArray.count - 1 {
            for j in i + 1 ..< preArray.count {
                if preArray[i] < preArray[j] {  // 寻找最小值
                    let temp = preArray[i]
                    preArray[i] = preArray[j]
                    preArray[j] = temp
                }
            }
        }
        return preArray
    }
    
    //插入排序 O(n^2)
    func insertSort(arr: [Int]) -> [Int] {
        guard !arr.isEmpty else {
            return []
        }
        var preArray: [Int] = arr
        for i in 1 ..< arr.count {
            var preIndex = i - 1
            let current = arr[i]
            while preIndex >= 0, preArray[preIndex] > current {
                preArray[preIndex + 1] = preArray[preIndex]
                preIndex -= 1
            }
            preArray[preIndex + 1] = current
            print(preArray)
        }
        return preArray
    }
    
    //MARK: -
    //快速排序的最坏运行情况是 O(n²) 左边比p小， 右边比p大
    func quickSort(arr: [Int]) -> [Int] {
        var preArray = arr
        return quick(array: &preArray, left: 0, right: arr.count - 1)
    }
    
    func quick(array: inout [Int], left: Int, right: Int) -> [Int] {
        guard !array.isEmpty else {
            return []
        }
        if left < right {
            let middle = partition(array: &array, left: left, right: right)
            quick(array: &array, left: left, right: middle - 1)
            quick(array: &array, left: middle + 1, right: right)
        }
        return array
    }
    
    func partition(array: inout [Int], left: Int, right: Int) -> Int {
        let privot = array[left]
        var index = left + 1
        for i in left...right {
            if array[i] < privot {
                array.swapAt(i, index)
                print("partition for i in: \(array)")
                index += 1
            }
        }
        let middle = index - 1
        array.swapAt(left, middle)
        print("partition: \(array)")
        return middle
    }
    
    //堆排序
    /*
     大顶堆：每个节点的值都大于或等于其子节点的值，在堆排序算法中用于升序排列；

     小顶堆：每个节点的值都小于或等于其子节点的值，在堆排序算法中用于降序排列；

     堆排序的平均时间复杂度为 Ο(nlogn)
     */
    func heapSort(array: [Int]) -> [Int] {
        guard !array.isEmpty else {
            return []
        }
        var preArray = array
        buildMaxHeap(arr: &preArray)
        for i in (0..<preArray.count).reversed() {
            preArray.swapAt(i, 0)
            heapify(arr: &preArray, nodeIndex: 0, len: i)
        }
        return preArray
    }
    
    //建立大顶椎
    func buildMaxHeap(arr: inout [Int]) {
        let minNodeIndex = Int(floor(Double(arr.count/2)) - 1)
        for index in (0...minNodeIndex).reversed() {
            heapify(arr: &arr, nodeIndex: index, len: arr.count)
        }
    }
    
    //优化大顶椎
    func heapify(arr: inout [Int], nodeIndex: Int, len: Int) {
        let left = 2 * nodeIndex + 1
        let right = 2 * nodeIndex + 2
        var largest = nodeIndex
        if left < len, arr[left] > arr[largest] {
            largest = left
        }
        if right < len, arr[right] > arr[largest] {
            largest = right
        }
        if largest != nodeIndex {
            arr.swapAt(nodeIndex, largest)
            print("当前数据：\(arr)")
            heapify(arr: &arr, nodeIndex: largest, len: len)
        }
        
        print("当前数据：\(arr)")
    }
    
    //归并排序 O(nlogn) 的时间复杂度。代价是需要额外的内存空间。
    //1.自上而下的递归
    //2.自下而上的迭代；
    func mergeSort(array: [Int]) -> [Int] {
        guard !array.isEmpty else {
            return []
        }
        let count: Int = array.count
        if count <= 2 {
            return array
        }
        let middle = Int(floor(Double(count/2)))
        let leftArray = array.prefix(upTo: middle)
        let rightArray = array.suffix(from: middle)
        return merge(leftArray: Array(leftArray).sorted(), rightArray: Array(rightArray).sorted())
    }
    
    func merge(leftArray: [Int], rightArray: [Int]) -> [Int] {
        var result: [Int] = []
        var left = leftArray
        var right = rightArray
        while left.count > 0, right.count > 0 {
            if left[0] < right[0] {
                result.append(left[0])
                left.removeFirst()
            } else {
                result.append(right[0])
                right.removeFirst()
            }
        }
        while left.count > 0 {
            result.append(left[0])
            left.removeFirst()
        }
        while right.count > 0 {
            result.append(right[0])
            right.removeFirst()
        }
        return result
    }
    
    
    //MARK: -
    //希尔排序
    
    //基数排序 时间复杂度是 O(n) 先比较个位排序，再比较十位排序。。。
    func radixSort(array: [Int]) -> [Int] {
        guard !array.isEmpty else {
            return []
        }
        var preArray = array
        var mod = 10
        var dev = 1
        let maxDigint = getMaxDigit(array)
        
        for _ in 0 ..< maxDigint {
            var buckets = Array(repeating: [Int](), count: 10)
            preArray.forEach { num in
                if num < 0 {return}
                let comparaNum = num % mod / dev
                buckets[comparaNum].append(num)
            }
            
            var newArray: [Int] = []
            buckets.forEach { arr in
                if !arr.isEmpty {
                    newArray += arr
                }
            }
            preArray = newArray
            dev *= 10
            mod *= 10
        }
        return preArray
    }
    
    //获取数组最大值位数
    func getMaxDigit(_ arr:[Int]) -> Int {
        guard var maxNum = arr.first else { return 0 }
        arr.forEach { num in
            if maxNum < num {
                maxNum = num
            }
        }
        guard maxNum != 0 else {
            return 1
        }
        var digint = 0
        while maxNum > 0 {
            maxNum = maxNum/10
            digint += 1
        }
        return digint
    }
    
    
    //计数排序 试用范围小
    
}
