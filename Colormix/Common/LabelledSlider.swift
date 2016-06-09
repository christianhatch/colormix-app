//
//  LabelledSlider.swift
//  Colormix
//
//  Created by Christian Hatch on 6/9/16.
//  Copyright © 2016 Commodoreftp. All rights reserved.
//

import Foundation


class LabelledSlider: UIView {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    class func labelledSlider(withTitle: String? = nil) -> LabelledSlider {
        let slider = LabelledSlider.loadFromNib()
        slider.titleLabel.text = withTitle
        return slider
    }
}



extension LabelledSlider {
    
//    func setupView() {
//        let thumb = UIImage.squareImageWithColor(.blackColor(), size: CGSize(width: slider.bounds.height, height: slider.bounds.height))
//        let clear = UIImage.squareImageWithColor(.clearColor(), size: CGSize(width: slider.bounds.width, height: slider.bounds.height))
//        slider.setThumbImage(thumb, forState: .Normal)
//        slider.setMinimumTrackImage(clear, forState: .Normal)
//        slider.setMaximumTrackImage(clear, forState: .Normal)
//    }
    
}


private extension LabelledSlider {
    static var nib: UINib {
        return UINib(nibName: String(self), bundle: NSBundle(forClass: self))
    }
    static func loadFromNib() -> LabelledSlider {
        guard let view = nib.instantiateWithOwner(nil, options: nil).first as? LabelledSlider else {
            fatalError("The nib \(nib) expected its root view to be of type \(self)")
        }
        return view
    }
}