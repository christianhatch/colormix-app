//
//  ColorPickerViewController.m
//  Colormix
//
//  Created by Christian Hatch on 2/6/14.
//  Copyright (c) 2014 Commodoreftp. All rights reserved.
//

typedef NS_ENUM(NSInteger, SliderName)
{
    SliderNameHue = 1,
    SliderNameSaturation,
    SliderNameBrightness,
    SliderNameRed,
    SliderNameGreen,
    SliderNameBlue
};

static inline NSString * SliderNameString(NSInteger sliderID)
{
    NSString *sliderNameString;
    
    switch (sliderID) {
        case SliderNameHue:
            sliderNameString = @"Hue";
            break;
        case SliderNameSaturation:
            sliderNameString = @"Saturation";
            break;
        case SliderNameBrightness:
            sliderNameString = @"Brightness";
            break;
        case SliderNameRed:
            sliderNameString = @"Red";
            break;
        case SliderNameGreen:
            sliderNameString = @"Green";
            break;
        case SliderNameBlue:
            sliderNameString = @"Blue";
            break;
    }
    return sliderNameString;
}



#define HUE_SCALE 360
#define SAT_SCALE 100
#define BRIGHT_SCALE 100
#define RGB_SCALE 255

#define CORNER_RADIUS 10

#import "ColorPickerViewController.h"
#import <FlurrySDK/Flurry.h>
#import "UIColor+Colormix.h"

@import QuartzCore;


@interface ColorPickerViewController ()

@property (strong, nonatomic) IBOutlet UIView *hsbContainer;
@property (strong, nonatomic) IBOutlet UIView *rgbContainer;

@property (strong, nonatomic) IBOutlet UISlider *hueSlider;
@property (strong, nonatomic) IBOutlet UISlider *saturationSlider;
@property (strong, nonatomic) IBOutlet UISlider *brightnessSlider;

@property (nonatomic, strong) CAGradientLayer *saturationGradient;
@property (nonatomic, strong) CAGradientLayer *brightnessGradient;
@property (nonatomic, strong) CAGradientLayer *hueGradient;

@property (strong, nonatomic) IBOutlet UISlider *redSlider;
@property (strong, nonatomic) IBOutlet UISlider *greenSlider;
@property (strong, nonatomic) IBOutlet UISlider *blueSlider;

@property (strong, nonatomic) IBOutlet UILabel *hueLabel;
@property (strong, nonatomic) IBOutlet UILabel *saturationLabel;
@property (strong, nonatomic) IBOutlet UILabel *brightnessLabel;

@property (strong, nonatomic) IBOutlet UILabel *redLabel;
@property (strong, nonatomic) IBOutlet UILabel *greenLabel;
@property (strong, nonatomic) IBOutlet UILabel *blueLabel;

@property (strong, nonatomic) IBOutlet UILabel *hexValueLabel;

- (IBAction)sliderValueChanged:(id)sender;

@end

@implementation ColorPickerViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.view.backgroundColor = [UIColor randomColor];
    
    [self syncSlidersToColor];
}

- (void)viewDidLayoutSubviews
{
    [self.hueGradient removeFromSuperlayer];
    [self.saturationGradient removeFromSuperlayer];
    [self.brightnessGradient removeFromSuperlayer];
    
    [super viewDidLayoutSubviews];

    self.hueGradient = nil;
    self.saturationGradient = nil;
    self.brightnessGradient = nil;

    [self.hueSlider.layer insertSublayer:self.hueGradient atIndex:0];
    [self.saturationSlider.layer insertSublayer:self.saturationGradient atIndex:0];
    [self.brightnessSlider.layer insertSublayer:self.brightnessGradient atIndex:0];
}

#pragma mark - IBActions

- (IBAction)sliderValueChanged:(id)sender {
    
    NSInteger tag = [(UISlider *)sender tag];
    
    switch (tag) {
        case SliderNameHue:
        case SliderNameSaturation:
        case SliderNameBrightness:{
            [self hslDidSlide];
        }break;
        case SliderNameRed:
        case SliderNameGreen:
        case SliderNameBlue:{
            [self rgbDidSlide];
        }break;
    }
    
    [self syncSlidersToColor];

    [self logEvent:[NSString stringWithFormat:@"%@ Slider Moved", SliderNameString(tag)]];
}

#pragma mark - Main Methods

- (void)rgbDidSlide
{
    self.view.backgroundColor = [UIColor colorWithRed:self.redSlider.value/RGB_SCALE
                                                green:self.greenSlider.value/RGB_SCALE
                                                 blue:self.blueSlider.value/RGB_SCALE
                                                alpha:1];
}

- (void)hslDidSlide
{
    self.view.backgroundColor = [UIColor colorWithHue:self.hueSlider.value/HUE_SCALE
                                           saturation:self.saturationSlider.value/SAT_SCALE
                                           brightness:self.brightnessSlider.value/BRIGHT_SCALE
                                                alpha:1];
}




