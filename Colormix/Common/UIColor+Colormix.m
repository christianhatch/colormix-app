//
//  UIColor+Colormix.m
//  Colormix
//
//  Created by Christian Hatch on 7/17/14.
//  Copyright (c) 2014 Commodoreftp. All rights reserved.
//

#import "UIColor+Colormix.h"

@implementation UIColor (Colormix)

+ (NSString *)hexStringOfColor:(UIColor *)color
{
    CGFloat rFloat,gFloat,bFloat,aFloat;
    [color getRed:&rFloat green:&gFloat blue:&bFloat alpha:&aFloat];
    
    int r,g,b;
    
    r = (int)(255.0 * rFloat);
    g = (int)(255.0 * gFloat);
    b = (int)(255.0 * bFloat);
    
    NSString *hex = [NSString stringWithFormat:@"%02X%02X%02X",r,g,b];
    
    return [@"#" stringByAppendingString:hex];
}

+ (UIColor *)randomColor
{
    srand48(time(0));
    CGFloat hue = drand48();
    
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black

    return [UIColor colorWithHue:hue
                      saturation:saturation
                      brightness:brightness
                           alpha:1];
}

- (UIColor *)contrastingColor
{
    return (self.luminance > 0.5f) ? [UIColor blackColor] : [UIColor whiteColor];
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


#pragma mark - Private

- (CGFloat) luminance
{
    NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use -luminance");
    
    CGFloat r, g, b;
    if (![self getRed: &r green: &g blue: &b alpha:NULL])
        return 0.0f;
    
    // http://en.wikipedia.org/wiki/Luma_(video)
    // Y = 0.2126 R + 0.7152 G + 0.0722 B
    return r * 0.2126f + g * 0.7152f + b * 0.0722f;
}

- (BOOL) canProvideRGBComponents
{
    switch (CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor)))
    {
        case kCGColorSpaceModelRGB:
        case kCGColorSpaceModelMonochrome:
            return YES;
        default:
            return NO;
    }
}

@end
