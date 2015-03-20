 //
//  TakeTableViewController.swift
//  Tackboard
//
//  Created by Wu Wenqi on 24/1/15.
//  Copyright (c) 2015 Wenqi. All rights reserved.
//

 import UIKit
 
 class ReceiveTableViewController: UITableViewController {
    
    var entryCell: UITableViewCell = UITableViewCell()
    var entryField: UITextField = UITextField()
    var submitCell: UITableViewCell = UITableViewCell()
    var profilePicData: NSData = NSData()
    var overlay: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0: return self.entryCell
        case 1: return self.submitCell
        default: fatalError("Unknown cell.")
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1{
            if entryField.text == "" {
                alertUser(self, "Your message field is empty.", "Type in something!")
            } else {
                self.view.endEditing(true)
                UIApplication.sharedApplication().keyWindow?.addSubview(self.overlay)
                self.activityIndicator.startAnimating()
                UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                
                var user = PFUser.currentUser()
                var points = user["points"] as NSInteger
                user["points"] = points - 1
                user.save()
                
                var entry = PFObject(className: "Entry")
                entry["userId"] = PFUser.currentUser().objectId
                entry["entryText"] = entryField.text
                entry["userImage"] = profilePicData
                entry["status"] = 0
                entry.saveInBackgroundWithBlock({
                    (success: Bool!, error: NSError!) -> Void in
                    if error == nil {
                        self.entryField.text = ""
                        self.overlay.removeFromSuperview()
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        alertUser(self, "Success", "You have posted successfully on the Universal Tactboard.")
                    } else {
                        self.entryField.text = ""
                        self.overlay.removeFromSuperview()
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        alertUser(self, "Oops something went wrong.", error.localizedDescription)
                    }
                })
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row{
        case 0: return 50
        case 1: return 150
        default: return 50
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    override func loadView() {
        super.loadView()
        
        self.entryCell.selectionStyle = UITableViewCellSelectionStyle.None
        self.entryField = UITextField(frame: CGRectInset(self.entryCell.contentView.bounds, 15, 0))
        self.entryField.placeholder = "Tell people what you need!"
        self.entryCell.addSubview(self.entryField)
        
        self.submitCell.selectionStyle = UITableViewCellSelectionStyle.None
        self.submitCell.textLabel?.text = "Post on the Universal Tactboard"
        self.submitCell.backgroundColor = UIColor(red: 0.297, green: 0.848, blue: 0.391, alpha: 1)
        self.submitCell.textLabel?.textColor = UIColor.whiteColor()
        self.submitCell.textLabel?.font = UIFont(name: "STHeitiSC-Medium", size: 30)
        self.submitCell.textLabel?.textAlignment = NSTextAlignment.Center
        self.submitCell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.submitCell.textLabel?.numberOfLines = 0
        
        self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        
        self.overlay = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        self.overlay.backgroundColor = UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 0.8)
        self.overlay.addSubview(activityIndicator)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(red: 0.996, green: 0.797, blue: 0, alpha: 1)
        
        // Remove the annoying table cell separators.
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
 }