//
//  UIImage+Colormix.m
//  Colormix
//
//  Created by Christian Hatch on 6/9/16.
//  Copyright © 2016 Commodoreftp. All rights reserved.
//

#import "UIImage+Colormix.h"

@implementation UIImage (Colormix)

+ (UIImage *)squareImageWithColor:(UIColor *)color
                             size:(CGSize)size;
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    
    [roundedRect moveToPoint:CGPointMake(roundedRect.bounds.size.width/2, 0)];
    [roundedRect addLineToPoint:CGPointMake(roundedRect.bounds.size.width/2, roundedRect.bounds.size.height)];
    
//    [roundedRect moveToPoint:CGPointMake(0, roundedRect.bounds.size.height/2)];
//    [roundedRect addLineToPoint:CGPointMake(roundedRect.bounds.size.width, roundedRect.bounds.size.height/2)];
    
    roundedRect.lineWidth = 1;
    [color setStroke];
    [roundedRect stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)verticalLineImageWithColor:(UIColor *)color
                                   size:(CGSize)size
                              alignment:(ImageAlignment)alignment;
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat xCoord = 0;
    
    if (alignment == ImageAlignmentLeft) {
        xCoord = 1;
    }
    else if (alignment == ImageAlignmentRight) {
        xCoord = size.width;
    }
    else if (alignment == ImageAlignmentCenter) {
        xCoord = (size.width/2)-1;
    }
    
    [path moveToPoint:CGPointMake(xCoord, 0)];
    [path addLineToPoint:CGPointMake(xCoord, size.height)];
    
    path.lineWidth = 1;
    [color setStroke];
    [path stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end




























