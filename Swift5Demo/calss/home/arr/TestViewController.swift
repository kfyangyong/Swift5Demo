//
//  TestViewController.swift
//  Swift5Demo
//
//  Created by 杨永 on 2021/11/20.
//  Copyright © 2021 com.ayong.myapp. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TestViewController: UIViewController {
    
    let photoButton = UIButton(type: .custom)
    let imageButton = UIButton(type: .custom)
    let disposeBag = DisposeBag()
    let imageView = UIImageView(frame: CGRect(x: 0, y: 600, width: 400, height: 400))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //        testArray()
        
        photoButton.frame = CGRect(x: 20, y: 100, width: 100, height: 100)
        photoButton.setTitle("相机", for: .normal)
        photoButton.backgroundColor = .yellow
        view.addSubview(photoButton)
        takePhoto()
        
        
        
        imageButton.frame = CGRect(x: 20, y: 300, width: 100, height: 100)
        imageButton.setTitle("相册", for: .normal)
        imageButton.backgroundColor = .yellow
        view.addSubview(imageButton)
        takePhotoImage()
        
        view.addSubview(imageView)
        
    }
    
    func takePhoto() {
        
        photoButton.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .camera
                    picker.allowsEditing = false
                }
                .flatMap { $0.rx.didFinishPickingMediaWithInfo }
                .take(1)
            }
            .map { info in
                return info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        
        
        // 裁剪
        //        imageButton.rx.tap
        //            .flatMapLatest { [weak self] _ in
        //                return UIImagePickerController.rx.createWithParent(self) { picker in
        //                    picker.sourceType = .photoLibrary
        //                    picker.allowsEditing = true
        //                }
        //                .flatMap { $0.rx.didFinishPickingMediaWithInfo }
        //                .take(1)
        //            }.map { info in
        //                return info[.editedImage] as? UIImage
        //            }
        //            .bind(to: imageView.rx.image)
        //            .disposed(by: disposeBag)
    }
    
    
    
    func takePhotoImage() {
        // 相册
        imageButton.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = false
                }
                .flatMap {
                    $0.rx.didFinishPickingMediaWithInfo
                }
                .take(1)
                
                
            }
            .map { info in
                return info[.originalImage] as? UIImage
            }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    //元组
    func testArray() {
        var arr:Array = ["tom1","tom2","tom3","tom4","tom2","tom3","tom2","tom3"]
        arr.append("ads")
        for name in arr {
            print(name)
        }
        for name in arr.sorted() {
            print( "sort: " + name)
        }
        
        var arr1:[Int] = [Int](repeating: 10, count: 9)
        for num in arr1 {
            print( "arr1: \(num)")
        }
        
        for (index, value) in arr.enumerated() {
            print( "arr: \(index) = " ,value)
        }
        //缓存容量
        arr.reserveCapacity(100)
    }
}


func dismissViewController(viewController: UIViewController, animated: Bool) {
    /// 是否有控制器在进程中没有显示或消失
    if viewController.isBeingPresented || viewController.isBeingDismissed {
        DispatchQueue.main.async {// 异步递归调用
            dismissViewController(viewController: viewController, animated: animated)
        }
    } else if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated, completion: nil)
    }
}

extension Reactive where Base: UIImagePickerController {
    static func createWithParent(_ parent: UIViewController?, animated: Bool = true, configureImagePicker: @escaping (UIImagePickerController) throws -> Void = { x in }) -> Observable<UIImagePickerController> {
        return Observable.create { [weak parent] observer in
            let imagePicker = UIImagePickerController()
            let dismissDisposable = imagePicker.rx
                .didCancel
                .subscribe(onNext: { [weak imagePicker] _ in
                    guard let imagePicker = imagePicker else {
                        return
                    }
                    dismissViewController(viewController: imagePicker, animated: animated)
                })
            
            do {
                try configureImagePicker(imagePicker)
            }
            catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }
            
            guard let parent = parent else {
                observer.on(.completed)
                return Disposables.create()
            }
            
            parent.present(imagePicker, animated: animated, completion: nil)
            observer.on(.next(imagePicker))
            
            return Disposables.create(dismissDisposable, Disposables.create {
                dismissViewController(viewController: imagePicker, animated: animated)
            })
        }
    }
}

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIImagePickerController {
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey : AnyObject]> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map({ (a) in
                return try castOrThrow(Dictionary<UIImagePickerController.InfoKey, AnyObject>.self, a[1])
            })
    }
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didCancel: Observable<()> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map {_ in () }
    }
    
}


private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}
