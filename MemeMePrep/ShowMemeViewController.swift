//
//  ShowMemeViewController.swift
//  MemeMePrep
//
//  Created by Adam Zarn on 5/6/16.
//  Copyright © 2016 Adam Zarn. All rights reserved.
//

import UIKit

class ShowMemeViewController: UIViewController {
    
    var memedImageIndex = 0
    
    @IBOutlet weak var showMemeView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        showMemeView.image = appDelegate.memes[memedImageIndex].memedImage
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {

        let memedImage = appDelegate.memes[memedImageIndex].memedImage
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
            if completed {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(activityController, animated: true, completion: nil)
    }

}
