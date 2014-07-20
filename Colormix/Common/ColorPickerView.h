//
//  ColorPickerView.h
//  Colormix
//
//  Created by Christian Hatch on 7/19/14.
//  Copyright (c) 2014 Commodoreftp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SliderName)
{
    SliderNameHue = 1,
    SliderNameSaturation,
    SliderNameBrightness,
    SliderNameRed,
    SliderNameGreen,
    SliderNameBlue
};

extern CGFloat const kColorPickerViewHueScale;
extern CGFloat const kColorPickerViewSaturationBrightnessScale;
extern CGFloat const kColorPickerViewRGBScale;

#define HUE_SCALE 360
#define SAT_BRIGHT_SCALE 100
#define RGB_SCALE 255

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

@class ColorPickerView;
@protocol ColorPickerViewDelegate <NSObject>

@required
- (UIColor *)colorPickerViewExternalColorRepresentation;

- (void)colorPickerViewDidSlideRGB:(ColorPickerView *)colorPickerView;

- (void)colorPickerViewDidSlideHSB:(ColorPickerView *)colorPickerView;

- (void)colorPickerViewMainButtonTapped:(ColorPickerView *)colorPickerView;

@end



@interface ColorPickerView : UIView

@property (weak, nonatomic) IBOutlet id <ColorPickerViewDelegate> delegate;

@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *sliderCollection;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelCollection;

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



+ (instancetype)colorPickerViewWithFrame:(CGRect)frame
                                delegate:(id <ColorPickerViewDelegate>)delegate;

- (void)updateUIAnimated:(BOOL)animated;

@end




