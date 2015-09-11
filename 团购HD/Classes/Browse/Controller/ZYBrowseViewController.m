//
//  ZYBrowseViewController.m
//  团购HD
//
//  Created by 王志盼 on 15/9/6.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYBrowseViewController.h"
#import "MJRefresh.h"
#import "ZYConst.h"
#import "ZYDealTool.h"
@interface ZYBrowseViewController ()

@end

@implementation ZYBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadDeals];
}


- (NSString *)bgImageName
{
    return @"icon_latestBrowse_empty";
}

- (NSArray *)arrayWithCurretnPage:(int)currentPage
{
    return [ZYDealTool browseDeals:currentPage];
}

- (int)countForDeals
{
    return [ZYDealTool browseDealsCount];
}

- (NSString *)titleForNavBar
{
    return @"浏览记录";
}
#pragma mark ----与数据库进行交互
- (void)loadDeals
{
    [self.collectionView.footer beginRefreshing];
}

- (void)deletedSqliteDeal:(ZYDeal *)deal
{
    [ZYDealTool removeBrowseDeal:deal];
}

@end
