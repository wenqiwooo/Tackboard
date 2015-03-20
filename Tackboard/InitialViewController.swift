//
//  InitialViewController.swift
//  Tackboard
//
//  Created by Wu Wenqi on 24/1/15.
//  Copyright (c) 2015 Wenqi. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    var background: UIView = UIView()
    var backgroundImg: UIImageView = UIImageView()
    
    // Function to make long button
    func makeLongButton(y: CGFloat, title: String, onClickAction: Selector) {
        let buttonLength: CGFloat = 260.0
        var button: UIButton = UIButton(frame: CGRectMake((self.view.bounds.size.width - buttonLength) / 2, y, buttonLength, 50))
        button.titleLabel?.font = UIFont(name: "STHeitiSC-Medium", size: 20)
        button.setTitle(title, forState: UIControlState.Normal)
        button.backgroundColor = UIColor(red: 0.297, green: 0.848, blue: 0.391, alpha: 1)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.addTarget(self, action: onClickAction, forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    // Function to make the title
    func makeTitle(titleString: String){
        var title: UILabel = UILabel(frame: CGRectMake(30, self.view.bounds.size.height / 5, self.view.bounds.size.width - 60, 200))
        title.lineBreakMode = NSLineBreakMode.ByWordWrapping
        title.numberOfLines = 0
        title.textAlignment = NSTextAlignment.Center
        title.font = UIFont(name: "STHeitiSC-Medium", size: 30)
        title.textColor = UIColor.whiteColor()
        title.text = titleString
        self.view.addSubview(title)
    }
    
    // Facebook sign in function
    func facebookSignIn() {
        var permissions = ["public_profile", "email"]
        PFFacebookUtils.logInWithPermissions(permissions, block: {(user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                if error != nil {
                    println(error)
                }
            } else if user.isNew {
                user["points"] = 10
                user.save()
                self.performSegueWithIdentifier("InitialJumpToMain", sender: self)
            } else {
                self.performSegueWithIdentifier("InitialJumpToMain", sender: self)
            }
        })
    }
    
    override func loadView() {
        super.loadView()
        
//        background = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
//        var gradient: CAGradientLayer = CAGradientLayer()
//        gradient.frame = background.bounds
//        gradient.colors = [UIColor(red: 0.290, green: 0.290, blue: 0.290, alpha: 1), UIColor(red: 0.168, green: 0.168, blue: 0.168, alpha: 1)]
//        background.layer.insertSublayer(gradient, atIndex: 0)
//        self.view.backgroundColor = UIColor.clearColor()
//        self.view.addSubview(background)
        
        self.backgroundImg = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        self.backgroundImg.contentMode = UIViewContentMode.ScaleToFill
        self.backgroundImg.image = UIImage(named: "city.jpg")
        self.view.addSubview(backgroundImg)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.view.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
        
        
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("InitialJumpToMain", sender: self)
        }
        
        // Title Setup
        makeTitle("THE UNIVERSAL TACTBOARD")
        
        // Make Facebook sign in button
        makeLongButton(self.view.bounds.size.height * 3 / 5, title: "Sign in with Facebook", onClickAction: "facebookSignIn")
    }
    
    
    override func viewWillAppear(animated: Bool) {

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}