#pragma mark - Private Methods

#pragma mark - UI-related

- (void)syncSlidersToColor
{
    [self.hueSlider setValue:self.view.backgroundColor.hue * HUE_SCALE
                    animated:YES];
    [self.saturationSlider setValue:self.view.backgroundColor.saturation * SAT_SCALE
                           animated:YES];
    [self.brightnessSlider setValue:self.view.backgroundColor.brightness * BRIGHT_SCALE
                           animated:YES];
    
    [self.redSlider setValue:self.view.backgroundColor.red * RGB_SCALE
                    animated:YES];
    [self.greenSlider setValue:self.view.backgroundColor.green * RGB_SCALE
                      animated:YES];
    [self.blueSlider setValue:self.view.backgroundColor.blue * RGB_SCALE
                     animated:YES];
    
    [self updateGradients];
    
    [self updateLabels];
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
    
    NSString *hex = [UIColor hexStringOfColor:self.view.backgroundColor];
    self.hexValueLabel.text = hex;
}

- (void)updateGradients
{
    self.saturationGradient.colors = [self saturationGradientColors];
    self.brightnessGradient.colors = [self brightnessGradientColors];
    self.hueGradient.colors = [self hueGradientColors];
}

- (void)setUpViews
{
    UIColor *clear = [UIColor clearColor];
    
    UIImage *thumb = [self imageWithColor:[UIColor blackColor]
                                     size:CGSizeMake(self.hueSlider.bounds.size.height, self.hueSlider.bounds.size.height)];
    
    self.hueSlider.maximumValue = HUE_SCALE;
    self.hueSlider.minimumTrackTintColor = clear;
    self.hueSlider.maximumTrackTintColor = clear;
    [self.hueSlider setThumbImage:thumb forState:UIControlStateNormal];
    
    self.saturationSlider.maximumValue = SAT_SCALE;
    self.saturationSlider.minimumTrackTintColor = clear;
    self.saturationSlider.maximumTrackTintColor = clear;
    [self.saturationSlider setThumbImage:thumb forState:UIControlStateNormal];
    
    self.brightnessSlider.maximumValue = BRIGHT_SCALE;
    self.brightnessSlider.minimumTrackTintColor = clear;
    self.brightnessSlider.maximumTrackTintColor = clear;
    [self.brightnessSlider setThumbImage:thumb forState:UIControlStateNormal];
    
    self.redSlider.maximumValue = RGB_SCALE;
    [self.redSlider setThumbImage:thumb forState:UIControlStateNormal];

    self.greenSlider.maximumValue = RGB_SCALE;
    [self.greenSlider setThumbImage:thumb forState:UIControlStateNormal];

    self.blueSlider.maximumValue = RGB_SCALE;
    [self.blueSlider setThumbImage:thumb forState:UIControlStateNormal];

    self.hsbContainer.layer.cornerRadius = CORNER_RADIUS;
    self.rgbContainer.layer.cornerRadius = CORNER_RADIUS;
    self.hexValueLabel.layer.cornerRadius = CORNER_RADIUS/2;
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
        _hueGradient.cornerRadius = CORNER_RADIUS;
        
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
        _saturationGradient.cornerRadius = CORNER_RADIUS;
        
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
        _brightnessGradient.cornerRadius = CORNER_RADIUS;
        
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
                                    saturation:self.view.backgroundColor.saturation
                                    brightness:self.view.backgroundColor.brightness
                                         alpha:1];
        
        [hues addObject:(id)color.CGColor];
        
        hue = hue + 0.1;
    }
    
    NSArray *hueColors = [NSArray arrayWithArray:hues];
    return hueColors;
}

- (NSArray *)saturationGradientColors
{
    UIColor *startSat = [UIColor colorWithHue:self.view.backgroundColor.hue
                                   saturation:0
                                   brightness:self.view.backgroundColor.brightness
                                        alpha:1];
    
    UIColor *endSat = [UIColor colorWithHue:self.view.backgroundColor.hue
                                 saturation:1
                                 brightness:self.view.backgroundColor.brightness
                                      alpha:1];
    
    NSArray *satColors = @[(id)startSat.CGColor, (id)endSat.CGColor];
    return satColors;
}

- (NSArray *)brightnessGradientColors
{
    UIColor *startBright = [UIColor colorWithHue:self.view.backgroundColor.hue
                                      saturation:self.view.backgroundColor.saturation
                                      brightness:0
                                           alpha:1];
    
    UIColor *endBright = [UIColor colorWithHue:self.view.backgroundColor.hue
                                    saturation:self.view.backgroundColor.saturation
                                    brightness:1
                                         alpha:1];
    
    NSArray *brightColors = @[(id)startBright.CGColor, (id)endBright.CGColor];
    return brightColors;
}





@end











