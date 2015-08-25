//
//  ZYDealViewController.m
//  团购HD
//
//  Created by 王志盼 on 15/8/25.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYDealViewController.h"
#import "ZYHomeViewController.h"
#import "ZYConst.h"
#import "UIBarButtonItem+ZYExtension.h"
#import "UIView+Extension.h"
#import "ZYHomeTopItem.h"
#import "ZYCategoryViewController.h"
#import "ZYDistrictViewController.h"
#import "ZYSort.h"
#import "ZYCity.h"
#import "ZYMetaTool.h"
#import "ZYSortViewController.h"
#import "ZYRegion.h"
#import "ZYCategory.h"
#import "DPAPI.h"
#import "ZYDeal.h"
#import "MJExtension.h"
#import "ZYDealCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+AutoLayout.h"

@interface ZYDealViewController () <DPRequestDelegate>

@property (nonatomic, strong) NSMutableArray *deals;

@property (nonatomic, strong) DPRequest *lastRequest;

@property (nonatomic, assign) int currentPage;

@property (nonatomic, assign) int totalCount;

/** 当没有团购数据时，显示一张没有数据的背景 */
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation ZYDealViewController

static NSString * const reuseIdentifier = @"ZYDealViewControllerCell";

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [UIImage imageNamed:@"icon_deals_empty"];
        [self.view addSubview:_backgroundImageView];
        [_backgroundImageView autoCenterInSuperview];
        
    }
    return _backgroundImageView;
}

- (NSMutableArray *)deals
{
    if (!_deals) {
        _deals = [NSMutableArray array];
    }
    return _deals;
}

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //设置cell的大小
    layout.itemSize = CGSizeMake(305, 305);
    return [self initWithCollectionViewLayout:layout];
}

/**
 当屏幕旋转,控制器view的尺寸发生改变调用
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // 根据屏幕宽度决定列数
    int cols = (size.width == 1024) ? 3 : 2;
    // 根据列数计算内边距
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat inset = (size.width - cols * layout.itemSize.width) / (cols + 1);
    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    // 设置每一行之间的间距
    layout.minimumLineSpacing = inset;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCollection];
    
}


#pragma mark ----setup系列

- (void)setupCollection
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZYDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.backgroundColor = ZYGlobalBg;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(heaerRefresh)];
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}

#pragma mark ----与服务器进行交互
- (void)loadNewDeals
{
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //让子类自行设置响应的参数
    [self setParams:params];
    params[@"page"] = @(self.currentPage);
    // 每页的条数
    params[@"limit"] = @10;
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    
    //    NSLog(@"请求参数:%@", params);
}

- (void)loadDeals
{
    self.currentPage = 1;
    [self loadNewDeals];
}

- (void)loadMoreDeals
{
    self.currentPage++;
    [self loadNewDeals];
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request != self.lastRequest) {  //如果不是同一个请求，是短时间内发了两次请求，那么只要最近的一次请求
        return;
    }
    self.totalCount = [result[@"total_count"] intValue];
    
    NSArray *newDeals = [ZYDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    if (self.currentPage == 1) {
        [self.deals removeAllObjects];
    }
    
    [self.deals addObjectsFromArray:newDeals];
    
    [self.collectionView reloadData];
    
    [self.collectionView.footer endRefreshing];
    [self.collectionView.header endRefreshing];
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (self.lastRequest != request) {
        return;
    }
    //在ipad开发中，如果要显示HUD，特别需要注意，显示到self.view上
    //    [MBProgressHUD showError:@"加载失败，请检查您的网络..."];
    
    [MBProgressHUD showError:@"加载失败，请检查您的网络..." toView:self.view];
    
    
    [self.collectionView.footer endRefreshing];
    
    //当不是请求第一页的时候，如果请求失败，那么应当减去这次请求的
    self.currentPage--;
}


#pragma mark ----刷新方法

- (void)heaerRefresh
{
    [self loadDeals];
}

- (void)footerRefresh
{
    [self loadMoreDeals];
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //需要在请求发送就设置以此cell的布局
    [self viewWillTransitionToSize:CGSizeMake(self.collectionView.width, self.collectionView.height) withTransitionCoordinator:nil];
    //第一次进入界面，self.totalCount会被初始化为0
    self.collectionView.footer.hidden = (self.totalCount == self.deals.count);
    self.backgroundImageView.hidden = (self.deals.count != 0);
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZYDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.deal = self.deals[indexPath.row];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end
