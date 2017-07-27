//
//  ViewController.swift
//  Meme Me
//
//  Created by Jamel Reid  on 7/26/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraBarButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var memedImage: UIImage!
    var activeTextFeild: UITextField?
    
    var meme: Meme!
    
    var barsVisible = false

    
    // Dictionary used to set default attributes on textfields
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.00]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextFields(textField: self.topTextField, string: "TOP")
        configureTextFields(textField: self.bottomTextField, string: "BOTTOM")
        
        self.shareButton.isEnabled = false
    }
    
    func configureTextFields(textField: UITextField, string: String) {
        textField.text = string
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.textAlignment = NSTextAlignment.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotificaiton()
        cameraBarButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotification()
    }

    @IBAction func albumPressed(_ sender: Any) {
        presentImagePickerController(sourceType: .photoLibrary)
    }
    
    @IBAction func cameraPressed(_ sender: Any) {
        presentImagePickerController(sourceType: .camera)
    }
    
    func presentImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    // Setup subscription to keybord events(show/hide)
    func subscribeToKeyboardNotificaiton(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // unsubscribe from keyboard events
    func unsubscribeFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // offset view by the height of the keyboard
    func keyboardWillShow(_ notification: Notification) {
        
        // check if view has already been repositioned
        // check if top textfield is currently being edited
        if view.frame.origin.y == 0 && (self.activeTextFeild! != topTextField){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // return the position of the view to normal
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // Perform Screen capture
    func generateMemedImage() -> UIImage {
        
        toggleBars(on: self.barsVisible)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toggleBars(on: self.barsVisible)
        
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        // Create the meme
        if checkMemeParameters() {
            meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
        }
    }
    
    func checkMemeParameters() -> Bool {
        
        if (topTextField.text) == nil {
            return false
        }
        
        if (bottomTextField.text) == nil {
            return false
        }
        
        if (imageView.image) == nil {
            return false
        }
        
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // toggle visibility nav and toolbar
    func toggleBars(on: Bool) {
        self.barsVisible = !on
        self.toolBar.isHidden = !on
        self.navBar.isHidden = !on
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        if (self.imageView.image) != nil {
            
            memedImage = generateMemedImage()
            let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            
            self.present(activityController, animated: true, completion: nil)
            
            activityController.completionWithItemsHandler = { activityController, success, items, error in
                
                if !success {
                    return
                }
                
                self.save(memedImage: self.memedImage)
            }
        }
    }
}

extension MemeViewController: UITextFieldDelegate {
    
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

extension MemeViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage  {
            self.imageView.image = image
            self.imageView.contentMode = UIViewContentMode.scaleAspectFit
            self.shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

