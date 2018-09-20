//
//  SZSwipeListView.m
//  SZSwipeActionsView
//
//  Created by songzhou on 2018/7/24.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "SZSwipeListView.h"
#import "UIView+SZExt.h"

static const CGFloat REVEAL_THRESHOLD = 44;

@interface SZSwipeListView ()

@property (nonatomic) UIStackView *contentStackView;
@property (nonatomic, copy) NSArray<SZSwipeRow *> *rows;

@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic) SZSwipeRow *currentSwipeRow;

@end

@implementation SZSwipeListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // stack view
        _contentStackView = [UIStackView new];
        _contentStackView.axis = UILayoutConstraintAxisVertical;
        
        _contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_contentStackView];
        [NSLayoutConstraint activateConstraints:[_contentStackView sz_extentToEdgesConstraintsWithView:self]];

        // gesture
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        [_contentStackView addGestureRecognizer:_panGestureRecognizer];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [_contentStackView addGestureRecognizer:tapGestureRecognizer];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - private
- (UIView *)_separatorLine {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor lightGrayColor];
    
    return view;
}

- (void)_hideSwipe {
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGPoint originCenter = CGPointMake(CGRectGetMidX(self.currentSwipeRow.bounds), self.currentSwipeRow.center.y);
                         self.currentSwipeRow.center = originCenter;
                     }
                     completion:nil];
}

- (void)_reveal {
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGPoint newCenter =  CGPointMake(CGRectGetMidX(self.currentSwipeRow.bounds)- [self _actionsViewWidth], self.currentSwipeRow.center.y);
                         self.currentSwipeRow.center = newCenter;
                     }
                     completion:nil];
}

- (CGFloat)_actionsViewWidth {
    return CGRectGetWidth(self.currentSwipeRow.actionsView.bounds);
}

#pragma mark - actions
- (void)onPan:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:sender.view];
    CGPoint translation = [sender translationInView:sender.view.superview];
    
    CGPoint originCenter = CGPointMake(CGRectGetMidX(_currentSwipeRow.bounds), _currentSwipeRow.center.y);
    CGPoint newCenter =  CGPointMake(_currentSwipeRow.center.x + translation.x, _currentSwipeRow.center.y);
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        __block SZSwipeRow *swipeRow;
        [self.rows enumerateObjectsUsingBlock:^(SZSwipeRow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj pointInside:[obj convertPoint:location fromView:sender.view] withEvent:nil]) {
                swipeRow = obj;
            }
        }];
        
        [self _hideSwipe];
        _currentSwipeRow = swipeRow;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        if (fabs(newCenter.x - originCenter.x) < [self _actionsViewWidth] && newCenter.x < originCenter.x) { // only supoport swipe left
            _currentSwipeRow.center = newCenter;
        }
        
        [sender setTranslation:CGPointZero inView:sender.view.superview];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (originCenter.x - newCenter.x > REVEAL_THRESHOLD) {
            [self _reveal];
        } else {
            [self _hideSwipe];
        }
    }
}

- (void)onTap:(UITapGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:sender.view];
    
    __block NSUInteger rowIndex = NSNotFound;
    __block NSUInteger actionIndex = NSNotFound;
    [self.rows enumerateObjectsUsingBlock:^(SZSwipeRow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint pointInRow = [obj convertPoint:location fromView:sender.view];
        if ([obj pointInside:pointInRow withEvent:nil]) {
            rowIndex = idx;
            *stop = YES;
            return;
        }
        
        CGPoint pointInActionsView = [obj.actionsView convertPoint:location fromView:sender.view];
        if ([obj.actionsView pointInside:pointInActionsView withEvent:nil]) {
            [obj.actionsView.actionViews enumerateObjectsUsingBlock:^(SZSwipeRowActionView * _Nonnull actionView, NSUInteger actionViewIdx, BOOL * _Nonnull stop) {
                if ([actionView pointInside:[actionView convertPoint:pointInActionsView fromView:obj.actionsView] withEvent:nil]) {
                    rowIndex = idx;
                    actionIndex = actionViewIdx;
                }
            }];
            *stop = YES;
            return;
        }
        
    }];
    
    if (rowIndex != NSNotFound) {
        if (actionIndex != NSNotFound) {
            if (self.actionSelectionHander) {
                self.actionSelectionHander(rowIndex, actionIndex);
            }
            
            [self _hideSwipe];
        } else {
            [self _hideSwipe];
            
            if (self.selectionHandler) {
                self.selectionHandler(rowIndex);
            }
        }
    }

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
        
        if (self.actionHandler) {
            view.actions = self.actionHandler(row);
        }
        
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
