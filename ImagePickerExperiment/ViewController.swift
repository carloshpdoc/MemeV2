//
//  ViewController.swift
//  ImagePickerExperiment
//
//  Created by carloshenrique.carmo on 09/09/18.
//  Copyright © 2018 carloshenrique.carmo. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
    
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var AlbumPhoto: UIBarButtonItem!
    @IBOutlet weak var Cam: UIBarButtonItem!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadText(textTop, "TOP TEXT")
        loadText(textBottom, "BOTTOM TEXT")
//      shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Cam.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
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
        if textField.text == "TOP TEXT" || textField.text == "BOTTOM TEXT" {
            textField.text = ""
        }
        
        if textField == textBottom {
            subscribeToKeyboardNotifications()
        } else {
            unsubscribeFromKeyboardNotifications()
        }
    }
    
    @IBAction func pickerAnImage(_ sender: Any) {
         let pickerController = UIImagePickerController()
         pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
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
        _ = Meme(topText: textTop.text!, bottomText: textBottom.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
//        showNavToolBar(true)
        self.navigationController?.navigationBar.isHidden = true
        self.toolbar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.navigationBar.isHidden = false
        self.toolbar.isHidden = false
        
        return memedImage
    }

    @IBAction func share(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {activity, didComplete,
            items, error in if didComplete {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        loadText(textTop, "TOP TEXT")
        loadText(textBottom, "BOTTOM TEXT")
        shareButton.isEnabled = false
        imagePickerView.image = nil
    }
    //    func showNavToolBar(_ x: Bool){
//        self.navigationController?.navigationBar.isHidden = x
//        self.toolbar.isHidden = x
//    }
    
}

