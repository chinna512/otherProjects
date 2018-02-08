//
//  ViewController.swift
//  Drawing
//
//  Created by Chinnababu on 2/8/18.
//  Copyright © 2018 Chinnababu. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var leftEyeView: TouchDrawView!
    @IBOutlet weak var collectionView: UICollectionView!
    var dragImagesArray :[UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        dragImagesArray.append(UIImage(named: "Hore Shoe Tear")!)
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        self.collectionView.dragDelegate = self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        leftEyeView.addInteraction(UIDropInteraction(delegate: self))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        return cell
    }
}
    
extension ViewController:UICollectionViewDragDelegate{
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]{
        let item = self.dragImagesArray[0]
        let itemProvider = NSItemProvider(object: item as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}
extension ViewController:UIDropInteractionDelegate{

    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
     return true
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: view)
        let operation: UIDropOperation
        if self.leftEyeView.frame.contains(dropLocation) {
            operation = session.localDragSession == nil ? .copy : .move
        } else {
            operation = .cancel
        }
        return UIDropProposal(operation: operation)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self) { imageItems in
            let images = imageItems as! [UIImage]
            let dropLocation = session.location(in: self.leftEyeView)
            let image = images.first
            let imageview = AADraggableView(image: image)
            imageview.isUserInteractionEnabled = true
            imageview.frame.origin.x = dropLocation.x
            imageview.frame.origin.y = dropLocation.y
            imageview.delegate = self
            imageview.respectedView = self.leftEyeView
            imageview.reposition = .sticky
            self.leftEyeView.addSubview(imageview)
        }
    }
}

extension ViewController: AADraggableViewDelegate {
    internal func draggingDidBegan(_ sender: UIImageView) {
        sender.layer.zPosition = 1
        sender.layer.shadowOffset = CGSize(width: 0, height: 20)
        sender.layer.shadowOpacity = 0.3
        sender.layer.shadowRadius = 6
    }
    
    internal func draggingDidEnd(_ sender: UIImageView) {
        sender.layer.zPosition = 0
        sender.layer.shadowOffset = CGSize.zero
        sender.layer.shadowOpacity = 0.0
        sender.layer.shadowRadius = 0
    }
}

