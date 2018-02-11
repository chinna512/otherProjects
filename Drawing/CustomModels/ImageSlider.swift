//
//  ImageSlider.swift
//  Drawing
//
//  Created by Chinnababu on 2/8/18.
//  Copyright © 2018 Chinnababu. All rights reserved.
//

import UIKit

class ImageSlider: UIView {

    @IBOutlet weak var slider: UISlider!
    var valueChangeHandler:((_ value:Int) ->Void)?

    @IBAction func sliderAction(_ sender: UISlider) {
        valueChangeHandler!(Int(sender.value))
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ImageSlider", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ImageSlider
    }
}
