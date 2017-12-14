//
//  UIImage+Colormix.h
//  Colormix
//
//  Created by Christian Hatch on 6/9/16.
//  Copyright © 2016 Commodoreftp. All rights reserved.
//

typedef NS_ENUM(NSInteger, ImageAlignment)
{
    ImageAlignmentLeft,
    ImageAlignmentRight,
    ImageAlignmentCenter
};

@interface UIImage (Colormix)

+ (UIImage *)squareImageWithColor:(UIColor *)color
                             size:(CGSize)size;

+ (UIImage *)verticalLineImageWithColor:(UIColor *)color
                                   size:(CGSize)size
                              alignment:(ImageAlignment)alignment;

@end
