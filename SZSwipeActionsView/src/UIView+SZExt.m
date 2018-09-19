//
//  SZSwipeListView.h
//  SZSwipeActionsView
//
//  Created by songzhou on 2018/7/24.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "UIView+SZExt.h"

@implementation UIView (SZExt)

- (NSArray<NSLayoutConstraint *> *)sz_extentToEdgesConstraintsWithView:(UIView *)view {
    return @[
             [self.leftAnchor constraintEqualToAnchor:view.leftAnchor],
             [self.rightAnchor constraintEqualToAnchor:view.rightAnchor],
             [self.topAnchor constraintEqualToAnchor:view.topAnchor],
             [self.bottomAnchor constraintEqualToAnchor:view.bottomAnchor],
             ];
}

@end
