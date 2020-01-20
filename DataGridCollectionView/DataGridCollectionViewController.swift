//
//  DataGridCollectionViewController.swift
//  DataGridCollectionView
//
//  Created by chinnababu on 20/01/20.
//  Copyright © 2020 chinnababu. All rights reserved.
//

import UIKit
import Network

class DataGridCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var selectedSectionArray = NSMutableArray()
    var isEdited = false
    var dataArray = NSMutableArray()
    var gridDict = NSMutableDictionary()
    var numberOfColumns = 6
    var numberOfSections = 0
    var selectedIndex = [Int]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    let contentCellIdentifier = "ContentCellIdentifier"
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfColumns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellIdentifier,
                                                      for: indexPath) as! DataGridCellCollectionViewCell
        if indexPath.section == 0 {
            cell.backgroundColor = UIColor.gray
            
            if indexPath.row == 0 {
                cell.textLabel.text = "RowName"
                cell.reloadDataForTheCellIfEdit(isEdit: false, text: "RowName", section: indexPath.section)
            } else {
                cell.reloadDataForTheCellIfEdit(isEdit: false, text: "sectionName", section: indexPath.section)
            }
        } else {
            
            if selectedSectionArray.contains(indexPath.section) {
                if indexPath.row == 0 {
                    cell.reloadDataForTheCellIfEdit(isEdit: isEdited, text:String(indexPath.section), section: indexPath.section)
                    cell.editButton.setBackgroundImage(UIImage(imageLiteralResourceName: "SelectFilled"), for: .normal)
                    cell.backgroundColor = .green
                    
                } else {
                    let array = gridDict.object(forKey: String(indexPath.section)) as! NSMutableArray
                    cell.reloadDataForTheCellIfEdit(isEdit: false, text: array.object(at: indexPath.row) as! String, section: indexPath.section)
                    cell.backgroundColor = .green
                    
                }
            }
            else {
                if indexPath.row == 0 {
                    cell.reloadDataForTheCellIfEdit(isEdit: isEdited, text:String(indexPath.section), section: indexPath.section)
                    cell.editButton.setBackgroundImage(UIImage(imageLiteralResourceName: "Select"), for: .normal)
                    cell.backgroundColor = UIColor.gray
                    
                } else {
                    let array = gridDict.object(forKey: String(indexPath.section)) as! NSMutableArray
                    cell.reloadDataForTheCellIfEdit(isEdit: false, text: array.object(at: indexPath.row) as! String, section: indexPath.section)
                    cell.backgroundColor = UIColor.brown
                    
                }
            }
        }
        cell.textLabel.textAlignment = .center
        cell.editClosure = {
            [unowned self] index in
            self.changeBGColor(forIndex: indexPath.section)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEdited {
            changeBGColor(forIndex: indexPath.section)
        }
    }
    
    func changeBGColor(forIndex section:Int) {
        if selectedSectionArray.contains(section) {
            selectedSectionArray.remove(section)
            let cell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: section)) as! DataGridCellCollectionViewCell
            cell.backgroundColor = .gray
            cell.editButton.setBackgroundImage(UIImage(imageLiteralResourceName: "Select"), for: .normal)
            for row in 1..<numberOfColumns {
                if let cell = self.collectionView.cellForItem(at: IndexPath(row: row, section: section)) {
                    cell.backgroundColor = .brown
                }
            }
        } else {
            let cell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: section)) as! DataGridCellCollectionViewCell
            cell.editButton.setBackgroundImage(UIImage(imageLiteralResourceName: "SelectFilled"), for: .normal)
            cell.backgroundColor = .green
            selectedSectionArray.add(section)
            for row in 1..<numberOfColumns {
                if let cell = self.collectionView.cellForItem(at: IndexPath(row: row, section: section)) {
                    cell.backgroundColor = .green
                }
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        
        let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied{
                print("we are connected")
            } else {
                print("we are not connected")

            }
            
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "DataGridCellCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: contentCellIdentifier)
        
        dataArray.add("The only thing necessary for the triumph of evil is for good men to do nothing. ...")
        dataArray.add("It takes many good deeds to build a good reputation, and only one bad one to lose it.")
        dataArray.add("The ultimate tragedy is not the oppression and cruelty by the bad people but the silence over that by the good peoples.")
        dataArray.add("I object to violence because when it appears to do good, the good is only temporary; the evil it does is permanent.")
        dataArray.add("Less is only more where more is no good.")
        dataArray.add("Every man is guilty of all the good he did not do")
        
        
         dataArray.add("TestLow Hieght")
        dataArray.add("TestLow Hieght")
        dataArray.add("TestLow Hieght")
        dataArray.add("TestLow Hieght")
        dataArray.add("TestLow Hieght")
        dataArray.add("TestLow Hieght")

        
        dataArray.add("Less is only more where more is no good")
        dataArray.add("Less is only more where more is no good")
        dataArray.add("Less is only more where more is no good")
        dataArray.add("Less is only more where more is no good")
        dataArray.add("Less is only more where more is no good")
        dataArray.add("Less is only more where more is no good")

        dataArray.add("A good indignation brings out all one's powers")
        dataArray.add("Acorns were good until bread was found")
        dataArray.add("It is not good to be too free. It is not")
        dataArray.add("Nobody minds having what is too good for them.")
        dataArray.add("No man deserves to be praised for his goodness, who has it not in his power to be wicked. Goodness without that power is generally nothing more than sloth, or an impotence of will.")
        dataArray.add("The good and the wise lead quiet lives.")
        
        dataArray.add("The only thing necessary for the triumph of evil is for good men to do nothing. ...")
        dataArray.add("It takes many good deeds to build a good reputation, and only one bad one to lose it.")
        dataArray.add("The ultimate tragedy is not the oppression and cruelty by the bad people but the silence over that by the good peoples.")
        dataArray.add("I object to violence because when it appears to do good, the good is only temporary; the evil it does is permanent.")
        dataArray.add("Less is only more where more is no good.")
        dataArray.add("Every man is guilty of all the good he did not do")
        dataArray.add("A good indignation brings out all one's powers")
        dataArray.add("Acorns were good until bread was found")
        dataArray.add("It is not good to be too free. It is not")
        dataArray.add("Nobody minds having what is too good for them.")
        dataArray.add("No man deserves to be praised for his goodness, who has it not in his power to be wicked. Goodness without that power is generally nothing more than sloth, or an impotence of will.")
        dataArray.add("The good and the wise lead quiet lives.")
        
        dataArray.add("The only thing necessary for the triumph of evil is for good men to do nothing. ...")
        dataArray.add("It takes many good deeds to build a good reputation, and only one bad one to lose it.")
        dataArray.add("The ultimate tragedy is not the oppression and cruelty by the bad people but the silence over that by the good peoples.")
        dataArray.add("I object to violence because when it appears to do good, the good is only temporary; the evil it does is permanent.")
        dataArray.add("Less is only more where more is no good.")
        dataArray.add("Every man is guilty of all the good he did not do")
        dataArray.add("A good indignation brings out all one's powers")
        dataArray.add("Acorns were good until bread was found")
        dataArray.add("It is not good to be too free. It is not")
        dataArray.add("Nobody minds having what is too good for them.")
        dataArray.add("No man deserves to be praised for his goodness, who has it not in his power to be wicked. Goodness without that power is generally nothing more than sloth, or an impotence of will.")
        dataArray.add("The good and the wise lead quiet lives.")
        
        dataArray.add("The only thing necessary for the triumph of evil is for good men to do nothing. ...")
        dataArray.add("It takes many good deeds to build a good reputation, and only one bad one to lose it.")
        dataArray.add("The ultimate tragedy is not the oppression and cruelty by the bad people but the silence over that by the good peoples.")
        dataArray.add("I object to violence because when it appears to do good, the good is only temporary; the evil it does is permanent.")
        dataArray.add("Less is only more where more is no good.")
        dataArray.add("Every man is guilty of all the good he did not do")
        dataArray.add("A good indignation brings out all one's powers")
        dataArray.add("Acorns were good until bread was found")
        dataArray.add("It is not good to be too free. It is not")
        dataArray.add("Nobody minds having what is too good for them.")
        dataArray.add("No man deserves to be praised for his goodness, who has it not in his power to be wicked. Goodness without that power is generally nothing more than sloth, or an impotence of will.")
        dataArray.add("The good and the wise lead quiet lives.")
        
        dataArray.add("The only thing necessary for the triumph of evil is for good men to do nothing. ...")
        dataArray.add("It takes many good deeds to build a good reputation, and only one bad one to lose it.")
        dataArray.add("The ultimate tragedy is not the oppression and cruelty by the bad people but the silence over that by the good peoples.")
        dataArray.add("I object to violence because when it appears to do good, the good is only temporary; the evil it does is permanent.")
        dataArray.add("Less is only more where more is no good.")
        dataArray.add("Every man is guilty of all the good he did not do")
        dataArray.add("A good indignation brings out all one's powers")
        dataArray.add("Acorns were good until bread was found")
        dataArray.add("It is not good to be too free. It is not")
        dataArray.add("Nobody minds having what is too good for them.")
        dataArray.add("No man deserves to be praised for his goodness, who has it not in his power to be wicked. Goodness without that power is generally nothing more than sloth, or an impotence of will.")
        dataArray.add("The good and the wise lead quiet lives.")
        
        dataArray.add("The only thing necessary for the triumph of evil is for good men to do nothing. ...")
        dataArray.add("It takes many good deeds to build a good reputation, and only one bad one to lose it.")
        dataArray.add("The ultimate tragedy is not the oppression and cruelty by the bad people but the silence over that by the good peoples.")
        dataArray.add("I object to violence because when it appears to do good, the good is only temporary; the evil it does is permanent.")
        dataArray.add("Less is only more where more is no good.")
        dataArray.add("Every man is guilty of all the good he did not do")
        dataArray.add("A good indignation brings out all one's powers")
        dataArray.add("Acorns were good until bread was found")
        dataArray.add("It is not good to be too free. It is not")
        dataArray.add("Nobody minds having what is too good for them.")
        dataArray.add("No man deserves to be praised for his goodness, who has it not in his power to be wicked. Goodness without that power is generally nothing more than sloth, or an impotence of will.")
        dataArray.add("The good and the wise lead quiet lives.")
        
        dataArray.add("The only thing necessary for the triumph of evil is for good men to do nothing. ...")
        dataArray.add("It takes many good deeds to build a good reputation, and only one bad one to lose it.")
        dataArray.add("The ultimate tragedy is not the oppression and cruelty by the bad people but the silence over that by the good peoples.")
        dataArray.add("I object to violence because when it appears to do good, the good is only temporary; the evil it does is permanent.")
        dataArray.add("Less is only more where more is no good.")
        dataArray.add("Every man is guilty of all the good he did not do")
        dataArray.add("A good indignation brings out all one's powers")
        dataArray.add("Acorns were good until bread was found")
        dataArray.add("It is not good to be too free. It is not")
        dataArray.add("Nobody minds having what is too good for them.")
        dataArray.add("No man deserves to be praised for his goodness, who has it not in his power to be wicked. Goodness without that power is generally nothing more than sloth, or an impotence of will.")
        dataArray.add("The good and the wise lead quiet lives.")
        
        
        dataArray.add("The only thing necessary for the triumph of evil is for good men to do nothing. ...")
        dataArray.add("It takes many good deeds to build a good reputation, and only one bad one to lose it.")
        dataArray.add("The ultimate tragedy is not the oppression and cruelty by the bad people but the silence over that by the good peoples.")
        dataArray.add("I object to violence because when it appears to do good, the good is only temporary; the evil it does is permanent.")
        dataArray.add("Less is only more where more is no good.")
        dataArray.add("Every man is guilty of all the good he did not do")
        dataArray.add("A good indignation brings out all one's powers")
        dataArray.add("Acorns were good until bread was found")
        dataArray.add("It is not good to be too free. It is not")
        dataArray.add("Nobody minds having what is too good for them.")
        dataArray.add("No man deserves to be praised for his goodness, who has it not in his power to be wicked. Goodness without that power is generally nothing more than sloth, or an impotence of will.")
        dataArray.add("The good and the wise lead quiet lives.")
        
        dataArray.add("The only thing necessary for the triumph of evil is for good men to do nothing. ...")
        dataArray.add("It takes many good deeds to build a good reputation, and only one bad one to lose it.")
        dataArray.add("The ultimate tragedy is not the oppression and cruelty by the bad people but the silence over that by the good peoples.")
        dataArray.add("I object to violence because when it appears to do good, the good is only temporary; the evil it does is permanent.")
        dataArray.add("Less is only more where more is no good.")
        dataArray.add("Every man is guilty of all the good he did not do")
        dataArray.add("A good indignation brings out all one's powers")
        dataArray.add("Acorns were good until bread was found")
        dataArray.add("It is not good to be too free. It is not")
        dataArray.add("Nobody minds having what is too good for them.")
        dataArray.add("No man deserves to be praised for his goodness, who has it not in his power to be wicked. Goodness without that power is generally nothing more than sloth, or an impotence of will.")
        dataArray.add("The good and the wise lead quiet lives.")
        
        dataArray.add("The only thing necessary for the triumph of evil is for good men to do nothing. ...")
        dataArray.add("It takes many good deeds to build a good reputation, and only one bad one to lose it.")
        dataArray.add("The ultimate tragedy is not the oppression and cruelty by the bad people but the silence over that by the good peoples.")
        dataArray.add("I object to violence because when it appears to do good, the good is only temporary; the evil it does is permanent.")
        dataArray.add("Less is only more where more is no good.")
        dataArray.add("Every man is guilty of all the good he did not do")
        dataArray.add("A good indignation brings out all one's powers")
        dataArray.add("Acorns were good until bread was found")
        dataArray.add("It is not good to be too free. It is not")
        dataArray.add("Nobody minds having what is too good for them.")
        dataArray.add("No man deserves to be praised for his goodness, who has it not in his power to be wicked. Goodness without that power is generally nothing more than sloth, or an impotence of will.")
        dataArray.add("The good and the wise lead quiet lives.")
        
        dataArray.add("The only thing necessary for the triumph of evil is for good men to do nothing. ...")
        dataArray.add("It takes many good deeds to build a good reputation, and only one bad one to lose it.")
        dataArray.add("The ultimate tragedy is not the oppression and cruelty by the bad people but the silence over that by the good peoples.")
        dataArray.add("I object to violence because when it appears to do good, the good is only temporary; the evil it does is permanent.")
        dataArray.add("Less is only more where more is no good.")
        dataArray.add("Every man is guilty of all the good he did not do")
        dataArray.add("A good indignation brings out all one's powers")
        dataArray.add("Acorns were good until bread was found")
        dataArray.add("It is not good to be too free. It is not")
        dataArray.add("Nobody minds having what is too good for them.")
        dataArray.add("No man deserves to be praised for his goodness, who has it not in his power to be wicked. Goodness without that power is generally nothing more than sloth, or an impotence of will.")
        dataArray.add("The good and the wise lead quiet lives.")
        
        dataArray.add("The only thing necessary for the triumph of evil is for good men to do nothing. ...")
        dataArray.add("It takes many good deeds to build a good reputation, and only one bad one to lose it.")
        dataArray.add("The ultimate tragedy is not the oppression and cruelty by the bad people but the silence over that by the good peoples.")
        dataArray.add("I object to violence because when it appears to do good, the good is only temporary; the evil it does is permanent.")
        dataArray.add("Less is only more where more is no good.")
        dataArray.add("Every man is guilty of all the good he did not do")
        dataArray.add("A good indignation brings out all one's powers")
        dataArray.add("Acorns were good until bread was found")
        dataArray.add("It is not good to be too free. It is not")
        dataArray.add("Nobody minds having what is too good for them.")
        dataArray.add("No man deserves to be praised for his goodness, who has it not in his power to be wicked. Goodness without that power is generally nothing more than sloth, or an impotence of will.")
        dataArray.add("The good and the wise lead quiet lives.")
        
        dataArray.add("The only thing necessary for the triumph of evil is for good men to do nothing. ...")
        dataArray.add("It takes many good deeds to build a good reputation, and only one bad one to lose it.")
        dataArray.add("The ultimate tragedy is not the oppression and cruelty by the bad people but the silence over that by the good peoples.")
        dataArray.add("I object to violence because when it appears to do good, the good is only temporary; the evil it does is permanent.")
        dataArray.add("Less is only more where more is no good.")
        dataArray.add("Every man is guilty of all the good he did not do")
        dataArray.add("A good indignation brings out all one's powers")
        dataArray.add("Acorns were good until bread was found")
        dataArray.add("It is not good to be too free. It is not")
        dataArray.add("Nobody minds having what is too good for them.")
        dataArray.add("No man deserves to be praised for his goodness, who has it not in his power to be wicked. Goodness without that power is generally nothing more than sloth, or an impotence of will.")
        dataArray.add("The good and the wise lead quiet lives.")
        
        dataArray.add("The only thing necessary for the triumph of evil is for good men to do nothing. ...")
        dataArray.add("It takes many good deeds to build a good reputation, and only one bad one to lose it.")
        dataArray.add("The ultimate tragedy is not the oppression and cruelty by the bad people but the silence over that by the good peoples.")
        dataArray.add("I object to violence because when it appears to do good, the good is only temporary; the evil it does is permanent.")
        dataArray.add("Less is only more where more is no good.")
        dataArray.add("Every man is guilty of all the good he did not do")
        dataArray.add("A good indignation brings out all one's powers")
        dataArray.add("Acorns were good until bread was found")
        dataArray.add("It is not good to be too free. It is not")
        dataArray.add("Nobody minds having what is too good for them.")
        dataArray.add("No man deserves to be praised for his goodness, who has it not in his power to be wicked. Goodness without that power is generally nothing more than sloth, or an impotence of will.")
        dataArray.add("The good and the wise lead quiet lives.")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareGridItems()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.bounces = false
        let barButtonItem  =  UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(touchAtSearchIcon(_:)))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func touchAtSearchIcon(_ sender: Any) {
        if isEdited {
            isEdited = false
            self.selectedSectionArray.removeAllObjects()
            self.collectionView.reloadData()
        }
        else {
            isEdited = true
            DispatchQueue.main.async {
                self.collectionView.reloadData()
             }
        }
    }
    
    func prepareGridItems() {
        numberOfSections = (dataArray.count/numberOfColumns) + 1
        var k = 0
        for i in 1..<numberOfSections {
            let tempArray = NSMutableArray()
            for _ in 0..<numberOfColumns {
                tempArray.add(dataArray.object(at: k))
                k += 1
            }
            gridDict.setValue(tempArray , forKeyPath: String(i))
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
      //  self.collectionView.layoutSubviews()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
