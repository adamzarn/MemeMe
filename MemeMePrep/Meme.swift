//
//  Meme.swift
//  MemeMePrep
//
//  Created by Adam Zarn on 4/2/16.
//  Copyright © 2016 Adam Zarn. All rights reserved.
//

import UIKit

class Meme: NSObject {
    var topText:String
    var bottomText:String
    var image:UIImage
    var memedImage:UIImage?
    
    init(topText: String, bottomText: String, image: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = image
    }
}