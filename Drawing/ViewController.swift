//
//  ViewController.swift
//  Drawing
//
//  Created by Chinnababu on 2/8/18.
//  Copyright © 2018 Chinnababu. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var leftEyeView: TouchDrawView!
    @IBOutlet weak var collectionView: UICollectionView!
    var dragImagesArray :[UIImage] = []
    var selectedImageView:AADraggableView?
    var isSliderShown = false
    var imageSlider:ImageSlider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dragImagesArray.append(UIImage(named: "Dot Haemorrhage")!)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let image = UIImageView(image: UIImage(named: "Cotton Wool Spot"))
        self.leftImageView.addSubview(image)
       // self.leftImageView.sendSubview(toBack: image)
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
            imageview.respectedView = self.leftImageView
            imageview.reposition = .sticky
            imageview.padding = 0
            imageview.setupTapGesture()
            let tapGesture =   UITapGestureRecognizer(target: self,
                                                      action: #selector(self.tapGestureHandler(_:)))
            self.leftImageView.addSubview(imageview)
            imageview.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func tapGestureHandler(_ sender: UITapGestureRecognizer) {
        if !isSliderShown{
            imageSlider = ImageSlider.instanceFromNib() as? ImageSlider
            imageSlider?.frame = self.collectionView.frame
            imageSlider?.autoresizingMask = [.flexibleWidth]
            imageSlider?.valueChangeHandler = valueChangeHandler()
            self.view.addSubview(imageSlider!)
            selectedImageView = sender.view as? AADraggableView
            imageSlider?.slider.value = Float((selectedImageView?.lastZoomedValue)!)
        }else{
            imageSlider?.removeFromSuperview()
        }
        isSliderShown = !isSliderShown
        self.collectionView.isHidden = !self.collectionView.isHidden
    }
    
    func valueChangeHandler() -> (_ value:Int) -> Void {
        let valueChangeHandler:((_  value:Int) -> Void) = {
            value in
            DispatchQueue.main.async {
                self.selectedImageView?.transform = CGAffineTransform(scaleX: CGFloat(value/10), y: CGFloat(value/10))
                print("chinna",self.selectedImageView?.frame)
                self.selectedImageView?.lastZoomedValue = value
            }
        }
        return valueChangeHandler
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

