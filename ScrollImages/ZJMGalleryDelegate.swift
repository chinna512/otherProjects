//
//  CollieGalleryDelegate.swift
//  Pods
//
//  Created by Guilherme Munhoz on 5/11/16.
//
//

import UIKit

/// Protocol to implement the gallery
@objc public protocol PaginationDelegate: class {
    
    /// Called when the gallery index changes
    @objc optional func gallery(_ gallery: ZJMImageDetailVC, indexChangedTo index: Int)
    
}

internal protocol GalleryViewDelegate {
    func galleryViewTapped(_ galleryView: GalleryView)
    func galleryViewDidZoomIn(_ galleryView: GalleryView)
    func galleryViewDidRestoreZoom(_ galleryView: GalleryView)
    func galleryViewDidEnableScroll(_ galleryView: GalleryView)
    func galleryViewDidDisableScroll(_ galleryView: GalleryView)
}

internal protocol GalleryTransitionProtocol {
    func animatePresentationWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning,
                                                  duration: TimeInterval)
    func animateDismissalWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning,
                                               duration: TimeInterval)
}

open class CollieGalleryOptions: NSObject {
    
    /// Shared options between all new instances of the gallery
    open static var sharedOptions = CollieGalleryOptions()
    
    /// The amount of the parallax effect from 0 to 1
    open var parallaxFactor: CGFloat = 0.2
    
    /// Indicates weather the pictures can be zoomed or not
    open var enableZoom: Bool = true
    
    /// The maximum scale that images can reach when zoomed
    open var maximumZoomScale: CGFloat = 5.0
    
    /// Indicates weather the progress should be displayed or not
    open var showProgress: Bool = true
    
    /// Indicates weather the caption view should be displayed or not
    open var showCaptionView: Bool = false
    
    /// The amount of pictures that should be preloaded next to the current displayed picture
    open var preLoadedImages: Int = 3
    
    /// The space between each scrollview's page
    open var gapBetweenPages: CGFloat = 10.0
    
    /// Open gallery at specified page
    open var openAtIndex: Int = 0
    
    /// Custom close button image name
    open var customCloseImageName: String? = nil
    
    /// Custom options button image name
    open var customOptionsImageName: String? = nil
    
    /// Indicates if the user should be able to save the picture
    open var enableSave: Bool = true
    
    /// Indicates if the user should be able to dismiss the gallery interactively with a pan gesture
    open var enableInteractiveDismiss: Bool = true
    
    /// Add fire custom block instead of showing default share menu
    open var customOptionsBlock: ((Void) -> Void)?
    
    /// Array with the custom buttons
    
    /// Default actions to exclude from the gallery actions (UIActivityType Constants)
    open var excludedActions: [UIActivityType] = []
}

public enum GalleryTransitionType
{
    case `default`
    case zoom(fromView: UIView, zoomTransitionDelegate: GalleryZoomTransitionDelegate)
    case none
    
    internal var transition: GalleryTransitionProtocol? {
        switch self {
        case .none:
            return nil
        case .zoom(let fromView, let zoomTransitionDelegate):
            return GalleryZoomTransition(fromView: fromView,
                                               zoomTransitionDelegate: zoomTransitionDelegate)
        default:
            return nil
        }
    }
    
    internal var animated: Bool {
        switch self {
        case .none:
            return false
        default:
            return true
        }
    }
    
    internal var fromView: UIView? {
        switch self {
        case .zoom(let fromView, _):
            return fromView
        default:
            return nil
        }
    }
    
    /// The default transition for all new instances of the gallery
    public static var defaultType = GalleryTransitionType.default
}


open class GalleryPicture: NSObject {
    
    // MARK: - Internal properties
    internal var image: UIImage!
    internal var url: String!
    internal var placeholder: UIImage?
    internal var title: String?
    internal var caption: String?
    
    
    // MARK: - Initializers
    
    /**
     
     Initializer that takes an image object
     
     - Parameters:
     - image: The image
     - title: An optional title to the image
     - caption: An optional caption to describe the image
     
     */
    public convenience init(image: UIImage, title: String? = nil, caption: String? = nil) {
        self.init()
        self.image = image
        self.title = title
        self.caption = caption
    }
    
    /**
     
     Initializer that takes a string url of a remote image
     
     - Parameters:
     - url: The remote url
     - placeholder: An optional placeholder image
     - title: An optional title to the image
     - caption: An optional caption to describe the image
     
     */
    public convenience init(url: String, placeholder: UIImage? = nil, title: String? = nil, caption: String? = nil) {
        self.init()
        self.url = url
        self.placeholder = placeholder
        self.title = title
        self.caption = caption
    }
}




