//
//  MemeEditorViewController.swift
//  PickImage
//
//  Created by Mohammed Ibrahim on 4/28/16.
//  Copyright © 2016 myw. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
 
    
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var BottomToolBar: UIToolbar!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var memedImage : UIImage!
    func presentViewController(source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
        imagePicker.sourceType = source
        
        shareButton.enabled = true
    }
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(), NSForegroundColorAttributeName : UIColor.blueColor(), NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, NSStrokeWidthAttributeName : -1.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = NSTextAlignment.Center
        bottomText.textAlignment = NSTextAlignment.Center
        shareButton.enabled = false
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        topText.text = ""
        bottomText.text = ""
        subscribeToKeyboardNotifications()
        keyboardDidDisapper()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    func imagePickerController(_picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImagePickerView.image = image
            ImagePickerView.contentMode = .ScaleAspectFit
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(_picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func pickAnImage(sender: AnyObject) {
        presentViewController(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        
        presentViewController(UIImagePickerControllerSourceType.Camera)
    }
    
    func textFieldShouldReturn(textField : UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    //Testing the commit
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:
            #selector(MemeEditorViewController.keyboardWillShow(_:))    , name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillHide(notification : NSNotification) {
        if bottomText.isFirstResponder() {
            view.frame.origin.y = 0        }
    }
    
    func keyboardDidDisapper() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    func save() {
        let meme = MemeMeObject(top: self.topText.text!, bottom: self.bottomText.text!, image: self.ImagePickerView.image, memedImage:self.generateMemeImage())
        
    }
    
    func generateMemeImage()->UIImage {
        
        BottomToolBar.hidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        BottomToolBar.hidden = false
        return memedImage
    }
    
    @IBAction func shareMemeButton(sender: AnyObject) {
        let image = generateMemeImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        presentViewController(controller,animated : true, completion : nil)
        controller.completionWithItemsHandler = {
            (activity, success, items, error) in
            self.save()
            
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    
    @IBAction func cancelButton(sender: AnyObject) {
        topText.text = "Top"
        bottomText.text = "Bottom"
        ImagePickerView.image = nil
        
    }
    
    override func viewWillLayoutSubviews() {
        if UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft || UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight {
            var rect = ImagePickerView.frame
            rect.size.width = 540
            rect.size.height = 480
            rect.origin.x = 30
            ImagePickerView.frame = rect
            rect = topText.frame
            rect.origin.x = 20
            rect.size.width = 560
            rect.size.height = 30
            topText.frame = rect
            
            rect = bottomText.frame
            rect.origin.y = 510
            rect.size.width = 560
            rect.size.height = 30
            bottomText.frame = rect
        } else{
            var rect = ImagePickerView.frame
            rect.size.width = 480
            rect.size.height = 540
            rect.origin.x = 30
            ImagePickerView.frame = rect
            rect = topText.frame
            rect.origin.x = 20
            rect.size.width = 560
            rect.size.height = 30
            topText.frame = rect
            
            rect = bottomText.frame
            rect.origin.y = 510
            rect.size.width = 560
            rect.size.height = 30
            bottomText.frame = rect
        }
    }
    
}

