//
//  EditViewController.swift
//  Meme Me
//
//  Created by Jamel Reid  on 7/29/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    var meme: Meme!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension EditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.activeTextFeild = textField
        
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
}

extension EditViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage  {
            self.imageView.image = image
            self.imageView.contentMode = UIViewContentMode.scaleAspectFit
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
