//
//  ViewController.m
//  SZSwipeActionsView
//
//  Created by songzhou on 2018/7/24.
//  Copyright © 2018年 songzhou. All rights reserved.
//

#import "ViewController.h"
#import "SZSwipeListView.h"

@interface ViewController ()

@property (nonatomic) SZSwipeListView *listView;

@end

@implementation ViewController

@dynamic view;
- (void)loadView {
    UIView *v = [UIView new];
    
    _listView = [SZSwipeListView new];
    [v addSubview:_listView];
    
    
    self.view = v;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.listView.numberOfRows = 5;
    self.listView.viewForRow = ^SZSwipeRow * _Nonnull(NSInteger row) {
        SZSwipeRow *rowView = [SZSwipeRow new];
        rowView.titleLabel.text = [@(row) stringValue];
        
        return rowView;
    };
    
    [self.listView reload];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _listView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
