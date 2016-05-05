//
//  TableViewController.swift
//  MemeMePrep
//
//  Created by Adam Zarn on 5/1/16.
//  Copyright © 2016 Adam Zarn. All rights reserved.
//

import UIKit

class SentMemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var addMeme: UIBarButtonItem!
    
    let object = UIApplication.sharedApplication().delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = object as! AppDelegate
        if appDelegate.memes.count == 0 {
            return 1
        }
        return appDelegate.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        let appDelegate = object as! AppDelegate
        
        if appDelegate.memes.count == 0 {
            cell.textLabel!.text = "No Sent Memes"
        } else {
        cell.textLabel!.text = appDelegate.memes[indexPath.row].topText + appDelegate.memes[indexPath.row].bottomText
        cell.imageView!.image = appDelegate.memes[indexPath.row].image
        }
        return cell
    }
    
}