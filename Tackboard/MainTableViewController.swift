//
//  MainTableViewController.swift
//  Tackboard
//
//  Created by Wu Wenqi on 24/1/15.
//  Copyright (c) 2015 Wenqi. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var giveCell: UITableViewCell = UITableViewCell()
    var takeCell: UITableViewCell = UITableViewCell()
    var profileCell: UITableViewCell = UITableViewCell()
    var profilePic: UIImageView = UIImageView()
    var profilePicData: NSData = NSData()
    var pointsLabel: UILabel = UILabel()
    var points = 0
    var updateCell: UITableViewCell = UITableViewCell()
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return self.profileCell
        case 1: return self.takeCell
        case 2: return self.giveCell
        case 3: return self.updateCell
        default: fatalError("Unknown cell.")
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0: println("Cell 0 selected.")
        case 1:
            if points < 1 {
                alertUser(self, "You have run out of points.", "Give to earn more points.")
            } else {
                self.performSegueWithIdentifier("MainJumpToReceive", sender: self)
            }
        case 2: self.performSegueWithIdentifier("MainJumpToGive", sender: self)
        case 3: self.performSegueWithIdentifier("MainJumpToUpdates", sender: self)
        default: fatalError("Unknown cell.")
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MainJumpToReceive" {
            var destinationController: ReceiveTableViewController = segue.destinationViewController as ReceiveTableViewController
            destinationController.profilePicData = self.profilePicData
        } else if segue.identifier == "MainJumpToGive" {
            var destinationController: GiveViewController = segue.destinationViewController as GiveViewController
            destinationController.profilePicData = self.profilePicData
        }
    }
    
    override func loadView() {
        super.loadView()
        
        self.giveCell.selectionStyle = UITableViewCellSelectionStyle.None
        self.giveCell.textLabel?.text = "GIVE (+1)"
        self.giveCell.textLabel?.textColor = UIColor.whiteColor()
        self.giveCell.textLabel?.font = UIFont(name: "STHeitiSC-Medium", size: 30)
        self.giveCell.backgroundColor = UIColor(red: 0.996, green: 0.227, blue: 0.176, alpha: 1)
        var giveCellIcon = UIImageView(frame: CGRectMake(5.5 * self.view.bounds.size.width / 8, 40, 60, 60))
        giveCellIcon.image = UIImage(named: "gift41.png")
        self.giveCell.addSubview(giveCellIcon)
        
        self.takeCell.selectionStyle = UITableViewCellSelectionStyle.None
        self.takeCell.textLabel?.text = "RECEIVE (-1)"
        self.takeCell.textLabel?.textColor = UIColor.whiteColor()
        self.takeCell.textLabel?.font = UIFont(name: "STHeitiSC-Medium", size: 30)
        self.takeCell.backgroundColor = UIColor(red: 0.996, green: 0.797, blue: 0, alpha: 1)
        var takeCellIcon = UIImageView(frame: CGRectMake(5.5 * self.view.bounds.size.width / 8, 40, 60, 60))
        takeCellIcon.image = UIImage(named: "box41.png")
        self.takeCell.addSubview(takeCellIcon)
        
        self.updateCell.selectionStyle = UITableViewCellSelectionStyle.None
        self.updateCell.textLabel?.text = "UPDATES"
        self.updateCell.textLabel?.textColor = UIColor.whiteColor()
        self.updateCell.textLabel?.font = UIFont(name: "STHeitiSC-Medium", size: 30)
        self.updateCell.backgroundColor = UIColor(red: 0.297, green: 0.848, blue: 0.391, alpha: 1)
        var updateCellIcon = UIImageView(frame: CGRectMake(5.5 * self.view.bounds.size.width / 8, 40, 60, 60))
        updateCellIcon.image = UIImage(named: "cloud127.png")
        self.updateCell.addSubview(updateCellIcon)

        self.pointsLabel = UILabel(frame: CGRectMake(5 * self.view.bounds.size.width / 8, 20, 60, 100))
        self.pointsLabel.textAlignment = NSTextAlignment.Center
        self.pointsLabel.font = UIFont(name: "Helvetica", size: 50)
        self.pointsLabel.textColor = UIColor.orangeColor()
        
        self.profilePic = UIImageView(frame: CGRectMake(self.view.bounds.size.width / 8, 20, 100, 100))
        self.profilePic.layer.cornerRadius = 50
        self.profilePic.clipsToBounds = true
        self.profilePic.contentMode = UIViewContentMode.ScaleAspectFill
        
        var user = PFUser.currentUser()
        self.points = user.objectForKey("points") as NSInteger
        self.pointsLabel.text = String(self.points)
        var FBSession = PFFacebookUtils.session()
        var accessToken = FBSession.accessTokenData.accessToken
        let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token=" + accessToken)
        let urlRequest = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            if error == nil && data != nil {
                let image = UIImage(data: data)
                self.profilePic.image = image
                self.profilePicData = data
                user["image"] = data
                user.save()
                
                FBRequestConnection.startForMeWithCompletionHandler({
                    connection, result, error in
                    user["gender"] = result["gender"]
                    user["name"] = result["name"]
                    user["email"] = result["email"]
                    user.save()
                })
            } else {
                println(error.localizedDescription)
            }
        })
        
        self.profileCell.selectionStyle = UITableViewCellSelectionStyle.None
        self.profileCell.addSubview(profilePic)
        self.profileCell.addSubview(pointsLabel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.203, green: 0.664, blue: 0.859, alpha: 1)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "STHeitiSC-Medium", size: 20)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // Remove the annoying table cell separators.
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        PFGeoPoint.geoPointForCurrentLocationInBackground({
            (geopoint: PFGeoPoint!, error: NSError!) -> Void in
            if error == nil {
                println(geopoint)
                var user = PFUser.currentUser()
                user["location"] = geopoint
                user.save()
            } else {
                alertUser(self, "Oops something went wrong.", error.localizedDescription)
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

