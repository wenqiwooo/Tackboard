//
//  UpdatesTableViewController.swift
//  Tackboard
//
//  Created by Wu Wenqi on 25/1/15.
//  Copyright (c) 2015 Wenqi. All rights reserved.
//

import UIKit

class UpdatesViewController: UIViewController {
    
    var entries = [Entry]()
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
            label.removeFromSuperview()
            
            if self.currentEntry <= self.entries.count {
                
                if label.center.x < 100 {
                    println("Left")
                    if self.currentEntry < self.entries.count {
                        self.currentEntry++
                    }
                } else if label.center.x > self.view.bounds.width - 100 {
                    println("Right")
                    if self.currentEntry > 1 {
                        self.currentEntry--
                    }
                }
            }
            
            getEntryLabel(self.entries[self.currentEntry - 1].getText())
            self.xFromCenter = 0
        }
    }

    
    func getEntryLabel(text: String) {
        // User picture
        var userPic: UIImageView = UIImageView(frame: CGRectMake(self.view.frame.width / 2 - 50, self.view.frame.height / 6, 100, 100))
        userPic.image = self.entries[self.currentEntry - 1].getHelperImg()
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
        entryLabel.font = UIFont(name: "STHeitiSC-Medium", size: 30)
        entryLabel.textAlignment = NSTextAlignment.Center
        entryLabel.textColor = UIColor.whiteColor()
        entryLabel.text = self.entries[self.currentEntry - 1].getText()
        // Approve button
        var approveButton: UIButton = UIButton(frame: CGRectMake(self.view.frame.width / 2 - 30, self.view.frame.height - self.view.frame.width / 12 - 60, 60, 60))
        var heartImg = UIImage(named: "heart64.png")
        approveButton.setImage(heartImg, forState: UIControlState.Normal)
        approveButton.layer.cornerRadius = 30
        approveButton.clipsToBounds = true
        approveButton.contentMode = UIViewContentMode.ScaleAspectFill
        approveButton.addTarget(self, action: "approveButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        // Add subviews
        entryView.addSubview(userPic)
        entryView.addSubview(entryLabel)
        entryView.addSubview(approveButton)
        self.view.addSubview(entryView)
        var gesture = UIPanGestureRecognizer(target: self, action: Selector("dragged:"))
        entryView.addGestureRecognizer(gesture)
        entryView.userInteractionEnabled = true
    }
    
    func approveButtonPressed(button: UIButton){
        var entryId = self.entries[currentEntry - 1].getId()
        var approvedImg = UIImage(named: "favorite21.png")
        button.setImage(approvedImg, forState: UIControlState.Normal)
        var entry = PFObject(withoutDataWithClassName: "Entry", objectId: entryId)
        entry.delete()
        entry.save()
        var getHelper = PFUser.query()
        getHelper.whereKey("objectId", equalTo: self.entries[currentEntry - 1].getHelperId())
        button.superview?.removeFromSuperview()
        var helper = getHelper.getFirstObject()
        var x = helper["points"] as Int
        helper["points"] = x + 1
        helper.save()
        entries.removeAtIndex(currentEntry - 1)
        if entries.count == currentEntry  {
            if currentEntry == 1 {
                getEntryLabel(self.entries[currentEntry - 1].getText())
            } else {
                currentEntry--
                getEntryLabel(self.entries[currentEntry - 1].getText())
            }
        } else {
            if entries.count == 0 {
                var label: UILabel = UILabel(frame: CGRectMake(self.view.frame.width / 2 - 125, self.view.frame.height / 2 - 150, 250, 300))
                label.numberOfLines = 0
                label.lineBreakMode = NSLineBreakMode.ByWordWrapping
                label.font = UIFont(name: "STHeitiSC-Medium", size: 25)
                label.textAlignment = NSTextAlignment.Center
                label.textColor = UIColor.whiteColor()
                label.text = "Graciousness is all around you. Please wait a while longer."
                self.view.addSubview(label)
            } else if currentEntry == 1 {
                getEntryLabel(self.entries[currentEntry - 1].getText())
            } else {
                currentEntry--
                getEntryLabel(self.entries[currentEntry - 1].getText())
            }
        }
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(red: 0.996, green: 0.797, blue: 0, alpha: 1)
        
        var getEntries = PFQuery(className: "Entry")
        getEntries.whereKey("userId", equalTo: PFUser.currentUser().objectId)
        getEntries.whereKey("status", equalTo: 1)
        getEntries.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    var image = UIImage(data: object["userImage"] as NSData)!
                    var entry = Entry(objectId: object.objectId as String, text: object["entryText"] as String, userId: object["userId"] as String, image: image, status: object["status"] as Int)
                    var helperImg = UIImage(data: object["helperImage"] as NSData)!
                    entry.setHelperImg(helperImg)
                    entry.setHelperId(object["helperId"] as String)
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
                    label.text = "Graciousness is all around you. Please wait a while longer."
                    self.view.addSubview(label)
                }
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