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

@interface SZSwipeListView : UIView

@property (nonatomic) NSUInteger numberOfRows;

@property (nonatomic, copy) SZSwipeRow *(^viewForRow)(NSInteger row);

- (void)reload;

@end

NS_ASSUME_NONNULL_END
