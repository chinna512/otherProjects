//
//  CustomScrollView.swift
//  EXampleChart
//
//  Created by Chinnababu on 6/27/18.
//  Copyright © 2018 Chinnababu. All rights reserved.
//

import UIKit
protocol PassTouchesScrollViewDelegate {
    func scrollTouchBegan(touches: Set<NSObject>, withEvent event: UIEvent)
}

class CustomScrollView: UIScrollView {
    var delegatePass : PassTouchesScrollViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
        self.delegatePass?.scrollTouchBegan(touches: touches, withEvent: event!)
        print("touchesBegan")
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesMoved(touches, with: event)
        self.delegatePass?.scrollTouchBegan(touches: touches, withEvent: event!)

        print("touchesMoved")
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesEnded(touches, with: event)
        print("touchesEnded")
    }
    
    
}
