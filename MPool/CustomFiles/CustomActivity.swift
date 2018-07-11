//
//  CustomActivity.swift
//  EXampleChart
//
//  Created by Chinnababu on 7/7/18.
//  Copyright © 2018 Chinnababu. All rights reserved.
//

import UIKit

class CustomActivity: UIActivity {
    // returns activity title
    override var activityTitle: String?{
        return "LInkedin"
    }
    
    //thumbnail image for the activity
    override var activityImage: UIImage?{
        return UIImage(named: "Linkedin.png")
    }
    
    //activiyt type
    override var activityType: UIActivityType{
        return UIActivityType.postToFacebook
    }
    
    //view controller for the activity
    override var activityViewController: UIViewController?{
        
        print("user did tap on my activity")
        
        return nil
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        if activityTitle == "Linkedin"{
            print("chinna")
        }
        return true
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        print (activityType)
        if activityTitle == "Linkedin"{
            print("chinna")
        }
        
    }
    
}
