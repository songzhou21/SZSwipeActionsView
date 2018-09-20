//
//  ViewController.m
//  SZSwipeActionsView
//
//  Created by songzhou on 2018/7/24.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "ViewController.h"
#import "SZSwipeListView.h"

@interface SZCustomSwipeRow : SZSwipeRow

@end


@implementation SZCustomSwipeRow

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, 80);
}

@end

@interface ViewController ()

@property (nonatomic) SZSwipeListView *listView;

@end

@implementation ViewController

@dynamic view;
- (void)loadView {
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor whiteColor];
    
    _listView = [SZSwipeListView new];
    [v addSubview:_listView];
    
    _listView.translatesAutoresizingMaskIntoConstraints = NO;
    [_listView.leftAnchor constraintEqualToAnchor:v.leftAnchor].active = YES;
    [_listView.topAnchor constraintEqualToAnchor:v.topAnchor].active = YES;
    [_listView.rightAnchor constraintEqualToAnchor:v.rightAnchor].active = YES;
    [_listView.bottomAnchor constraintLessThanOrEqualToAnchor:v.bottomAnchor].active = YES;
    
    self.view = v;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.listView.numberOfRows = 2;
    self.listView.viewForRow = ^SZSwipeRow * _Nonnull(NSInteger row) {
        SZCustomSwipeRow *rowView = [SZCustomSwipeRow new];
        rowView.titleLabel.text = [@(row) stringValue];
        
        return rowView;
    };
    
    self.listView.actionHandler = ^NSArray<SZSwipeRowAction *> *(NSInteger row) {
        SZSwipeRowAction *o = [SZSwipeRowAction new];
        o.title = @"Delete";
        o.backgroundColor = [UIColor redColor];
        o.titleColor = [UIColor whiteColor];
        
        SZSwipeRowAction *o2 = [SZSwipeRowAction new];
        o2.title = @"Add";
        o2.backgroundColor = [UIColor blueColor];
        o2.titleColor = [UIColor whiteColor];
        
        return @[o, o2];
    };
    
    self.listView.selectionHandler = ^(NSUInteger row) {
        NSLog(@"select row:%d", (int)row);
    };
    
    self.listView.actionSelectionHander = ^(NSUInteger row, NSUInteger actionIndex) {
        NSLog(@"select row:%d action:%d", (int)row, (int)actionIndex);
    };
    
    [self.listView reload];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
