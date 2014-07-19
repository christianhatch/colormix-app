//
//  ColorPickerView.m
//  Colormix
//
//  Created by Christian Hatch on 7/19/14.
//  Copyright (c) 2014 Commodoreftp. All rights reserved.
//

#import "ColorPickerView.h"
#import "UIColor+Colormix.h"
#import <FlurrySDK/Flurry.h>

CGFloat const kColorPickerViewHueScale = 360;
CGFloat const kColorPickerViewSaturationBrightnessScale = 100;
CGFloat const kColorPickerViewRGBScale = 255;


@interface ColorPickerView ()

@property (nonatomic, strong) CAGradientLayer *saturationGradient;
@property (nonatomic, strong) CAGradientLayer *brightnessGradient;
@property (nonatomic, strong) CAGradientLayer *hueGradient;

@end

@implementation ColorPickerView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        if (self.subviews.count == 0) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
            UIView *subview = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
            subview.frame = self.bounds;
            [self addSubview:subview];
            self.backgroundColor = [UIColor clearColor];
        }
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    [self setupUI];
//    [self refreshGradients];`
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self refreshGradients];
}



#pragma mark - IBActions

- (IBAction)sliderValueChanged:(id)sender
{
    NSInteger tag = [(UISlider *)sender tag];
    
    switch (tag) {
        case SliderNameHue:
        case SliderNameSaturation:
        case SliderNameBrightness:{
            [self callDelegateSelector:@selector(colorPickerViewDidSlideHSB:)];
        }break;
        case SliderNameRed:
        case SliderNameGreen:
        case SliderNameBlue:{
            [self callDelegateSelector:@selector(colorPickerViewDidSlideRGB:)];
        }break;
    }
    
    [self updateUIAnimated:NO];
    
    [self logEvent:[NSString stringWithFormat:@"%@ Slider Moved", SliderNameString(tag)]];
}

- (IBAction)mainButtonTapped:(id)sender
{
    [self callDelegateSelector:@selector(colorPickerViewMainButtonTapped:)];
}


#pragma mark - UI-related

- (void)updateUIAnimated:(BOOL)animated
{
    [UIView animateWithDuration:0.5f
                          delay:0.0f
     //         usingSpringWithDamping:0.7f
     //          initialSpringVelocity:1.0f
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionTransitionCrossDissolve
                     animations:^
     {
         [self syncSlidersToColorAnimated:animated];
         [self updateGradients];
         [self updateLabels];
     }
                     completion:nil];
}

- (void)syncSlidersToColorAnimated:(BOOL)animated
{
    [self.hueSlider setValue:self.delegate.colorPickerViewExternalColorRepresentation.hue * kColorPickerViewHueScale
                    animated:animated];
    [self.saturationSlider setValue:self.delegate.colorPickerViewExternalColorRepresentation.saturation * kColorPickerViewSaturationBrightnessScale
                           animated:animated];
    [self.brightnessSlider setValue:self.delegate.colorPickerViewExternalColorRepresentation.brightness * kColorPickerViewSaturationBrightnessScale
                           animated:animated];
    
    [self.redSlider setValue:self.delegate.colorPickerViewExternalColorRepresentation.red * kColorPickerViewRGBScale
                    animated:animated];
    [self.greenSlider setValue:self.delegate.colorPickerViewExternalColorRepresentation.green * kColorPickerViewRGBScale
                      animated:animated];
    [self.blueSlider setValue:self.delegate.colorPickerViewExternalColorRepresentation.blue * kColorPickerViewRGBScale
                     animated:animated];
}

- (void)updateLabels
{
    NSString *formatString = @"%.2f";
    
    self.hueLabel.text = [NSString stringWithFormat:formatString, self.hueSlider.value];
    self.saturationLabel.text = [NSString stringWithFormat:formatString, self.saturationSlider.value];
    self.brightnessLabel.text = [NSString stringWithFormat:formatString, self.brightnessSlider.value];
    
    self.redLabel.text = [NSString stringWithFormat:formatString, self.redSlider.value];
    self.greenLabel.text = [NSString stringWithFormat:formatString, self.greenSlider.value];
    self.blueLabel.text = [NSString stringWithFormat:formatString, self.blueSlider.value];
    
    NSString *hex = [UIColor hexStringOfColor:self.delegate.colorPickerViewExternalColorRepresentation];
    self.hexValueLabel.text = hex;
    
    for (UILabel *label in self.labelCollection)
    {
        [label setTextColor:self.delegate.colorPickerViewExternalColorRepresentation.contrastingColor];
    }
}

- (void)updateGradients
{
    self.saturationGradient.colors = [self saturationGradientColors];
    self.brightnessGradient.colors = [self brightnessGradientColors];
    self.hueGradient.colors = [self hueGradientColors];
}

- (void)setupUI
{
    UIImage *thumb = [self imageWithColor:[UIColor blackColor]
                                     size:CGSizeMake(self.hueSlider.bounds.size.height, self.hueSlider.bounds.size.height)];
    UIImage *clear = [self imageWithColor:[UIColor clearColor]
                                     size:CGSizeMake(self.hueSlider.bounds.size.width, self.hueSlider.bounds.size.height)];
    
    for (UISlider *slider in self.sliderCollection)
    {
        [slider setThumbImage:thumb forState:UIControlStateNormal];
    }
    
    for (UISlider *slider in @[self.hueSlider, self.saturationSlider, self.brightnessSlider])
    {
        [slider setMinimumTrackImage:clear forState:UIControlStateNormal];
        [slider setMaximumTrackImage:clear forState:UIControlStateNormal];
    }
}

