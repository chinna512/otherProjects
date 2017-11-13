//
//  ViewController.swift
//  ScrollImages
//
//  Created by Chinnababu on 11/10/17.
//  Copyright © 2017 Chinnababu. All rights reserved.
//

import UIKit

class ViewController: UIViewController,GalleryZoomTransitionDelegate,PaginationDelegate {

    @IBAction func start(_ sender: Any) {
//        let imageDetail = ImageDetailViewController()
//        imageDetail.presentInViewController(self)
        
        var pictures = [GalleryPicture]()
        
        for i in 1 ..< 6 {
            let image = UIImage(named: "\(i).jpg")!
            
            let picture = GalleryPicture(image: image, title: "", caption: "")
            pictures.append(picture)
        }
        
        //  let gallery = CollieGallery(pictures: pictures)
        // gallery.delegate = self
        
        
        let rootViewController = ZJMImageDetailVC(pictures: pictures)
         rootViewController.delegate = self
        rootViewController.currentPageIndex = 3
        let navController = UINavigationController(rootViewController: rootViewController)
        self.present(navController, animated:true, completion: nil)
        //  self.navigationController
        
        //  gallery.presentInViewController(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func zoomTransitionContainerBounds() -> CGRect {
        return self.view.frame
    }
    
    func zoomTransitionViewToDismissForIndex(_ index: Int) -> UIView? {
        return UIView()
    }
    
    func gallery(_ gallery: ZJMImageDetailVC, indexChangedTo index: Int) {
        print("Index changed to: \(index)")
    }

}

