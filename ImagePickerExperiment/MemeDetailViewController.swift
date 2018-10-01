//
//  MemeDetailViewController.swift
//  ImagePickerExperiment
//
//  Created by carloshenrique.carmo on 25/09/18.
//  Copyright © 2018 carloshenrique.carmo. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    var memes: Meme!
    
    @IBOutlet weak var memeImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(MemeDetailViewController.startEditor))
        memeImageView.image = memes.memedImage
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func startEditor() {
        let startMeme = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        self.present(startMeme, animated: true, completion: nil)
        
        startMeme.textTop.text = memes.topText
        startMeme.textBottom.text = memes.bottomText
        startMeme.imagePickerView.image = memes.originalImage
        startMeme.isEditing = true
    }
}
