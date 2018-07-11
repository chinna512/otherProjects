//
//  PopOverViewController.swift
//  Jiva App
//
//  Created by chinnababu kamanuri on 20/09/16.
//  Copyright © 2016 ZeOmega Inc. All rights reserved.
//

import UIKit

@objc protocol PopOverSelection {
     @objc optional func dropDownSelectedIndex(index:Int,value:String?)
}

class PopOverViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    var showDetails:Bool = false;
    var detailsArray:NSArray?;
    var textToDisplay:String?
    var font: UIFont = UIFont.boldSystemFont(ofSize: 20)
    var tableViewWidth: CGFloat = 300
    var delegate: PopOverSelection?

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataBasedOnFlag();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    This method is used to add subview on popover display
    either textview or table view.
    */
    func loadDataBasedOnFlag(){
            self.textView.text = textToDisplay
            self.textView.font = font
            self.textView.isEditable = false;
       }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return detailsArray!.count;
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.dropDownSelectedIndex!(index: indexPath.row,value:(detailsArray?.object(at: indexPath.row))! as? String)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")! 
        cell.textLabel?.text = detailsArray!.object(at: indexPath.row) as? String;
        cell.textLabel?.textAlignment = NSTextAlignment.center;
        cell.textLabel?.font =  font
        return cell;
    }
}
