//
//  ViewController.swift
//  MemeMePrep
//
//  Created by Adam Zarn on 3/30/16.
//  Copyright © 2016 Adam Zarn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    struct Meme {
        var topText:String
        var bottomText:String
        var image:UIImage
        var memedImage:UIImage?
        
        init(topText: String, bottomText: String, image: UIImage) {
            self.topText = topText
            self.bottomText = bottomText
            self.image = image
            self.memedImage = image
        }
    }

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareMemeButton: UIBarButtonItem!
    
    func setUpView(topText:String,bottomText:String,shareMeme:Bool,cancelButtonEnabled:Bool,cancelButtonTitle:String) {
        topTextField.text = topText
        bottomTextField.text = bottomText
        shareMemeButton.enabled = shareMeme
        cancelButton.enabled = cancelButtonEnabled
        cancelButton.title = cancelButtonTitle
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        imagePickerView.image = nil
        setUpView("TOP",bottomText:"BOTTOM",shareMeme:false,cancelButtonEnabled:false,cancelButtonTitle:"")
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        self.presentViewController(activityController, animated: true, completion: nil)
    }
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName:UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: CGFloat(-3.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        
        setUpView("TOP",bottomText:"BOTTOM",shareMeme:false,cancelButtonEnabled:false,cancelButtonTitle:"")
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification,object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:",name: UIKeyboardWillHideNotification,object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self,name: UIKeyboardWillShowNotification,object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.editing {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func imagePickerController(picker: UIImagePickerController,didFinishPickingMediaWithInfo info:[String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = .ScaleAspectFit
            imagePickerView.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)

        setUpView("TOP",bottomText:"BOTTOM",shareMeme:true,cancelButtonEnabled:true,cancelButtonTitle:"Cancel")
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickerController, animated: true, completion: nil)

        setUpView("TOP",bottomText:"BOTTOM",shareMeme:true,cancelButtonEnabled:true,cancelButtonTitle:"Cancel")
    }
    
    @IBAction func textFieldDidBeginEditing(textField: UITextField) {
        textField.becomeFirstResponder()
        if textField.text == "TOP" {
            textField.text = ""
        }
        if textField.text == "BOTTOM" {
            textField.text = ""
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if topTextField.editing {
            if textField.text == "" {
                textField.text = "TOP"
            }
        }
        if bottomTextField.editing {
            if textField.text == "" {
                textField.text = "BOTTOM"
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
    private func save() {
        var meme = Meme(topText: topTextField.text!,bottomText:bottomTextField.text!,image:imagePickerView.image!)
    }

    func generateMemedImage() -> UIImage {
        toolBar.hidden = true
        navBar.hidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        toolBar.hidden = false
        navBar.hidden = false
        return memedImage
    }
    
}


