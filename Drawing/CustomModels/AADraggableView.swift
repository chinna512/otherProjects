//
//  AADraggableView.swift
//  AADraggableView
//
//  Created by Engr. Ahsan Ali on 31/01/2017.
//  Copyright (c) 2017 AA-Creations. All rights reserved.
//


/// MARK:- AADraggableView
import UIKit
open class AADraggableView: UIImageView {
    
    /// @IBInspectable padding
    @IBInspectable open var padding: CGFloat = 0
    
    // MARK:- Delegate for touch begin and touch end
    open var delegate: AADraggableViewDelegate?
    
    /// Animation duration
    open var duration: TimeInterval = 0.1
    
    /// AADraggableView in respected view, default is UIScreen
    open var respectedView: UIView?
    
    /// Auto position after releasing the view
    open var reposition: Reposition = .sticky
    
    open var lastZoomedValue = 10
    
    open var lastTransformedValue:CGAffineTransform?
    

    /// AADraggableView dragging Enabled
    @IBInspectable open var isEnabled: Bool = true {
        didSet {
            setupTapGesture()
            setNeedsLayout()
        }
    }
    
    
    
    /// AADraggableView touch pan gesture
    var panGesture: UIPanGestureRecognizer  {
        return UIPanGestureRecognizer(target: self,
                                      action: #selector(self.touchHandler(_:)))
    }
    
    /// Drawing AADraggableView
    ///
    /// - Parameter rect: view frame
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupTapGesture()
    }
    
    /// Add or remove pan gesture as required
   public func setupTapGesture() {
        guard isEnabled else {
            removeGestureRecognizer(panGesture)
            return
        }
        addGestureRecognizer(panGesture)
    }
    
    
    
    /// View touch handling
    ///
    /// - Parameter sender: UIPanGestureRecognizer
    @objc func touchHandler(_ sender: UIPanGestureRecognizer) {
        
        sender.translateView(self)
        
        let state = sender.state

        guard state == .ended else {
            if state == .began {
                delegate?.draggingDidBegan?(self)
            }
            return
        }
        
        repositionIfNeeded()
        delegate?.draggingDidEnd?(self)
        
    }
    
    /// Reposition the view if needed
    open func repositionIfNeeded() {

        var newCenter = self.center
        
        switch reposition {
        case .sticky:
            if let minX = repositionMinX {
                newCenter.x = minX
            }
            if let maxX = repositionMaxX {
                newCenter.x = maxX
            }
            if let minY = repositionMinY {
                newCenter.y = minY
            }
            if let maxY = repositionMaxY {
                newCenter.y = maxY
            }
            break
        case .edgesOnly:
            newCenter.x = repositionNearX
            newCenter.y = repositionNearY
            break
        case .topOnly:
            newCenter.y = minY
            break
        case .bottomOnly:
            newCenter.y = maxY
            break
        case .leftOnly:
            newCenter.x = minX
            break
        case .rightOnly:
            newCenter.x = maxX
            break
        default:
            break
        }
        let superViewFrame = self.superview?.frame
        if self.frame.origin.x < (superViewFrame?.origin.x)! {
            newCenter.x = 0 + self.frame.size.width/2 + 2
        }
        if self.frame.origin.y < (superViewFrame?.origin.y)! {
            newCenter.y = 0 +  self.frame.size.height/2 + 2
        }
        if self.frame.origin.x  + self.frame.size.width > (superViewFrame?.size.width)!{
            newCenter.x = (superViewFrame?.size.width)! - self.frame.size.width/2 - 5
        }
        if self.frame.origin.y + self.frame.size.height > (superViewFrame?.size.height)!{
            newCenter.y = (superViewFrame?.size.height)! - self.frame.size.height/2 - 5
        }
        animateToReposition(newCenter)
    }
    
    
    /// Animate view with respect to center if needed
    ///
    /// - Parameter toPoint: center point
    func animateToReposition(_ toPoint: CGPoint) {
        
        guard toPoint != self.center else {
            return
        }
        
        UIImageView.animate(withDuration: duration) {
            self.center = toPoint
        }
    }
    
}




