//
//  Extension.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 2..
//  Copyright © 2018년 박현호. All rights reserved.
//

/*
 Description : extension 함수 정의
 */

import Foundation
import UIKit

extension UIViewController {
    func gsno(_ value: String?) -> String {
        return value ?? ""
    }
    
    func gino(_ value: Int?) -> Int {
        return value ?? 0
    }
    
}

extension NSObject {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

//  사진관련
protocol Gallery : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var homeController : UIViewController? {get set}
    
    func openGalleryCamera()
    
    
}

extension Gallery {
    
    
    func openGalleryCamera(){
        let selectAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "앨범", style: .default) { _ in if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.homeController?.present(imagePicker, animated: true, completion: nil)
            }
            
        }
        let cameraAction = UIAlertAction(title: "카메라", style: .default) {
            _ in  if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = true
                self.homeController?.present(imagePicker, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        selectAlert.addAction(libraryAction)
        selectAlert.addAction(cameraAction)
        selectAlert.addAction(cancelAction)
        self.homeController?.present(selectAlert, animated: true, completion: nil)
    }
}

//  hide keyboard 기본
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
