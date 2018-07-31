//
//  POPOverViewController.swift
//  POPOver
//
//  Created by Chinnababu on 7/30/18.
//  Copyright © 2018 Chinnababu. All rights reserved.
//

import UIKit

class POPOverViewController: UIViewController {

    
    @IBOutlet weak var titileLabel: UILabel!
    
    @IBOutlet weak var subTitileLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.shadowColor = UIColor.lightGray.cgColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.superview?.layer.cornerRadius = 0
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func loadDataWith(title:String,subTitile:String){

        self.titileLabel.text = title
        self.subTitileLabel.text = subTitile
        self.view.layer.borderWidth = 0.5
        self.view.layer.borderColor = UIColor.black.cgColor
        self.view.layer.cornerRadius = 0
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
