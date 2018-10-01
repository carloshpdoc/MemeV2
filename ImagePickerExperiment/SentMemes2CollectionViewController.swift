//
//  SentMemes2CollectionViewController.swift
//  ImagePickerExperiment
//
//  Created by carloshenrique.carmo on 27/09/18.
//  Copyright © 2018 carloshenrique.carmo. All rights reserved.
//

import Foundation
import UIKit

class SentMemes2CollectionViewController: UICollectionViewController  {
   
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space: CGFloat = 5.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let heigth = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: heigth)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes

        self.collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Meme2Cell", for: indexPath) as! Meme2CollectionViewCell
            let currentMeme = memes[indexPath.row]
            
            cell.memeImageView?.image = currentMeme.memedImage
            cell.memeTitle?.text = "\(currentMeme.topText) - \(currentMeme.bottomText)"
            cell.memeImageView.contentMode = .scaleAspectFit
            
            return cell
    }
    
   override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailController.memes = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(memeDetailController, animated: true)
    }
}
    