#pragma mark - Other

- (UIImage *)imageWithColor:(UIColor *)color
                       size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    
    [roundedRect moveToPoint:CGPointMake(roundedRect.bounds.size.width/2, 0)];
    [roundedRect addLineToPoint:CGPointMake(roundedRect.bounds.size.width/2, roundedRect.bounds.size.height)];
    
    [roundedRect moveToPoint:CGPointMake(0, roundedRect.bounds.size.height/2)];
    [roundedRect addLineToPoint:CGPointMake(roundedRect.bounds.size.width, roundedRect.bounds.size.height/2)];
    
    roundedRect.lineWidth = 1;
    [color setStroke];
    [roundedRect stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)logEvent:(NSString *)event
{
    [Flurry logEvent:event];
    DebugLog(@"event %@", event);
}


#pragma mark - Getters

- (CAGradientLayer *)hueGradient
{
    if (!_hueGradient) {
        _hueGradient = [CAGradientLayer layer];
        _hueGradient.frame = self.hueSlider.bounds;
        
        _hueGradient.startPoint = CGPointZero;
        _hueGradient.endPoint = CGPointMake(1, 0);
        
        _hueGradient.colors = [self hueGradientColors];
    }
    return _hueGradient;
}

- (CAGradientLayer *)saturationGradient
{
    if (!_saturationGradient) {
        _saturationGradient = [CAGradientLayer layer];
        _saturationGradient.frame = self.saturationSlider.bounds;
        
        _saturationGradient.startPoint = CGPointZero;
        _saturationGradient.endPoint = CGPointMake(1, 0);
        
        _saturationGradient.colors = [self saturationGradientColors];
    }
    return _saturationGradient;
}

- (CAGradientLayer *)brightnessGradient
{
    if (!_brightnessGradient) {
        _brightnessGradient = [CAGradientLayer layer];
        _brightnessGradient.frame = self.brightnessSlider.bounds;
        
        _brightnessGradient.startPoint = CGPointZero;
        _brightnessGradient.endPoint = CGPointMake(1, 0);
        
        _brightnessGradient.colors = [self brightnessGradientColors];
    }
    return _brightnessGradient;
}

- (NSArray *)hueGradientColors
{
    NSMutableArray *hues = [NSMutableArray arrayWithCapacity:10];
    
    CGFloat hue = 0;
    
    for (int numberOfColors = 0; numberOfColors < 10; numberOfColors++) {
        
        UIColor *color = [UIColor colorWithHue:hue
                                    saturation:self.delegate.colorPickerViewExternalColorRepresentation.saturation
                                    brightness:self.delegate.colorPickerViewExternalColorRepresentation.brightness
                                         alpha:1];
        
        [hues addObject:(id)color.CGColor];
        
        hue = hue + 0.1;
    }
    
    NSArray *hueColors = [NSArray arrayWithArray:hues];
    return hueColors;
}

- (NSArray *)saturationGradientColors
{
    UIColor *startSat = [UIColor colorWithHue:self.delegate.colorPickerViewExternalColorRepresentation.hue
                                   saturation:0
                                   brightness:self.delegate.colorPickerViewExternalColorRepresentation.brightness
                                        alpha:1];
    
    UIColor *endSat = [UIColor colorWithHue:self.delegate.colorPickerViewExternalColorRepresentation.hue
                                 saturation:1
                                 brightness:self.delegate.colorPickerViewExternalColorRepresentation.brightness
                                      alpha:1];
    
    NSArray *satColors = @[(id)startSat.CGColor, (id)endSat.CGColor];
    return satColors;
}

- (NSArray *)brightnessGradientColors
{
    UIColor *startBright = [UIColor colorWithHue:self.delegate.colorPickerViewExternalColorRepresentation.hue
                                      saturation:self.delegate.colorPickerViewExternalColorRepresentation.saturation
                                      brightness:0
                                           alpha:1];
    
    UIColor *endBright = [UIColor colorWithHue:self.delegate.colorPickerViewExternalColorRepresentation.hue
                                    saturation:self.delegate.colorPickerViewExternalColorRepresentation.saturation
                                    brightness:1
                                         alpha:1];
    
    NSArray *brightColors = @[(id)startBright.CGColor, (id)endBright.CGColor];
    return brightColors;
}



#pragma mark - Private

- (void)refreshGradients
{
    [self.hueGradient removeFromSuperlayer];
    [self.saturationGradient removeFromSuperlayer];
    [self.brightnessGradient removeFromSuperlayer];
    
    self.hueGradient = nil;
    self.saturationGradient = nil;
    self.brightnessGradient = nil;
    
    [self.hueSlider.layer insertSublayer:self.hueGradient atIndex:0];
    [self.saturationSlider.layer insertSublayer:self.saturationGradient atIndex:0];
    [self.brightnessSlider.layer insertSublayer:self.brightnessGradient atIndex:0];
}

- (void)callDelegateSelector:(SEL)selector
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    NSLog(@"call selector %@", NSStringFromSelector(selector));
    
    if ([self.delegate respondsToSelector:selector])
    {
        [self.delegate performSelector:selector withObject:self];
    }

#pragma clang diagnostic pop
}


@end
