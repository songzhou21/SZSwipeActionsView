//
//  SZSwipeListView.h
//  SZSwipeActionsView
//
//  Created by songzhou on 2018/7/24.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZSwipeRow.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^SZSwipeListViewVoidBlock)(void);
typedef void (^SZSwipeListViewSelectForRowBlock)(NSUInteger row);
typedef void (^SZSwipeListViewSelectForActionInRowBlock)(NSUInteger row, NSUInteger actionIndex);

typedef NSArray<SZSwipeRowAction *> *(^SZSwipeListViewActionForRowBlock)(NSInteger row);

@interface SZSwipeListView : UIView

@property (nonatomic) NSUInteger numberOfRows;

@property (nonatomic, copy) SZSwipeRow *(^viewForRow)(NSInteger row);
@property (nonatomic, copy) SZSwipeListViewActionForRowBlock actionHandler;

@property (nonatomic, copy) SZSwipeListViewSelectForRowBlock selectionHandler;
@property (nonatomic, copy) SZSwipeListViewSelectForActionInRowBlock actionSelectionHander;


- (void)reload;

@end

NS_ASSUME_NONNULL_END
