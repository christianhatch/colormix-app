//
//  UIColor+Colormix.m
//  Colormix
//
//  Created by Christian Hatch on 7/17/14.
//  Copyright (c) 2014 Commodoreftp. All rights reserved.
//

#import "UIColor+Colormix.h"

@implementation UIColor (Colormix)

+ (UIColor *)randomColor
{
    srand48(time(0));
    CGFloat hue = drand48();
    
    return [UIColor colorWithHue:hue saturation:.7 brightness:1 alpha:1];
}

- (CGFloat)hue
{
    CGFloat hFloat,sFloat,bFloat;
    [self getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:nil];
    return hFloat;
}

- (CGFloat)saturation
{
    CGFloat hFloat,sFloat,bFloat;
    [self getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:nil];
    return sFloat;
}

- (CGFloat)brightness
{
    CGFloat hFloat,sFloat,bFloat;
    [self getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:nil];
    return bFloat;
}

- (CGFloat)red
{
    CGFloat rFloat,gFloat,bFloat;
    [self getRed:&rFloat green:&gFloat blue:&bFloat alpha:nil];
    return rFloat;
}

- (CGFloat)green
{
    CGFloat rFloat,gFloat,bFloat;
    [self getRed:&rFloat green:&gFloat blue:&bFloat alpha:nil];
    return gFloat;
}

- (CGFloat)blue
{
    CGFloat rFloat,gFloat,bFloat;
    [self getRed:&rFloat green:&gFloat blue:&bFloat alpha:nil];
    return bFloat;
}

- (CGFloat)alpha
{
    CGFloat rFloat,gFloat,bFloat, alpha;
    [self getRed:&rFloat green:&gFloat blue:&bFloat alpha:&alpha];
    return alpha;
}


@end
