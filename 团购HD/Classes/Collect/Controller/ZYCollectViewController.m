//
//  ZYCollectViewController.m
//  团购HD
//
//  Created by 王志盼 on 15/9/2.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYCollectViewController.h"
#import "ZYDeal.h"
#import "ZYConst.h"
#import "MJRefresh.h"
#import "UIView+Extension.h"
#import "ZYDealCell.h"
#import "ZYDetailViewController.h"
#import "ZYDealTool.h"
#import "UIBarButtonItem+ZYExtension.h"

@interface ZYCollectViewController ()
@end

@implementation ZYCollectViewController


- (NSString *)bgImageName
{
    return @"icon_collects_empty";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNotification];
    
    [self loadDeals];
}

#pragma mark ----setup系列



- (void)setupNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectStateDidChange:) name:ZYCollectStateDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ----与数据库进行交互
- (void)loadDeals
{
    [self.collectionView.footer beginRefreshing];
}

#pragma mark ----notification系列
- (void)collectStateDidChange:(NSNotification *)note
{
    [self removeDealsAllObjects];
    [self loadDeals];
}

#pragma mark ----其他
- (NSArray *)arrayWithCurretnPage:(int)currentPage
{
    return [ZYDealTool collectDeals:currentPage];
}

- (int)countForDeals
{
    return [ZYDealTool collectDealsCount];
}

- (NSString *)titleForNavBar
{
    return @"收藏";
}
@end
