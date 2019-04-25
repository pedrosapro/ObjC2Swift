//
//  PreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Pedro Sánchez Castro on 11/04/2019.
//  Copyright © 2019 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifPreviewViewController: UIViewController {
    
    var gif: Gif?

    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var newCaption: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Disable interaction in Storyboard...
        gifImageView.image = gif?.gifImage
        newCaption.text = gif?.caption
    }
    
    @IBAction func shareGif(_ sender: Any) {
        
        let animatedGif = gif?.gifData
        let itemsToShare = [animatedGif]
        
        
        //UIActivityViewController
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare as [Any] , applicationActivities: nil )
        
        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        // Present
        navigationController?.present(activityVC, animated: true, completion: nil)
        
    }

}
