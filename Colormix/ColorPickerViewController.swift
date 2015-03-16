//
//  ColorPickerViewController.swift
//  Colormix
//
//  Created by Christian Hatch on 2/4/15.
//  Copyright (c) 2015 Commodoreftp. All rights reserved.
//

import UIKit


class ColorPickerViewController: UIViewController, ColorPickerViewDelegate {

    //MARK: variables
    @IBOutlet weak var colorPickerContainerView: UIView!
    let colorPickerView: ColorPickerViewObjC!
    
    //MARK: init
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.colorPickerView = self.createColorPickerView()
        self.colorPickerContainerView.addSubview(self.colorPickerContainerView)
    }
    
    //MARK: view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.applyRandomBGColor()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.colorPickerView.setPickedColor(self.colorPickerView.pickedColor, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: custom functions
    func applyRandomBGColor() {
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.0,
            options: .AllowUserInteraction | .TransitionCrossDissolve,
            animations:
        { () -> Void in
                self.colorPickerView.setPickedColor(UIColor.randomColor(), animated: true)
                self.view.backgroundColor = self.colorPickerView.pickedColor
        },
            completion: nil)
    }
    
    
    func createColorPickerView() -> ColorPickerViewObjC {
        var colorPickerViewVar: ColorPickerViewObjC = ColorPickerViewObjC.colorPickerViewWithFrame(self.view.frame, delegate: self)
        colorPickerViewVar.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let padding: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        let top: NSLayoutConstraint = NSLayoutConstraint(
            item: self.colorPickerView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self.colorPickerContainerView,
            attribute: .Top,
            multiplier: 1.0,
            constant: padding.top)
        
        let bottom: NSLayoutConstraint = NSLayoutConstraint(
            item: self.colorPickerView,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: self.colorPickerContainerView,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: -padding.top)
        
        let left: NSLayoutConstraint = NSLayoutConstraint(
            item: self.colorPickerView,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: self.colorPickerContainerView,
            attribute: .Left,
            multiplier: 1.0,
            constant: padding.top)

        let right: NSLayoutConstraint = NSLayoutConstraint(
            item: self.colorPickerView,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: self.colorPickerContainerView,
            attribute: .Right,
            multiplier: 1.0,
            constant: -padding.top)

        
        self.view.addConstraints([top, bottom, left, right])
        
        return colorPickerViewVar
    }
    
    
    //MARK: colorpicker view delegate
    
    func colorPickerViewMainButtonTapped(colorPickerView: ColorPickerViewObjC!) {
        self.applyRandomBGColor()
    }
    
    func colorPickerView(view: ColorPickerViewObjC!, pickedColorDidChange color: UIColor!) {
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.0,
            options: .AllowUserInteraction | .TransitionCrossDissolve,
            animations:
            { () -> Void in
                self.view.backgroundColor = self.colorPickerView.pickedColor
            },
            completion: nil)
    }
}
