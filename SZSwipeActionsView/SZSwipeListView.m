//
//  SZSwipeListView.m
//  SZSwipeActionsView
//
//  Created by songzhou on 2018/7/24.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "SZSwipeListView.h"
#import "UIView+SZExt.h"

@interface SZSwipeListView ()

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIView *contentView;

@property (nonatomic) UIStackView *contentStackView;
@property (nonatomic, copy) NSArray<SZSwipeRow *> *rows;

@end

@implementation SZSwipeListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // scroll view
        _scrollView = [UIScrollView new];
        _scrollView.alwaysBounceVertical = YES;
        [self addSubview:_scrollView];
        
        _contentView = [UIView new];
        [_scrollView addSubview:_contentView];

        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[_scrollView sz_extentToEdgesConstraintsWithView:self]];
        [NSLayoutConstraint activateConstraints:[_contentView sz_extentToEdgesConstraintsWithView:_scrollView]];

        [_contentView.widthAnchor constraintEqualToAnchor:_scrollView.widthAnchor].active = YES;
        NSLayoutConstraint *contentViewHeightConstraint = [_contentView.heightAnchor constraintLessThanOrEqualToAnchor:_scrollView.heightAnchor];
        contentViewHeightConstraint.priority = UILayoutPriorityDefaultLow;
        contentViewHeightConstraint.active = YES;
        
        // stack view
        _contentStackView = [UIStackView new];
        _contentStackView.axis = UILayoutConstraintAxisVertical;
        
        _contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView addSubview:_contentStackView];
        [NSLayoutConstraint activateConstraints:[_contentStackView sz_extentToEdgesConstraintsWithView:_contentView]];

    }
    return self;
}

#pragma mark - private
- (UIView *)_separatorLine {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor lightGrayColor];
    
    return view;
}


#pragma mark - API
- (void)reload {
    if (!self.viewForRow) {
        return;
    }

    [self.rows makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *mrows = [NSMutableArray array];
    for (int row = 0; row < self.numberOfRows; row++) {
        SZSwipeRow *view = self.viewForRow(row);
        UIView *line = [self _separatorLine];
        
        [view addSubview:line];
        
        line.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [line.leftAnchor constraintEqualToAnchor:view.leftAnchor],
                                                  [line.rightAnchor constraintEqualToAnchor:view.rightAnchor],
                                                  [line.bottomAnchor constraintEqualToAnchor:view.bottomAnchor],
                                                  [line.heightAnchor constraintEqualToConstant:1]
                                                  ]];
        
        [mrows addObject:view];
    }
    
    self.rows = [mrows copy];
    
    [self.rows enumerateObjectsUsingBlock:^(SZSwipeRow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentStackView addArrangedSubview:obj];
    }];
}

@end
