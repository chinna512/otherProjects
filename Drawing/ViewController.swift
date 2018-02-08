//
//  ViewController.swift
//  Drawing
//
//  Created by Chinnababu on 2/8/18.
//  Copyright © 2018 Chinnababu. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDragDelegate ,UICollectionViewDelegate,UICollectionViewDataSource,UIDropInteractionDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dragImagesArray :[UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        dragImagesArray.append(UIImage(named: "Dislocated IOL.png")!)
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        self.collectionView.dragDelegate = self
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        view.addInteraction(UIDropInteraction(delegate: self))

        //self.collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
       // cell.imageView.image = UIImage(named: "Dislocated IOL.png")!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
    {
        let item = self.dragImagesArray[0]
        let itemProvider = NSItemProvider(object: item as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
     return true
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: view)
     //   updateLayers(forDropLocation: dropLocation)
        
        let operation: UIDropOperation
        
        if self.view.frame.contains(dropLocation) {
            /*
             If you add in-app drag-and-drop support for the .move operation,
             you must write code to coordinate between the drag interaction
             delegate and the drop interaction delegate.
             */
            operation = session.localDragSession == nil ? .copy : .move
        } else {
            // Do not allow dropping outside of the image view.
            operation = .cancel
        }
        
        return UIDropProposal(operation: operation)
    }

    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        // Consume drag items (in this example, of type UIImage).
        session.loadObjects(ofClass: UIImage.self) { imageItems in
            let images = imageItems as! [UIImage]
            
            /*
             If you do not employ the loadObjects(ofClass:completion:) convenience
             method of the UIDropSession class, which automatically employs
             the main thread, explicitly dispatch UI work to the main thread.
             For example, you can use `DispatchQueue.main.async` method.
             */
            let dropLocation = session.location(in: self.view)

           let image = images.first
            let imageview = UIImageView(image: image)
            imageview.frame.origin.x = dropLocation.x
            imageview.frame.origin.y = dropLocation.y
        self.view.addSubview(imageview)
        }
        
        // Perform additional UI updates as needed.
        //updateLayers(forDropLocation: dropLocation)
    }
    

}

