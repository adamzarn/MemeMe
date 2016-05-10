//
//  TableViewController.swift
//  MemeMePrep
//
//  Created by Adam Zarn on 5/1/16.
//  Copyright © 2016 Adam Zarn. All rights reserved.
//

import UIKit

extension UIViewController {
    var appDelegate:AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
}

class SentMemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addMeme: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as! CustomTableCell
        
        if appDelegate.memes.count == 0 {
            cell.myLabel!.text = ""
        } else {
        cell.myLabel!.text = appDelegate.memes[indexPath.row].topText + " ... " + appDelegate.memes[indexPath.row].bottomText
        cell.myLabel.adjustsFontSizeToFitWidth = true
        cell.myImageView!.image = appDelegate.memes[indexPath.row].image
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var controller: ShowMemeViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("showMeme") as! ShowMemeViewController
        controller.memedImageIndex = indexPath.row
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        if editingStyle == .Delete {
            appDelegate.memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
    }
}