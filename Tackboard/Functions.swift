//
//  Functions.swift
//  Tackboard
//
//  Created by Wu Wenqi on 24/1/15.
//  Copyright (c) 2015 Wenqi. All rights reserved.
//

import UIKit

func alertUser(userViewController: UIViewController, title: String, message: String){
    
    var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {action in
        userViewController.dismissViewControllerAnimated(true, completion: nil)
    }))
    
    userViewController.presentViewController(alert, animated: true, completion: nil)
    
}
