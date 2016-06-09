//
//  UIImage+Colormix.h
//  Colormix
//
//  Created by Christian Hatch on 6/9/16.
//  Copyright © 2016 Commodoreftp. All rights reserved.
//


@interface UIImage (Colormix)

+ (UIImage *)squareImageWithColor:(UIColor *)color
                             size:(CGSize)size;

+ (UIImage *)verticalLineImageWithColor:(UIColor *)color
                                   size:(CGSize)size;

@end
