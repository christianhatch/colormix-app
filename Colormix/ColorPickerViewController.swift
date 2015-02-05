//
//  ColorPickerViewController.swift
//  Colormix
//
//  Created by Christian Hatch on 2/4/15.
//  Copyright (c) 2015 Commodoreftp. All rights reserved.
//

import UIKit
import ColorPickerView

class ColorPickerViewController: UIViewController {

    @IBOutlet weak var colorPickerContainerView: UIView!
    var colorPickerView: ColorPickerView
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.applyRandomColor()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func applyRandomColor() {
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.0,
            options: .AllowUserInteration | .TransitionCrossDissolve,
            animations: { () -> Void in
            self.colo
        }, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
