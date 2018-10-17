//
//  MemeStruct.swift
//  ImagePickerExperiment
//
//  Created by carloshenrique.carmo on 25/09/18.
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

struct MemeManager{
    
    private static var allMemes:[Meme]{
        return getMemeStorage().memes
    }
    
    static func count() -> Int{
        return allMemes.count
    }
    
    private static func getMemeStorage() -> AppDelegate{
        let object = UIApplication.shared.delegate
        return object as! AppDelegate
    }
    
    static func remove(Meme receivedMeme:UIImage){
        
        for index in 0..<count(){
            
            if allMemes[index].memedImage == receivedMeme{
                removeMeme(atIndex: index)
                return
            }
        }
    }
    
    static func removeMeme(atIndex index:Int){
        getMemeStorage().memes.remove(at: index)
    }
}
