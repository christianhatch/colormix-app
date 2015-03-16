//
//  ColorPickerView.swift
//  Colormix
//
//  Created by Christian Hatch on 11/24/14.
//  Copyright (c) 2014 Commodoreftp. All rights reserved.
//

import UIKit

protocol ColorPickerViewDelegate {
    func colorPickerViewMainButtonTapped(view: ColorPickerView!)
    func colorPickerViewPickedColorDidChange(pickedColor: UIColor!, colorPickerView: ColorPickerView!)
}


let kColorPickerViewHueScale: CGFloat = 360
let kColorPickerViewSaturationBrightnessScale: CGFloat = 100
let kColorPickerViewRGBScale: CGFloat = 255


enum SliderName {
    case SliderNameHue
    case SliderNameSaturation
    case SliderNameBrightness
    case SliderNameRed
    case SliderNameGreen
    case SliderNameGreen
}




public class ColorPickerView: UIView {

    //public
    var delegate: ColorPickerViewDelegate
    var pickedColor: UIColor
    
    
    @IBOutlet weak var hsbContainer: UIView!
    @IBOutlet weak var rgbContainer: UIView!
    
    @IBOutlet weak var hueSlider: UISlider!
    @IBOutlet weak var saturationSlider: UISlider!
    @IBOutlet weak var brightnessSlider: UISlider!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!

    @IBOutlet weak var hueLabel: UILabel!
    @IBOutlet weak var brightnessLabel: UILabel!
    @IBOutlet weak var saturationLabel: UILabel!
    
    @IBOutlet weak var hexLabel: UILabel!
    
    //private
    private var saturationGradient: CAGradientLayer {
        get {
            let sat: CAGradientLayer = CAGradientLayer.layer
            sat.frame = self.saturationSlider.frame
            
            sat.startPoint = CGPointZero
            sat.endPoint = cgpointmak
            
            return sat
        }
    }
    private var brightnessGradient: CAGradientLayer
    private var hueGradient: CAGradientLayer
    
    
    //MARK: view lifecycle
    
//    required init(coder aDecoder: NSCoder) {
//        
//    }
    
    
//    init(frame: CGRect, delegate: ColorPickerViewDelegate?) {
//        self.delegate = delegate
//        self.pickedColor = UIColor.randomColor()
//        super.init(frame: frame)
//    }
//    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpUI()
        self.refreshGradients()
    }
    
    func setUpUI() {
        
    }
    
    
    //MARK: UI methods
    func rgbDidSlide() {
        
    }
    
    func hslDidSlide() {
        
    }
    
    func updateUI(animated: Bool) {
        
    }
    
    func syncSlidersToColor(animated: Bool) {
        
    }
    
    func updateLabels() {
        
    }
    
    func updateGradients() {
        
    }
    
    
    //MARK: getters
    
    func hueGradientColors() -> NSArray {
        
    }
    
    func saturationGradientColors() -> NSArray {
        
//        let satStart: UIColor = UIColor(hue: self.pickedColor.hue, saturation:0, brightness:self.pickedColor.brightness, alpha:1)
        
//        let satStart = UIColor(hue
        
    }
    
    func brightnessGradientColors() -> NSArray {
        
    }
    
    
    //MARK: private
    private func refreshGradients() {
        
        self.hueGradient.removeFromSuperlayer()
        self.saturationGradient.removeFromSuperlayer()
        self.brightnessGradient.removeFromSuperlayer()
        
        self.hueGradient = nil
        self.saturationGradient = nil
        self.brightnessGradient = nil
        
        self.hueSlider.layer.insertSublayer(self.hueGradient, 0)
        self.saturationSlider.layer.insertSublayer(self.saturationGradient, 0)
        self.brightnessSlider.layer.insertSublayer(self.brightnessGradient, 0)
    }
}



















/*
extension UIColor {
    class func randomColor() -> UIColor {
        
        let hue = drand48()
        let sat = CGFloat(arc4random() % UInt32(255)) + 0.5
        let bright = CGFloat(arc4random() % UInt32(255)) + 0.5
        
        return UIColor(hue: CGFloat(hue), saturation: CGFloat(sat), brightness: CGFloat(bright), alpha: 1)
    }
    
    
    func contrastingColor() -> UIColor {
        return self.luminance() > 0.5 ? UIColor.blackColor() : UIColor.whiteColor()
    }
    
    
    func hue() -> CGFloat {
        var hue = CGFloat()
        self.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return hue
    }
    
    func saturation() -> CGFloat {
        var sat = CGFloat()
        self.getHue(nil, saturation: &sat, brightness: nil, alpha: nil)
        return sat
    }
    
    func brightness() -> CGFloat {
        var bright = CGFloat()
        self.getHue(nil, saturation: nil, brightness: &bright, alpha: nil)
        return bright
    }

    
    func alpha() -> CGFloat {
        var a = CGFloat()
        self.getRed(nil, green: nil, blue: nil, alpha: &a)
        return a;
    }
    

    func red() -> CGFloat {
        var r = CGFloat()
        self.getRed(&r, green: nil, blue: nil, alpha: nil)
        return r;
    }
    
    func green() -> CGFloat {
        var g = CGFloat()
        self.getRed(nil, green: &g, blue: nil, alpha: nil)
        return g;
    }
    
    func blue() -> CGFloat {
        var b = CGFloat()
        self.getRed(nil, green: nil, blue: &b, alpha: nil)
        return b;
    }
    
    func luminance() -> CGFloat {

        var r = CGFloat()
        var g = CGFloat()
        var b = CGFloat()
        
        self.getRed(&r, green: &g, blue: &b, alpha: nil)

        return r * 0.2126 + g * 0.7152 + b * 0.0722
    }
}
*/






