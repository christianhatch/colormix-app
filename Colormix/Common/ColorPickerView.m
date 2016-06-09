//
//  ColorPickerView.m
//  Colormix
//
//  Created by Christian Hatch on 7/19/14.
//  Copyright (c) 2014 Commodoreftp. All rights reserved.
//

#import "ColorPickerView.h"
#import "UIColor+Colormix.h"
#import "UIImage+Colormix.h"
#import "Colormix-Swift.h"

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

@property (strong, nonatomic) IBOutlet UIStackView *hsbContainer;
@property (nonatomic, strong) LabelledSlider *hueSlider;
@property (nonatomic, strong) LabelledSlider *saturationSlider;
@property (nonatomic, strong) LabelledSlider *brightnessSlider;


@property (strong, nonatomic) IBOutlet UIStackView *rgbContainer;
@property (nonatomic, strong) LabelledSlider *redSlider;
@property (nonatomic, strong) LabelledSlider *greenSlider;
@property (nonatomic, strong) LabelledSlider *blueSlider;

@property (nonatomic, strong) UIColor *pickedColor;

@end


@implementation ColorPickerView

+ (instancetype)colorPickerViewWithFrame:(CGRect)frame
                                delegate:(id<ColorPickerViewDelegate>)delegate
{
    ColorPickerView *picker = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    picker.frame = frame;
    picker.delegate = delegate;
    [picker setPickedColor:[UIColor randomColor] animated:NO];
    return picker;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
    [self refreshGradientUI];
//    [self configureTapToCopyLabel];
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
        }
            break;
        case SliderNameRed:
        case SliderNameGreen:
        case SliderNameBlue:{
            [self rgbDidSlide];
        }
            break;
    }
    
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
//    [PFAnalytics trackEvent:@"ColorPickerView Main Button Tapped"];

    if (self.delegate && [self.delegate respondsToSelector:@selector(colorPickerViewMainButtonTapped:)])
    {
        [self.delegate colorPickerViewMainButtonTapped:self];
    }
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
    UIColor *color = [UIColor colorWithRed:self.redSlider.slider.value/kColorPickerViewRGBScale
                                    green:self.greenSlider.slider.value/kColorPickerViewRGBScale
                                    blue:self.blueSlider.slider.value/kColorPickerViewRGBScale
                                    alpha:1];
    
    [self setPickedColor:color animated:NO];
}

- (void)hslDidSlide
{
    UIColor *color = [UIColor colorWithHue:self.hueSlider.slider.value/kColorPickerViewHueScale
                                saturation:MAX(self.saturationSlider.slider.value/kColorPickerViewSaturationBrightnessScale, 0.01)
                                brightness:MAX(self.brightnessSlider.slider.value/kColorPickerViewSaturationBrightnessScale, 0.01)
                                    alpha:1];
    
    [self setPickedColor:color animated:NO];
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
         [self refreshGradientUI];
         [self updateLabels];
     }
                     completion:nil];
}

#pragma mark - Private Methods

- (void)syncSlidersToColorAnimated:(BOOL)animated
{
    [self.hueSlider.slider setValue:self.pickedColor.hue * kColorPickerViewHueScale
                           animated:animated];
    [self.saturationSlider.slider setValue:self.pickedColor.saturation * kColorPickerViewSaturationBrightnessScale
                                  animated:animated];
    [self.brightnessSlider.slider setValue:self.pickedColor.brightness * kColorPickerViewSaturationBrightnessScale
                                  animated:animated];
    
    [self.redSlider.slider setValue:self.pickedColor.red * kColorPickerViewRGBScale
                           animated:animated];
    [self.greenSlider.slider setValue:self.pickedColor.green * kColorPickerViewRGBScale
                             animated:animated];
    [self.blueSlider.slider setValue:self.pickedColor.blue * kColorPickerViewRGBScale
                            animated:animated];
}

- (void)updateLabels
{
    NSString *formatString = @"%.0f";
    
    self.hueSlider.valueLabel.text = [NSString stringWithFormat:formatString, self.hueSlider.slider.value];
    self.saturationSlider.valueLabel.text = [NSString stringWithFormat:formatString, self.saturationSlider.slider.value];
    self.brightnessSlider.valueLabel.text = [NSString stringWithFormat:formatString, self.brightnessSlider.slider.value];
    
    self.redSlider.valueLabel.text = [NSString stringWithFormat:formatString, self.redSlider.slider.value];
    self.greenSlider.valueLabel.text = [NSString stringWithFormat:formatString, self.greenSlider.slider.value];
    self.blueSlider.valueLabel.text = [NSString stringWithFormat:formatString, self.blueSlider.slider.value];
    
//    NSString *hex = [UIColor hexStringOfColor:self.pickedColor];
//    self.hexValueLabel.text = hex;
    
    for (UILabel *label in @[self.hueSlider.titleLabel, self.hueSlider.valueLabel,
                             self.saturationSlider.titleLabel, self.saturationSlider.valueLabel,
                             self.brightnessSlider.titleLabel, self.brightnessSlider.valueLabel,
                             self.redSlider.titleLabel, self.redSlider.valueLabel,
                             self.greenSlider.titleLabel, self.greenSlider.valueLabel,
                             self.blueSlider.titleLabel, self.blueSlider.valueLabel])
    {
        [label setTextColor:self.pickedColor.contrastingColor];
    }
}

