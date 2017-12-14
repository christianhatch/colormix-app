//
//  ColorPickerViewController.m
//  Colormix
//
//  Created by Christian Hatch on 2/6/14.
//  Copyright (c) 2014 Commodoreftp. All rights reserved.
//


#import "ColorPickerViewController.h"
#import "UIColor+Colormix.h"
#import "ColorPickerView.h"
#import <ColorMix/ColorMix.h>

@implementation UILabel (Clipboard)

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.text];
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



@interface ColorPickerViewController () <ColorPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *colorPickerContainerView;
@property (weak, nonatomic) ColorPickerView *colorPickerView;
@property (weak, nonatomic) IBOutlet UILabel *hexValueLabel;

@end


@implementation ColorPickerViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureTapToCopyLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self applyColor:[UIColor randomColor]];
}

- (BOOL)prefersStatusBarHidden
{
    return true;
}

#pragma mark - Methods

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
     }
                     completion:nil];
}

- (void)configureTapToCopyLabel
{
    self.hexValueLabel.userInteractionEnabled = YES;
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.hexValueLabel action:@selector(handleTap:)];
    [self.hexValueLabel addGestureRecognizer:tap];
}


#pragma mark - ColorPickerViewDelegate

- (void)colorPickerView:(ColorPickerView *)view pickedColorDidChange:(UIColor *)color
{
    [UIView animateWithDuration:0.5f
                          delay:0.0f
         usingSpringWithDamping:0.7f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionTransitionCrossDissolve
                     animations:^
     {
         self.view.backgroundColor = color;
         
         NSString *hex = [UIColor hexStringOfColor:color];
         self.hexValueLabel.text = hex;
         self.hexValueLabel.textColor = color.contrastingColor;
     }
                     completion:nil];
}

#pragma mark - Getters

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









