//
//  UIView+AutoLayout.h
//  Fireworks-iOS
//
//  Created by Sid on 04/10/2016.
//
//

#import <UIKit/UIKit.h>

@interface UIView (AutoLayout)
- (void) constraintSubview: (UIView *)subview
                withInsets: (UIEdgeInsets)insets;

- (void) constraintSubview: (UIView *)subview;
@end
