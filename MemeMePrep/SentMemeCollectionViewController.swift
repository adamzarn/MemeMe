//
//  SentMemeCollectionViewController.swift
//  MemeMePrep
//
//  Created by Adam Zarn on 5/1/16.
//  Copyright © 2016 Adam Zarn. All rights reserved.
//

import UIKit

class SentMemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var addMeme: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (UIScreen.mainScreen().bounds.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension,dimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView?.reloadData()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return appDelegate.memes.count
    }
    
    let strokeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 17)!,
        NSStrokeWidthAttributeName: CGFloat(-3.0)]
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CustomMemeCell
        
        let cSelector = #selector(SentMemeCollectionViewController.reset(_:))
        let UpSwipe = UISwipeGestureRecognizer(target: self, action: cSelector)
        UpSwipe.direction = UISwipeGestureRecognizerDirection.Up
        cell.addGestureRecognizer(UpSwipe)
        
        if appDelegate.memes.count == 0 {
            cell.topText!.text = ""
            cell.bottomText!.text = ""
        } else {
            cell.topText!.attributedText = NSAttributedString(string:appDelegate.memes[indexPath.row].topText,attributes:strokeTextAttributes)
            cell.bottomText!.attributedText = NSAttributedString(string:appDelegate.memes[indexPath.row].bottomText,attributes:strokeTextAttributes)
            cell.image!.image = appDelegate.memes[indexPath.row].image
        }
        cell.topText.adjustsFontSizeToFitWidth = true
        cell.bottomText.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var controller: ShowMemeViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("showMeme") as! ShowMemeViewController
        controller.memedImageIndex = indexPath.row
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func reset(sender: UISwipeGestureRecognizer) {
        let cell = sender.view as! UICollectionViewCell
        let i = self.collectionView.indexPathForCell(cell)!.item
        appDelegate.memes.removeAtIndex(i)
        collectionView?.reloadData()
    }
}

