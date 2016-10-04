//
//  UIView+AutoLayout.m
//  Fireworks-iOS
//
//  Created by Sid on 04/10/2016.
//
//

#import "UIView+AutoLayout.h"

@implementation UIView (AutoLayout)

- (void) constraintSubview: (UIView *)subview
                withInsets: (UIEdgeInsets)insets {

    NSAssert(subview.superview != nil, @"subview not added to the receiver");

    [subview setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-top-[subview]-bottom-|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                                metrics:@{@"top": @(insets.top), @"bottom": @(insets.bottom)}
                               views:NSDictionaryOfVariableBindings(subview)]];

    [self addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-left-[subview]-right-|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:@{@"left": @(insets.left), @"right": @(insets.right)}
                               views:NSDictionaryOfVariableBindings(subview)]];
}

- (void) constraintSubview: (UIView *)subview {
    [self constraintSubview:subview withInsets:UIEdgeInsetsZero];
}

@end