- (void)refreshGradientUI
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

- (void)setupUI
{
    //setup RGB sliders
    self.redSlider = [LabelledSlider labelledSlider:@"R"];
    self.greenSlider = [LabelledSlider labelledSlider:@"G"];
    self.blueSlider = [LabelledSlider labelledSlider:@"B"];
    
    self.redSlider.slider.maximumValue = kColorPickerViewRGBScale;
    self.greenSlider.slider.maximumValue = kColorPickerViewRGBScale;
    self.blueSlider.slider.maximumValue = kColorPickerViewRGBScale;

    self.redSlider.slider.tag = SliderNameRed;
    self.greenSlider.slider.tag = SliderNameGreen;
    self.blueSlider.slider.tag = SliderNameBlue;
    
    self.redSlider.slider.minimumTrackTintColor = [UIColor redColor];
    self.greenSlider.slider.minimumTrackTintColor = [UIColor greenColor];
    self.blueSlider.slider.minimumTrackTintColor = [UIColor blueColor];
    
    [self.rgbContainer addArrangedSubview:self.redSlider];
    [self.rgbContainer addArrangedSubview:self.greenSlider];
    [self.rgbContainer addArrangedSubview:self.blueSlider];
    
    //setup HSB sliders
    self.hueSlider = [LabelledSlider labelledSlider:@"H"];
    self.saturationSlider = [LabelledSlider labelledSlider:@"S"];
    self.brightnessSlider = [LabelledSlider labelledSlider:@"B"];
    
    self.hueSlider.slider.maximumValue = kColorPickerViewHueScale;
    self.saturationSlider.slider.maximumValue = kColorPickerViewSaturationBrightnessScale;
    self.brightnessSlider.slider.maximumValue = kColorPickerViewSaturationBrightnessScale;
    
    self.hueSlider.slider.tag = SliderNameHue;
    self.saturationSlider.slider.tag = SliderNameSaturation;
    self.brightnessSlider.slider.tag = SliderNameBrightness;

    [self.hsbContainer addArrangedSubview:self.hueSlider];
    [self.hsbContainer addArrangedSubview:self.saturationSlider];
    [self.hsbContainer addArrangedSubview:self.brightnessSlider];
    
    UIImage *clearTrackImage = [UIImage squareImageWithColor:[UIColor clearColor]
                                                        size:CGSizeMake(30, 30)];
    
    for (UISlider *slider in @[self.hueSlider.slider, self.saturationSlider.slider, self.brightnessSlider.slider])
    {
        [slider setMinimumTrackImage:clearTrackImage forState:UIControlStateNormal];
        [slider setMaximumTrackImage:clearTrackImage forState:UIControlStateNormal];
    }
    
    UIImage *thumb = [UIImage verticalLineImageWithColor:[UIColor blackColor] size:CGSizeMake(33, 33)];
    for (UISlider *slider in @[self.hueSlider.slider, self.saturationSlider.slider, self.brightnessSlider.slider, self.redSlider.slider, self.greenSlider.slider, self.blueSlider.slider])
    {
        [slider setThumbImage:thumb forState:UIControlStateNormal];
        [slider addTarget:self action:@selector(sliderValueChangedContinuous:) forControlEvents:UIControlEventValueChanged];
    }

}

//- (void)configureTapToCopyLabel
//{
//    UIGestureRecognizer *touchy = [[UITapGestureRecognizer alloc] initWithTarget:self.hexValueLabel action:@selector(handleTap:)];
//    [self.hexValueLabel addGestureRecognizer:touchy];
//}
//

#pragma mark - Getters

- (CAGradientLayer *)hueGradient
{
    if (!_hueGradient) {
        _hueGradient = [CAGradientLayer layer];
        _hueGradient.frame = self.hueSlider.slider.frame;
        
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
        _saturationGradient.frame = self.saturationSlider.slider.frame;
        
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
        _brightnessGradient.frame = self.brightnessSlider.slider.frame;
        
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

@end


@implementation UILabel (Clipboard)

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)copy:(id)sender
{
//    NSLog(@"Copy handler, label: “%@”.", self.text);
    [[UIPasteboard generalPasteboard] setString:self.text];
    
//    [PFAnalytics trackEvent:@"Hex label copied" dimensions:@{@"hex value" : self.text}];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copy:));
}

- (void)handleTap:(UIGestureRecognizer *)recognizer
{
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.frame inView:self.superview];
    [menu setMenuVisible:YES animated:YES];
}

@end


