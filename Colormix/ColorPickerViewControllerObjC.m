//
//  ColorPickerViewController.m
//  Colormix
//
//  Created by Christian Hatch on 2/6/14.
//  Copyright (c) 2014 Commodoreftp. All rights reserved.
//


#import "ColorPickerViewControllerObjC.h"

#import "UIColor+Colormix.h"
#import "ColorPickerViewObjC.h"


@interface ColorPickerViewControllerObjC () <ColorPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *colorPickerContainerView;
@property (weak, nonatomic) ColorPickerViewObjC *colorPickerView;

@end

@implementation ColorPickerViewControllerObjC


#pragma mark - Public API

- (void)applyColor:(UIColor *)color
{
    [UIView animateWithDuration:0.5f
                          delay:0.0f
         usingSpringWithDamping:0.7f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionTransitionCrossDissolve
                     animations:^
     {
         [self.colorPickerView setPickedColor:color animated:YES];
         self.view.backgroundColor = self.colorPickerView.pickedColor;
     }
                     completion:nil];
}





#pragma mark - View Lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self applyColor:[UIColor randomColor]];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self applyColor:self.colorPickerView.pickedColor];
//    [self.colorPickerView setPickedColor:self.colorPickerView.pickedColor animated:YES];
}


#pragma mark - ColorPickerViewDelegate

- (void)colorPickerViewMainButtonTapped:(ColorPickerViewObjC *)colorPickerView
{
    [self applyColor:[UIColor randomColor]];
}

- (void)colorPickerView:(ColorPickerViewObjC *)view pickedColorDidChange:(UIColor *)color
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

#pragma mark - Getters

- (ColorPickerViewObjC *)colorPickerView
{
    if (!_colorPickerView) {
        _colorPickerView = [ColorPickerViewObjC colorPickerViewWithFrame:self.view.frame
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











