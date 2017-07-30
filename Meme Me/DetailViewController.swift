//
//  DetailViewController.swift
//  Meme Me
//
//  Created by Jamel Reid  on 7/29/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = meme.memedImage
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPressed))
        self.navigationItem.setRightBarButton(editButton, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    func editPressed() {
        let memeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        memeViewController.editMeme = meme
        self.navigationController?.pushViewController(memeViewController, animated: true)
    }

}
