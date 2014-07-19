//
//  ColorPickerViewController.m
//  Colormix
//
//  Created by Christian Hatch on 2/6/14.
//  Copyright (c) 2014 Commodoreftp. All rights reserved.
//


#import "ColorPickerViewController.h"
#import <FlurrySDK/Flurry.h>
#import <pop/POP.h>

#import "UIColor+Colormix.h"
#import "ColorPickerView.h"


@interface ColorPickerViewController () <ColorPickerViewDelegate>

@property (weak, nonatomic) IBOutlet ColorPickerView *colorPickerView;

@end

@implementation ColorPickerViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self applyRandomBGColor];
}

#pragma mark - ColorPickerViewDelegate

- (void)colorPickerViewDidSlideHSB:(ColorPickerView *)colorPickerView
{
    NSLog(@"did slide hsb");
    [self hslDidSlide];
}

- (void)colorPickerViewDidSlideRGB:(ColorPickerView *)colorPickerView
{
    NSLog(@"did slide rgb");
    [self rgbDidSlide];
}

- (void)colorPickerViewMainButtonTapped:(ColorPickerView *)colorPickerView
{
    NSLog(@"did tap main button");
    [self applyRandomBGColor];
}

- (UIColor *)colorPickerViewExternalColorRepresentation
{
    return self.view.backgroundColor;
}




- (void)rgbDidSlide
{
    self.view.backgroundColor = [UIColor colorWithRed:self.colorPickerView.redSlider.value/RGB_SCALE
                                                green:self.colorPickerView.greenSlider.value/RGB_SCALE
                                                 blue:self.colorPickerView.blueSlider.value/RGB_SCALE
                                                alpha:1];
}

- (void)hslDidSlide
{
    self.view.backgroundColor = [UIColor colorWithHue:self.colorPickerView.hueSlider.value/HUE_SCALE
                                           saturation:MAX(self.colorPickerView.saturationSlider.value/SAT_BRIGHT_SCALE, 0.01)
                                           brightness:MAX(self.colorPickerView.brightnessSlider.value/SAT_BRIGHT_SCALE, 0.01)
                                                alpha:1];
}

- (void)applyRandomBGColor
{
    POPSpringAnimation *bg = [POPSpringAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    bg.toValue = (id)[UIColor randomColor].CGColor;
    [self.view pop_addAnimation:bg forKey:@"changeBGColor"];
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
     //         usingSpringWithDamping:0.7f
     //          initialSpringVelocity:1.0f
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionTransitionCrossDissolve
                     animations:^
     {
         self.view.backgroundColor = [UIColor randomColor];
     }
                     completion:nil];

    
    [self.colorPickerView updateUIAnimated:YES];
}



@end











