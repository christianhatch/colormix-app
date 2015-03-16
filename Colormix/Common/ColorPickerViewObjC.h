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

///The color picked by the user.
@property (nonatomic, strong) UIColor *pickedColor;

- (void)setPickedColor:(UIColor *)pickedColor
              animated:(BOOL)animated;


///The delegate for delegate callbacks
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




