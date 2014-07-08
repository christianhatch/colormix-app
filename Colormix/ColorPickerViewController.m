//
//  ColorPickerViewController.m
//  ColorMix
//
//  Created by Christian Hatch on 2/6/14.
//  Copyright (c) 2014 Acacia Interactive. All rights reserved.
//

typedef NS_ENUM(NSInteger, SliderName){
    SliderNameHue = 1,
    SliderNameSaturation,
    SliderNameBrightness,
    SliderNameRed,
    SliderNameGreen,
    SliderNameBlue
};

#define HUE_SCALE 360
#define SAT_SCALE 100
#define BRIGHT_SCALE 100
#define RGB_SCALE 255
#define CORNER_RADIUS 10

#import "ColorPickerViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)configureView
{
    UIColor *clear = [UIColor clearColor];
    
    UIImage *thumb = [self imageWithColor:[UIColor blackColor] size:CGSizeMake(self.hueSlider.bounds.size.height, self.hueSlider.bounds.size.height)];
    
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
    self.redSlider.minimumTrackTintColor = [UIColor redColor];
    self.redSlider.maximumTrackTintColor = [UIColor redColor];
    
    self.greenSlider.maximumValue = RGB_SCALE;
    self.greenSlider.minimumTrackTintColor = [UIColor greenColor];
    self.greenSlider.maximumTrackTintColor = [UIColor greenColor];
    
    self.blueSlider.maximumValue = RGB_SCALE;
    self.blueSlider.minimumTrackTintColor = [UIColor blueColor];
    self.blueSlider.maximumTrackTintColor = [UIColor blueColor];
    
    self.hsbContainer.layer.cornerRadius = CORNER_RADIUS;
    self.rgbContainer.layer.cornerRadius = CORNER_RADIUS;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.view.backgroundColor = [self randomColor];
    
    [self syncSlidersToColor];
}

- (IBAction)sliderValueChanged:(id)sender {
    
    NSInteger tag = [(UISlider *)sender tag];
    
    switch (tag) {
        case SliderNameHue:
        case SliderNameSaturation:
        case SliderNameBrightness:
            self.view.backgroundColor = [UIColor colorWithHue:self.hueSlider.value/HUE_SCALE saturation:self.saturationSlider.value/SAT_SCALE brightness:self.brightnessSlider.value/BRIGHT_SCALE alpha:1];
            break;
        case SliderNameRed:
        case SliderNameGreen:
        case SliderNameBlue:
            self.view.backgroundColor = [UIColor colorWithRed:self.redSlider.value/RGB_SCALE green:self.greenSlider.value/RGB_SCALE blue:self.blueSlider.value/RGB_SCALE alpha:1];
            break;
    }
    
    [self syncSlidersToColor];
}

- (void)syncSlidersToColor
{
    [self.hueSlider setValue:[self hue] * HUE_SCALE animated:YES];
    [self.saturationSlider setValue:[self saturation] * SAT_SCALE animated:YES];
    [self.brightnessSlider setValue:[self brightness] * BRIGHT_SCALE animated:YES];
    
    [self.redSlider setValue:[self red] * RGB_SCALE animated:YES];
    [self.greenSlider setValue:[self green] * RGB_SCALE animated:YES];
    [self.blueSlider setValue:[self blue] * RGB_SCALE animated:YES];
    
    [self updateGradients];
    
    [self updateLabels];
}

- (void)updateLabels
{
    self.hueLabel.text = [NSString stringWithFormat:@"%f", self.hueSlider.value];
    self.saturationLabel.text = [NSString stringWithFormat:@"%f", self.saturationSlider.value];
    self.brightnessLabel.text = [NSString stringWithFormat:@"%f", self.brightnessSlider.value];
    
    self.redLabel.text = [NSString stringWithFormat:@"%f", self.redSlider.value];
    self.greenLabel.text = [NSString stringWithFormat:@"%f", self.greenSlider.value];
    self.blueLabel.text = [NSString stringWithFormat:@"%f", self.blueSlider.value];
    
    NSString *hex = [self hexStringOfColor:self.view.backgroundColor];
    self.hexValueLabel.text = hex;
}

- (void)updateGradients
{
    self.saturationGradient.colors = [self saturationGradientColors];
    self.brightnessGradient.colors = [self brightnessGradientColors];
    self.hueGradient.colors = [self hueGradientColors];
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
        
        [self.hueSlider.layer insertSublayer:_hueGradient atIndex:0];
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
        
        [self.saturationSlider.layer insertSublayer:_saturationGradient atIndex:0];
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
        
        [self.brightnessSlider.layer insertSublayer:_brightnessGradient atIndex:0];
    }
    return _brightnessGradient;
}

- (CGFloat)hue
{
    CGFloat hFloat,sFloat,bFloat;
    [self.view.backgroundColor getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:nil];
    return hFloat;
}

- (CGFloat)saturation
{
    CGFloat hFloat,sFloat,bFloat;
    [self.view.backgroundColor getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:nil];
    return sFloat;
}

- (CGFloat)brightness
{
    CGFloat hFloat,sFloat,bFloat;
    [self.view.backgroundColor getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:nil];
    return bFloat;
}

- (CGFloat)red
{
    CGFloat rFloat,gFloat,bFloat;
    [self.view.backgroundColor getRed:&rFloat green:&gFloat blue:&bFloat alpha:nil];
    return rFloat;
}

- (CGFloat)green
{
    CGFloat rFloat,gFloat,bFloat;
    [self.view.backgroundColor getRed:&rFloat green:&gFloat blue:&bFloat alpha:nil];
    return gFloat;
}

- (CGFloat)blue
{
    CGFloat rFloat,gFloat,bFloat;
    [self.view.backgroundColor getRed:&rFloat green:&gFloat blue:&bFloat alpha:nil];
    return bFloat;
}

- (NSArray *)hueGradientColors
{
    NSMutableArray *hues = [NSMutableArray arrayWithCapacity:10];
    
    CGFloat hue = 0;
    
    for (int stepCounter = 0; stepCounter < 10; stepCounter++) {
        
        UIColor *color = [UIColor colorWithHue:hue saturation:[self saturation] brightness:[self brightness] alpha:1];
        [hues addObject:(id)color.CGColor];
        
        hue = hue + 0.1;
    }
    
    NSArray *hueColors = [NSArray arrayWithArray:hues];
    return hueColors;
}


- (NSArray *)saturationGradientColors
{
    UIColor *startSat = [UIColor colorWithHue:[self hue] saturation:0 brightness:[self brightness] alpha:1];
    UIColor *endSat = [UIColor colorWithHue:[self hue] saturation:1 brightness:[self brightness] alpha:1];
    NSArray *satColors = @[(id)startSat.CGColor, (id)endSat.CGColor];
    return satColors;
}

- (NSArray *)brightnessGradientColors
{
    UIColor *startBright = [UIColor colorWithHue:[self hue] saturation:[self saturation] brightness:0 alpha:1];
    UIColor *endBright = [UIColor colorWithHue:[self hue] saturation:[self saturation] brightness:1 alpha:1];
    NSArray *brightColors = @[(id)startBright.CGColor, (id)endBright.CGColor];
    return brightColors;
}


#pragma mark - Utility Methods
- (NSString *)hexStringOfColor:(UIColor *)color
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

- (UIColor *)randomColor
{
    //    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    
    srand48(time(0));
    CGFloat hue = drand48();
    
    //    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    //    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:.7 brightness:1 alpha:1];
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:CORNER_RADIUS];
    roundedRect.lineWidth = 3;
    [color setStroke];
    [roundedRect stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



@end











