//
//  MemeViewController.swift
//  MemeMePrep
//
//  Created by Adam Zarn on 3/30/16.
//  Copyright © 2016 Adam Zarn. All rights reserved.
//

import UIKit

struct Meme {
    var topText:String
    var bottomText:String
    var image:UIImage
    var memedImage:UIImage
}

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareMemeButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
    var memedImageIndex = 0
    var comingFromViewer = false
    
    func setUpView(topText:String,bottomText:String,shareMeme:Bool,cancelButtonEnabled:Bool,cancelButtonTitle:String) {
        topTextField.text = topText
        bottomTextField.text = bottomText
        shareMemeButton.enabled = shareMeme
        cancelButton.enabled = cancelButtonEnabled
        cancelButton.title = cancelButtonTitle
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        if imagePickerView.image == nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
        shareMemeButton.enabled = false
        imagePickerView.image = nil
        }
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
        presentViewController(activityController, animated: true, completion: nil)
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
        setUpView("TOP",bottomText:"BOTTOM",shareMeme:false,cancelButtonEnabled:true,cancelButtonTitle:"Cancel")
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
        
        if comingFromViewer {
            topTextField.text = appDelegate.memes[memedImageIndex].topText
            bottomTextField.text = appDelegate.memes[memedImageIndex].bottomText
            imagePickerView.image = appDelegate.memes[memedImageIndex].image
            shareMemeButton.enabled = true
        }
        comingFromViewer = false
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification,object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeViewController.keyboardWillHide(_:)),name: UIKeyboardWillHideNotification,object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self,name: UIKeyboardWillShowNotification,object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.editing {
            view.frame.origin.y = -1*getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeFromKeyboardNotifications()
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
    
    func setSource(sourceType:UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        presentViewController(pickerController, animated: true, completion: nil)
        setUpView("TOP",bottomText:"BOTTOM",shareMeme:true,cancelButtonEnabled:true,cancelButtonTitle:"Cancel")
    }

    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
       setSource(.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        setSource(.Camera)
    }
    
    @IBAction func textFieldDidBeginEditing(textField: UITextField) {
        textField.becomeFirstResponder()
        if textField.text == "TOP" || textField.text == "BOTTOM" {
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
    
    func save() {
        let meme = Meme(topText: topTextField.text!,bottomText:bottomTextField.text!,image:imagePickerView.image!,memedImage:generateMemedImage())
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }

    func generateMemedImage() -> UIImage {
        toolBar.hidden = true
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        toolBar.hidden = false
        return memedImage
    }
    
}


