//
//  SZSwipeActionView.m
//  SZSwipeActionsView
//
//  Created by songzhou on 2018/7/24.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "SZSwipeRow.h"
#import "UIView+SZExt.h"

static const CGFloat ACTION_MINI_WIDTH = 60;

@implementation SZSwipeRowAction

@end

@implementation SZSwipeRowActionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.titleLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:8],
                                                  [self.titleLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-8],
                                                  [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
                                                  ]];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize compressedSize = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return CGSizeMake(MAX(ACTION_MINI_WIDTH, compressedSize.width) , compressedSize.height);
}

@end

@implementation SZSwipeRowActionContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setActionViews:(NSArray<SZSwipeRowActionView *> *)actionViews {
    [_actionViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _actionViews = actionViews;
    
    [_actionViews enumerateObjectsUsingBlock:^(SZSwipeRowActionView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat h = CGRectGetHeight(self.bounds);
    CGFloat actionViewOriginX = 0;
    for (int i = 0; i < _actionViews.count; i++) {
        SZSwipeRowActionView *actionView = _actionViews[i];
        [actionView sizeToFit];
        
        CGFloat actionViewW = CGRectGetWidth(actionView.bounds);
        actionView.frame = CGRectMake(actionViewOriginX, 0, actionViewW, h);
        actionViewOriginX += actionViewW;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (!_actionViews) {
        return size;
    }
    
   
    CGFloat actionViewW = 0;
    for (int i = 0; i < _actionViews.count; i++) {
        SZSwipeRowActionView *actionView = _actionViews[i];
        [actionView sizeToFit];
        
        actionViewW += CGRectGetWidth(actionView.bounds);
    }
    
    return CGSizeMake(actionViewW, size.height);
}

@end

@interface SZSwipeRow ()

@end

@implementation SZSwipeRow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];

        _titleLabel = [UILabel new];
        [_contentView addSubview:_titleLabel];

        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[_contentView sz_extentToEdgesConstraintsWithView:self]];
        
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [_titleLabel.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:8],
                                                  [_titleLabel.rightAnchor constraintLessThanOrEqualToAnchor:self.contentView.rightAnchor constant:-8],
                                                  [_titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8],
                                                  [_titleLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8],
                                                  ]];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    
    if (_actionsView) {
        [_actionsView sizeToFit];
        _actionsView.frame = CGRectMake(w, 0, CGRectGetWidth(_actionsView.bounds), h);
    }
}

#pragma mark - setter
- (void)setActions:(NSArray<SZSwipeRowAction *> *)actions {
    _actions = actions;
    
    if (!_actionsView) {
        _actionsView = [SZSwipeRowActionContainerView new];
        [self.contentView addSubview:_actionsView];
    }
    
    NSMutableArray *actionViews = [NSMutableArray arrayWithCapacity:actions.count];
    for (SZSwipeRowAction *action in actions) {
        SZSwipeRowActionView *v = [SZSwipeRowActionView new];
        v.titleLabel.text = action.title;
        v.backgroundColor = action.backgroundColor;
        v.titleLabel.textColor = action.titleColor;
        
        [actionViews addObject:v];
    }
    
    _actionsView.actionViews = actionViews;
}

#pragma mark - getter
@end
