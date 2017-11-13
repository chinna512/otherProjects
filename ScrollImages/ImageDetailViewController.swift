//
//  ImageDetailViewController.swift
//  ScrollImages
//
//  Created by Chinnababu on 11/10/17.
//  Copyright © 2017 Chinnababu. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController,UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open func presentInViewController(_ sourceViewController: UIViewController ) {
        modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        sourceViewController.present(self, animated:true, completion: nil)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
