//
//  Entry.swift
//  Tackboard
//
//  Created by Wu Wenqi on 24/1/15.
//  Copyright (c) 2015 Wenqi. All rights reserved.
//

import UIKit

class Entry {
    private var objectId = ""
    private var text = ""
    private var userId = ""
    private var image: UIImage = UIImage()
    private var helperId = ""
    private var helperImg: UIImage = UIImage()
    private var status = 0
    
    func getText() -> String {
        return self.text
    }
    
    func getUserId() -> String {
        return self.userId
    }
    
    func getImage() -> UIImage {
        return self.image
    }
    
    func getId() -> String {
        return self.objectId
    }
    
    func getStatus() -> Int {
        return self.status
    }
    
    init(objectId: String, text: String, userId: String, image: UIImage, status: Int){
        self.objectId = objectId
        self.text = text
        self.userId = userId
        self.image = image
        self.status = status
    }
    
    func setHelperImg(image: UIImage){
        self.helperImg = image
    }
    
    func getHelperImg() -> UIImage {
        return self.helperImg
    }
    
    func setHelperId(helperId: String){
        self.helperId = helperId
    }
    
    func getHelperId() -> String {
        return self.helperId
    }
    
    func setStatus(status: Int){
        self.status = status
    }
    
}