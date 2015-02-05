//
//  UIColor+Colormix.h
//  Colormix
//
//  Created by Christian Hatch on 7/17/14.
//  Copyright (c) 2014 Commodoreftp. All rights reserved.
//

@import UIKit; 

@interface UIColor (Colormix)

+ (UIColor *)randomColor;

+ (NSString *)hexStringOfColor:(UIColor *)color;

- (UIColor *)contrastingColor; 

@property (nonatomic, readonly) CGFloat hue;
@property (nonatomic, readonly) CGFloat saturation;
@property (nonatomic, readonly) CGFloat brightness;

@property (nonatomic, readonly) CGFloat red;
@property (nonatomic, readonly) CGFloat green;
@property (nonatomic, readonly) CGFloat blue;

@property (nonatomic, readonly) CGFloat alpha;

@end
