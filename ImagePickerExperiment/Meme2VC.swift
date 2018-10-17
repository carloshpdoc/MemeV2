//
//  Meme2.swift
//  ImagePickerExperiment
//
//  Created by carloshenrique.carmo on 25/09/18.
//  Copyright © 2018 carloshenrique.carmo. All rights reserved.
//

import Foundation
import UIKit

class Meme2VC: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet var sentMemesTableView: UITableView!
    var memes: [Meme]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        sentMemesTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Meme2Cell")!
        let tableMemes = memes[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = "\(tableMemes.topText) - \(tableMemes.bottomText)"
        cell.imageView?.image = tableMemes.memedImage
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.memes = self.memes[indexPath.row]
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            memes?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
