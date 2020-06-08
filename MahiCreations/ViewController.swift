//
//  ViewController.swift
//  MahiCreations
//
//  Created by k.chinnababu on 07/06/20.
//  Copyright © 2020 Mahi Info services. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var channelList:[OTTDetails] = []
    var managedObjectContext: NSManagedObjectContext? = nil
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        channelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OTTCell") as! OTTListCell
        let obj = channelList[indexPath.row]
        cell.channelTextFieldName.text = obj.channelName
        cell.endDateTextField.text = obj.endDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ADD", style: .plain, target: self, action: #selector(addNewOTT))
        self.navigationItem.title = "Channel List"
        managedObjectContext = NSManagedObjectContext.newChildContext()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @objc func addNewOTT() {
        let vc = AddDetailsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cellnib = UINib(nibName: "OTTListCell", bundle: nil)
        self.tableView.register(cellnib, forCellReuseIdentifier: "OTTCell")
        fetchChannelList()
    }
    
    func fetchChannelList() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OTTDetails")
        do {
            let results = try managedObjectContext!.fetch(fetchRequest)
            if(results.count>0) {
                channelList = (results as? [OTTDetails])!
                self.tableView.reloadData()
            }
        } catch let error as NSError {
            // something went wrong, print the error.
            print(error.description)
        }
    }
    
    
}

