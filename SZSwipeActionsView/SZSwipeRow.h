//
//  SZSwipeActionView.h
//  SZSwipeActionsView
//
//  Created by songzhou on 2018/7/24.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SZSwipeRowAction;
typedef void(^SZSwipeRowActionHandler)(SZSwipeRowAction *action);

@interface SZSwipeRowAction : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) UIColor *titleColor;
@property (nonatomic, copy) SZSwipeRowAction *handler;

@end

@interface SZSwipeRowActionView : UIView

@property (nonatomic) UILabel *titleLabel;

@end

@interface SZSwipeRowActionContainerView : UIView

@property (nonatomic, copy) NSArray<SZSwipeRowActionView *> *actionViews;

@end

@interface SZSwipeRow : UIView

@property (nonatomic) UIView *contentView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic, copy) NSArray<SZSwipeRowAction *> *actions;
@property (nonatomic) SZSwipeRowActionContainerView *actionsView;


@end
