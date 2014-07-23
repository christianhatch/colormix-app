//
//  ColorPickerViewController.m
//  Colormix
//
//  Created by Christian Hatch on 2/6/14.
//  Copyright (c) 2014 Commodoreftp. All rights reserved.
//


#import "ColorPickerViewController.h"
#import <pop/POP.h>

#import "UIColor+Colormix.h"
#import "ColorPickerView.h"


@interface ColorPickerViewController () <ColorPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *colorPickerContainerView;
@property (weak, nonatomic) ColorPickerView *colorPickerView;

@end

@implementation ColorPickerViewController

#pragma mark - View Lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self applyRandomBGColor];
}

#pragma mark - ColorPickerViewDelegate

- (void)colorPickerViewMainButtonTapped:(ColorPickerView *)colorPickerView
{
    [self applyRandomBGColor];
}

- (void)colorPickerView:(ColorPickerView *)view pickedColorDidChange:(UIColor *)color
{
    [UIView animateWithDuration:0.5f
                          delay:0.0f
         usingSpringWithDamping:0.7f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionTransitionCrossDissolve
                     animations:^
     {
         self.view.backgroundColor = self.colorPickerView.pickedColor;
     }
                     completion:nil];
}

- (void)applyRandomBGColor
{
    [UIView animateWithDuration:0.5f
                          delay:0.0f
         usingSpringWithDamping:0.7f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionTransitionCrossDissolve
                     animations:^
     {
         [self.colorPickerView setPickedColor:[UIColor randomColor] animated:YES];
         self.view.backgroundColor = self.colorPickerView.pickedColor;
     }
                     completion:nil];
}

- (ColorPickerView *)colorPickerView
{
    if (!_colorPickerView) {
        _colorPickerView = [ColorPickerView colorPickerViewWithFrame:self.view.frame
                                                            delegate:self];
        
        _colorPickerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.colorPickerContainerView addSubview:_colorPickerView];
        
        UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [self.view addConstraints:@[
                                    [NSLayoutConstraint constraintWithItem:_colorPickerView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.colorPickerContainerView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:padding.top],
                                    
                                    [NSLayoutConstraint constraintWithItem:_colorPickerView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.colorPickerContainerView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:padding.left],
                                    
                                    [NSLayoutConstraint constraintWithItem:_colorPickerView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.colorPickerContainerView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:-padding.bottom],
                                    
                                    [NSLayoutConstraint constraintWithItem:_colorPickerView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.colorPickerContainerView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:-padding.right],
                                    
                                    ]];

    }
    return _colorPickerView; 
}


@end











