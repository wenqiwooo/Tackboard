//
//  GiveTableViewController.swift
//  Tackboard
//
//  Created by Wu Wenqi on 24/1/15.
//  Copyright (c) 2015 Wenqi. All rights reserved.
//

import UIKit

class GiveViewController: UIViewController {
    
    var profilePicData: NSData = NSData()
    var entries = [Entry]()
    var nearbyUsers = [String]()
    var currentEntry = 1
    
    var xFromCenter: CGFloat = 0
    
    func dragged(gesture: UIPanGestureRecognizer){
        
        let translation = gesture.translationInView(self.view)
        var label = gesture.view!
        
        label.center = CGPoint(x: label.center.x + translation.x, y: label.center.y)
        xFromCenter += translation.x
        var scale = min(100 / abs(xFromCenter), 1)
        gesture.setTranslation(CGPointZero, inView: self.view)
        var rotation: CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter / 200)
        var stretch: CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        label.transform = stretch
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            if self.currentEntry <= self.entries.count {
                
                if label.center.x < 100 {
                    println("Left")
                    if self.currentEntry < self.entries.count {
                        label.removeFromSuperview()
                        self.currentEntry++
                        getEntryLabel(self.entries[self.currentEntry - 1].getText())
                        self.xFromCenter = 0
                    } else {
                        label.removeFromSuperview()
                        getEntryLabel(self.entries[self.currentEntry - 1].getText())
                        self.xFromCenter = 0
                    }
                } else if label.center.x > self.view.bounds.width - 100 {
                    println("Right")
                    if self.currentEntry > 1 {
                        label.removeFromSuperview()
                        self.currentEntry--
                        getEntryLabel(self.entries[self.currentEntry - 1].getText())
                        self.xFromCenter = 0
                    } else {
                        label.removeFromSuperview()
                        getEntryLabel(self.entries[self.currentEntry - 1].getText())
                        self.xFromCenter = 0
                    }
                }
            } else {
                label.removeFromSuperview()
                getEntryLabel(self.entries[self.currentEntry - 1].getText())
                self.xFromCenter = 0
            }
        }
    }
    
    
    func getEntryLabel(text: String) {
        // User picture
        var userPic: UIImageView = UIImageView(frame: CGRectMake(self.view.frame.width / 2 - 50, self.view.frame.height / 6, 100, 100))
        userPic.image = self.entries[self.currentEntry - 1].getImage()
        userPic.layer.cornerRadius = 50
        userPic.clipsToBounds = true
        userPic.contentMode = UIViewContentMode.ScaleAspectFill
        // Entry view
        var entryView: UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        entryView.backgroundColor = UIColor(red: 0.297, green: 0.848, blue: 0.391, alpha: 1)
        // Entry label
        var entryLabel: UILabel = UILabel(frame: CGRectMake(self.view.frame.width / 8, self.view.frame.height / 3, 6 * self.view.frame.width / 8, self.view.frame.height / 2))
        entryLabel.numberOfLines = 0
        entryLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        entryLabel.font = UIFont(name: "STHeitiSC-Medium", size: 25)
        entryLabel.textAlignment = NSTextAlignment.Center
        entryLabel.textColor = UIColor.whiteColor()
        entryLabel.text = self.entries[self.currentEntry - 1].getText()
        // Help button
        var helpButton: UIButton = UIButton(frame: CGRectMake(self.view.frame.width / 2 - 30, self.view.frame.height - self.view.frame.width / 12 - 60, 60, 60))
        var tickImg: UIImage = UIImage()
        if self.entries[self.currentEntry - 1].getStatus() == 0 {
            tickImg = UIImage(named: "round68.png")!
        } else {
            tickImg = UIImage(named: "circle108.png")!
        }
        helpButton.setImage(tickImg, forState: UIControlState.Normal)
        helpButton.layer.cornerRadius = 30
        helpButton.clipsToBounds = true
        helpButton.contentMode = UIViewContentMode.ScaleAspectFill
        helpButton.addTarget(self, action: "helpButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        entryView.addSubview(userPic)
        entryView.addSubview(entryLabel)
        entryView.addSubview(helpButton)
        self.view.addSubview(entryView)
        var gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        entryView.addGestureRecognizer(gesture)
        entryView.userInteractionEnabled = true
    }
    
    func helpButtonPressed(button: UIButton){
        var entryId = self.entries[currentEntry - 1].getId()
        var entry = PFObject(withoutDataWithClassName: "Entry", objectId: entryId)
        entry.setObject(1, forKey: "status")
        entry.setObject(self.profilePicData, forKey: "helperImage")
        entry.setObject(PFUser.currentUser().objectId, forKey: "helperId")
        entry.save()
        self.entries[currentEntry - 1].setStatus(1)
        var helperImg = UIImage(data: profilePicData as NSData)
        self.entries[currentEntry - 1].setHelperImg(helperImg!)
        self.entries[currentEntry - 1].setHelperId(PFUser.currentUser().objectId)
        var selectedImg = UIImage(named: "circle108.png")
        button.setImage(selectedImg, forState: .Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(red: 0.996, green: 0.797, blue: 0, alpha: 1)
        
        PFGeoPoint.geoPointForCurrentLocationInBackground({
            (geopoint: PFGeoPoint!, error: NSError!) -> Void in
            
            if error == nil {
                println(geopoint)

                var getNearbyUsers = PFUser.query()
                getNearbyUsers.whereKey("location", nearGeoPoint: geopoint)
                //getNearbyUsers.whereKey("username", notEqualTo: PFUser.currentUser().username)
                getNearbyUsers.limit = 1000
                getNearbyUsers.findObjectsInBackgroundWithBlock({
                    (users, error) -> Void in
                    for user in users {
                        self.nearbyUsers.append(user.objectId)
                    }
                    
                    var getEntries = PFQuery(className: "Entry")
                    getEntries.whereKey("userId", containedIn: self.nearbyUsers)
                    getEntries.whereKey("status", equalTo: 0)
                    getEntries.orderByDescending("createdAt")
                    getEntries.limit = 100
                    getEntries.findObjectsInBackgroundWithBlock({
                        (objects: [AnyObject]!, error: NSError!) -> Void in
                        for object in objects {
                            var image = UIImage(data: object["userImage"] as NSData)!
                            var entry = Entry(objectId: object.objectId as String, text: object["entryText"] as String, userId: object["userId"] as String, image: image, status: object["status"] as Int)
                            self.entries.append(entry)
                        }
                        
                        if self.entries.count > 0 {
                            self.getEntryLabel(self.entries[0].getText())
                        } else {
                            var label: UILabel = UILabel(frame: CGRectMake(self.view.frame.width / 2 - 125, self.view.frame.height / 2 - 150, 250, 300))
                            label.numberOfLines = 0
                            label.lineBreakMode = NSLineBreakMode.ByWordWrapping
                            label.font = UIFont(name: "STHeitiSC-Medium", size: 25)
                            label.textAlignment = NSTextAlignment.Center
                            label.textColor = UIColor.whiteColor()
                            label.text = "With gracious people like you, everyone's having their needs answered. Please wait a while longer."
                            self.view.addSubview(label)
                        }
                    })

                })
                
            } else {
                println(error.localizedDescription)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}