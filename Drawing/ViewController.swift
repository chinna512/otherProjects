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
    var selectedimageView:AADraggableView?
    var isSliderShown = false
    var imageSlider:ImageSlider?
    var isDrawEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dragImagesArray.append(UIImage(named: "Screen Shot 2018-02-19 at 5.00.04 PM")!)
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
        self.leftEyeView.isDrawEnabled = true
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
            DispatchQueue.main.async {
                let images = imageItems as! [UIImage]
                let dropLocation = session.location(in: self.leftEyeView)
                let image = images.first
                let imageView = AADraggableView(image: image)
                var frame = imageView.frame
                frame.size = (image?.size)!
                imageView.frame = frame
                imageView.contentMode = .scaleAspectFit
                imageView.isUserInteractionEnabled = true
                print(dropLocation)
                imageView.frame.origin.x = dropLocation.x
                imageView.frame.origin.y = dropLocation.y
                imageView.delegate = self
                imageView.respectedView = self.leftImageView
                imageView.reposition = .sticky
                imageView.padding = 0
                imageView.backgroundColor = UIColor.blue
                imageView.setupTapGesture()
                imageView.clipsToBounds = true
                let tapGesture =   UITapGestureRecognizer(target: self,
                                                          action: #selector(self.tapGestureHandler(_:)))
                self.leftImageView.addSubview(imageView)
                imageView.addGestureRecognizer(tapGesture)
                self.leftEyeView.isDrawEnabled = true
            }
        }
    }
    
    @objc func tapGestureHandler(_ sender: UITapGestureRecognizer) {
        if !isSliderShown{
            imageSlider = ImageSlider.instanceFromNib() as? ImageSlider
            imageSlider?.frame = self.collectionView.frame
            imageSlider?.autoresizingMask = [.flexibleWidth]
            imageSlider?.valueChangeHandler = valueChangeHandler()
            self.view.addSubview(imageSlider!)
            selectedimageView = sender.view as? AADraggableView
            imageSlider?.slider.value = Float((selectedimageView?.lastZoomedValue)!)
        }else{
            imageSlider?.removeFromSuperview()
        }
        isSliderShown = !isSliderShown
        self.collectionView.isHidden = !self.collectionView.isHidden
    }
    
    func valueChangeHandler() -> (_ value:Int) -> Void {
        let valueChangeHandler:((_  value:Int) -> Void) = {
            value in
            self.selectedimageView?.transform =  CGAffineTransform.identity
            print("frame",(self.selectedimageView as AnyObject).frame)
            let transform = CGAffineTransform(scaleX: CGFloat(value/10), y: CGFloat(value/10))
            self.selectedimageView?.transform = transform
            print("frame1",(self.selectedimageView as AnyObject).frame)
            if(self.validateSliderImageFrame(image:self.selectedimageView!)){
                self.selectedimageView?.transform = transform
                self.selectedimageView?.lastZoomedValue = value
                self.selectedimageView?.lastTransformedValue = transform
            }else{
                self.imageSlider?.slider.value = Float((self.selectedimageView?.lastZoomedValue)!)
                self.selectedimageView?.transform =  (self.selectedimageView?.lastTransformedValue)!
                self.selectedimageView?.transform = CGAffineTransform(scaleX: CGFloat((self.selectedimageView?.lastZoomedValue)!/10), y: CGFloat((self.selectedimageView?.lastZoomedValue)!/10))
            }
            
            //  })
        }
        return valueChangeHandler
    }
    
    func validateSliderImageFrame(image:AADraggableView) -> Bool{
        if image.frame.origin.x <= 0{
            return false
        }
        if image.frame.origin.x + image.frame.size.width >= self.leftEyeView.frame.size.width {
            return false
        }
        if image.frame.origin.y <= 0 {
            return false
        }
        if image.frame.size.height + image.frame.origin.y >= self.leftEyeView.frame.size.height{
            return false
        }
        return true
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
    extension UIImage{
        func resizeImage(targetSize: CGSize) -> UIImage {
            let size = self.size
            let widthRatio  = targetSize.width  / size.width
            let heightRatio = targetSize.height / size.height
            let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
            let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            self.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage!
        }
}

