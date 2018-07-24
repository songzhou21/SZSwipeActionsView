//
//  SZSwipeActionView.m
//  SZSwipeActionsView
//
//  Created by songzhou on 2018/7/24.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "SZSwipeRow.h"

@implementation SZSwipeRow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [UILabel new];
        
        [self addSubview:_titleLabel];
        
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [_titleLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:8],
                                                  [_titleLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-8],
                                                  [_titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
                                                  ]];
    }
    
    return self;
}

- (CGSize)intrinsicContentSize {
    CGFloat height = MAX(44, _titleLabel.intrinsicContentSize.height + 16);
    return CGSizeMake(UIViewNoIntrinsicMetric, height);
}

@end
