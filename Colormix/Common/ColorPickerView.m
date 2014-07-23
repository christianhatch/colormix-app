//
//  ColorPickerView.m
//  Colormix
//
//  Created by Christian Hatch on 7/19/14.
//  Copyright (c) 2014 Commodoreftp. All rights reserved.
//

#import "ColorPickerView.h"
#import "UIColor+Colormix.h"

typedef NS_ENUM(NSInteger, SliderName)
{
    SliderNameHue = 1,
    SliderNameSaturation,
    SliderNameBrightness,
    SliderNameRed,
    SliderNameGreen,
    SliderNameBlue
};

static inline NSString * SliderNameStringFromTag(NSInteger sliderID)
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

CGFloat const kColorPickerViewHueScale = 360;
CGFloat const kColorPickerViewSaturationBrightnessScale = 100;
CGFloat const kColorPickerViewRGBScale = 255;

@interface ColorPickerView ()

@property (nonatomic, strong) CAGradientLayer *saturationGradient;
@property (nonatomic, strong) CAGradientLayer *brightnessGradient;
@property (nonatomic, strong) CAGradientLayer *hueGradient;

@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *sliderCollection;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;

@property (weak, nonatomic) IBOutlet UIView *HSBContainer;
@property (weak, nonatomic) IBOutlet UIView *RGBContainer;

@property (strong, nonatomic) IBOutlet UISlider *hueSlider;
@property (strong, nonatomic) IBOutlet UISlider *saturationSlider;
@property (strong, nonatomic) IBOutlet UISlider *brightnessSlider;

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


- (IBAction)sliderValueChangedContinuous:(id)sender;

- (IBAction)mainButtonTapped:(id)sender;


@end


@implementation ColorPickerView

+ (instancetype)colorPickerViewWithFrame:(CGRect)frame
                                delegate:(id<ColorPickerViewDelegate>)delegate
{
    ColorPickerView *picker = [[NSBundle mainBundle] loadNibNamed:@"ColorPickerView" owner:self options:nil].firstObject;
    picker.frame = frame;
    picker.delegate = delegate;
    picker.pickedColor = [UIColor randomColor];
    return picker;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
    [self refreshGradients];
}


#pragma mark - IBActions

- (IBAction)sliderValueChangedContinuous:(UISlider *)sender
{
    NSInteger tag = sender.tag;
    
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
    
    [self updateUIAnimated:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(colorPickerView:pickedColorDidChange:)])
    {
        [self.delegate colorPickerView:self
                  pickedColorDidChange:self.pickedColor];
    }

    DebugLog(@"Name: %@ Value: %f", SliderNameStringFromTag(tag), sender.value);
    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(colorPickerView:pickedColorDidChange:)])
//    {
//        [self.delegate colorPickerView:self didMoveSliderNamed:SliderNameStringFromTag(tag)];
//    }
}

- (IBAction)mainButtonTapped:(id)sender
{
    [PFAnalytics trackEvent:@"ColorPickerView Main Button Tapped"];

    if (self.delegate && [self.delegate respondsToSelector:@selector(colorPickerViewMainButtonTapped:)])
    {
        [self.delegate colorPickerViewMainButtonTapped:self];
    }
}




- (void)setPickedColor:(UIColor *)pickedColor
{
    _pickedColor = pickedColor;
    [self updateUIAnimated:NO];
}

- (void)setPickedColor:(UIColor *)pickedColor
              animated:(BOOL)animated
{
    _pickedColor = pickedColor;
    [self updateUIAnimated:animated]; 
}


#pragma mark - UI-related

- (void)rgbDidSlide
{
    self.pickedColor = [UIColor colorWithRed:self.redSlider.value/kColorPickerViewRGBScale
                                       green:self.greenSlider.value/kColorPickerViewRGBScale
                                        blue:self.blueSlider.value/kColorPickerViewRGBScale
                                       alpha:1];
}

- (void)hslDidSlide
{
    self.pickedColor = [UIColor colorWithHue:self.hueSlider.value/kColorPickerViewHueScale
                                  saturation:MAX(self.saturationSlider.value/kColorPickerViewSaturationBrightnessScale, 0.01)
                                  brightness:MAX(self.brightnessSlider.value/kColorPickerViewSaturationBrightnessScale, 0.01)
                                       alpha:1];
}

- (void)updateUIAnimated:(BOOL)animated
{
    [UIView animateWithDuration:0.5f
                          delay:0.0f
         usingSpringWithDamping:0.7f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionTransitionCrossDissolve
                     animations:^
     {
         [self syncSlidersToColorAnimated:animated];
         [self updateGradients];
         [self refreshGradients];
         [self updateLabels];
     }
                     completion:nil];
}

- (void)syncSlidersToColorAnimated:(BOOL)animated
{
    [self.hueSlider setValue:self.pickedColor.hue * kColorPickerViewHueScale
                    animated:animated];
    [self.saturationSlider setValue:self.pickedColor.saturation * kColorPickerViewSaturationBrightnessScale
                           animated:animated];
    [self.brightnessSlider setValue:self.pickedColor.brightness * kColorPickerViewSaturationBrightnessScale
                           animated:animated];
    
    [self.redSlider setValue:self.pickedColor.red * kColorPickerViewRGBScale
                    animated:animated];
    [self.greenSlider setValue:self.pickedColor.green * kColorPickerViewRGBScale
                      animated:animated];
    [self.blueSlider setValue:self.pickedColor.blue * kColorPickerViewRGBScale
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
    
    NSString *hex = [UIColor hexStringOfColor:self.pickedColor];
    self.hexValueLabel.text = hex;
    
    for (UILabel *label in self.labelCollection)
    {
        [label setTextColor:self.pickedColor.contrastingColor];
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
                                    saturation:self.pickedColor.saturation
                                    brightness:self.pickedColor.brightness
                                         alpha:1];
        
        [hues addObject:(id)color.CGColor];
        
        hue = hue + 0.1;
    }
    
    NSArray *hueColors = [NSArray arrayWithArray:hues];
    return hueColors;
}

- (NSArray *)saturationGradientColors
{
    UIColor *startSat = [UIColor colorWithHue:self.pickedColor.hue
                                   saturation:0
                                   brightness:self.pickedColor.brightness
                                        alpha:1];
    
    UIColor *endSat = [UIColor colorWithHue:self.pickedColor.hue
                                 saturation:1
                                 brightness:self.pickedColor.brightness
                                      alpha:1];
    
    NSArray *satColors = @[(id)startSat.CGColor, (id)endSat.CGColor];
    return satColors;
}

- (NSArray *)brightnessGradientColors
{
    UIColor *startBright = [UIColor colorWithHue:self.pickedColor.hue
                                      saturation:self.pickedColor.saturation
                                      brightness:0
                                           alpha:1];
    
    UIColor *endBright = [UIColor colorWithHue:self.pickedColor.hue
                                    saturation:self.pickedColor.saturation
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


@end
