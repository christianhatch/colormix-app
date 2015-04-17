//
//  ColorPickerView.h
//  Colormix
//
//  Created by Christian Hatch on 7/19/14.
//  Copyright (c) 2014 Commodoreftp. All rights reserved.
//

@import UIKit;



@class ColorPickerViewObjC;
@protocol ColorPickerViewDelegate <NSObject>

@optional
- (void)colorPickerViewMainButtonTapped:(ColorPickerViewObjC *)colorPickerView;

- (void)colorPickerView:(ColorPickerViewObjC *)view
   pickedColorDidChange:(UIColor *)color;

@end









@interface ColorPickerViewObjC : UIView

/**
 The color picked by the user or set by calling setPickedColor:animated:
 */
@property (nonatomic, readonly) UIColor *pickedColor;

/**
 Sets the picked color and optionally animates the sliders moving.
 
 @param pickedColor The new color to set as the picked color
 @param animated    Optionally animate the transition the new color.
 */
- (void)setPickedColor:(UIColor *)pickedColor
              animated:(BOOL)animated;


/**
 The delegate to receive callbacks.
 */
@property (weak, nonatomic) IBOutlet id <ColorPickerViewDelegate> delegate;


/**
 Designated Initializer!
 
 @param frame    The frame of the ColorPickerView.
 @param delegate The delegate of the ColorPickerView
 
 @return A new ColorPickerView with the given frame and delegate.
 */
+ (instancetype)colorPickerViewWithFrame:(CGRect)frame
                                delegate:(id <ColorPickerViewDelegate>)delegate;

@end




