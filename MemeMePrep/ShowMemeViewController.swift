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
    var comingFromViewer = false
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var showMemeView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        showMemeView.image = appDelegate.memes[memedImageIndex].memedImage
    }
    
    @IBAction func editButtonPressed() {
        self.performSegueWithIdentifier("edit", sender: editButton)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationNavigationController = segue.destinationViewController as! UINavigationController
        let controller = destinationNavigationController.topViewController as! MemeViewController
        controller.memedImageIndex = self.memedImageIndex
        controller.comingFromViewer = true
    }
    
}