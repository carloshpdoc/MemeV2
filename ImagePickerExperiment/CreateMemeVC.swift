//
//  ViewController.swift
//  ImagePickerExperiment
//
//  Created by carloshenrique.carmo on 09/09/18.
//  Copyright © 2018 carloshenrique.carmo. All rights reserved.
//

import Foundation
import UIKit

class CreateMemeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var albumPhoto: UIBarButtonItem!
    @IBOutlet weak var cam: UIBarButtonItem!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadText(textTop, "TOP TEXT")
        loadText(textBottom, "BOTTOM TEXT")
        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cam.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        shareButton.isEnabled = imagePickerView.image != nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func loadText(_ textField: UITextField , _ textInitial: String) {
        let style: [String: Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -3]

        textField.text = textInitial
        textField.defaultTextAttributes = style
        textField.delegate = self
        textField.textAlignment = .center

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField.isEqual(textBottom) {
            self.unsubscribeFromKeyboardNotifications()
        }
        return true;
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == textBottom {
            subscribeToKeyboardNotifications()
        } else {
            unsubscribeFromKeyboardNotifications()
        }
    }
    
    @IBAction func pickerAnImage(_ sender: Any) {
        presentImagePickerWith(.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any){
        presentImagePickerWith(.camera)
    }
    
    func presentImagePickerWith(_ sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        
        present(imagePicker, animated: true, completion: nil)
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFit
            imagePickerView.image = image
        }
         dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: .UIKeyboardDidHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func save() {
        let meme = Meme(topText: textTop.text!, bottomText: textBottom.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())

        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)        
    }
    
    func generateMemedImage() -> UIImage {
        showNavToolBar(true)
        self.navigationController?.navigationBar.isHidden = true
        self.toolbar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        showNavToolBar(false)
        
        return memedImage
    }

    @IBAction func share(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {activity, didComplete,
            items, error in if didComplete {
                self.save()
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        loadText(textTop, "TOP TEXT")
        loadText(textBottom, "BOTTOM TEXT")
        shareButton.isEnabled = false
        imagePickerView.image = nil
        dismiss(animated: true, completion: nil)
    }
    
    func showNavToolBar(_ hide: Bool){
        self.navigationBar.isHidden = hide
        self.toolbar.isHidden = hide
    }
    
}

