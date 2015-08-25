//
//  ZYSearchViewController.m
//  团购HD
//
//  Created by 王志盼 on 15/8/25.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYSearchViewController.h"
#import "UIBarButtonItem+ZYExtension.h"
#import "MJRefresh.h"

@interface ZYSearchViewController () <UISearchBarDelegate>
@property (nonatomic, weak) UISearchBar *searchBar;
@end

@implementation ZYSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNar];
}

#pragma mark ----setup系列
- (void)setupNar
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(didClickLeftBarButtonItem) normalImage:@"icon_back" highImage:@"icon_back_highlighted"];
    
    
//    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 35)];
//    searchView.backgroundColor = [UIColor clearColor];
//    searchView.backgroundColor = [UIColor redColor];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, 280, 35)];
    searchBar.placeholder = @"请输入关键词";
    searchBar.delegate = self;
    
    //如果不想让searchBar随着拉升，可以将它添加到UIView里面，再将UIView放到titleView里面
//    [searchView addSubview:searchBar];
    self.navigationItem.titleView = searchBar;
    self.searchBar = searchBar;
}

- (void)setParams:(NSMutableDictionary *)params
{
    params[@"city"] = @"北京";
    params[@"keyword"] = self.searchBar.text;
}

#pragma mark ----click事件
- (void)didClickLeftBarButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ----UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.collectionView.header beginRefreshing];
    
    [self.searchBar resignFirstResponder];
}


@end
