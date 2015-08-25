//
//  ZYHomeViewController.m
//  团购HD
//
//  Created by 王志盼 on 15/8/9.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

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

@interface ZYHomeViewController () <DPRequestDelegate>
@property (nonatomic, weak) UIBarButtonItem *categoryItem;
@property (nonatomic, weak) UIBarButtonItem *districtItem;
@property (nonatomic, weak) UIBarButtonItem *sortItem;

/** 当前选中的城市名字 */
@property (nonatomic, copy) NSString *selectedCityName;
/** 当前选中的分类名字 */
@property (nonatomic, copy) NSString *selectedCategoryName;
/** 当前选中的区域名字 */
@property (nonatomic, copy) NSString *selectedRegionName;
/** 当前选中的排序 */
@property (nonatomic, strong) ZYSort *selectedSort;


@property (nonatomic, strong) NSMutableArray *deals;

@property (nonatomic, strong) DPRequest *lastRequest;

@property (nonatomic, assign) int currentPage;

@end

@implementation ZYHomeViewController

static NSString * const reuseIdentifier = @"ZYHomeViewControllerCell";

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

///**
// 当屏幕旋转,控制器view的尺寸发生改变调用
// */
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
    
    [self setupLeftNar];
    
    [self setupRightNar];
    
    [self setupNotification];
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

- (void)setupLeftNar
{
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:nil action:nil];
    logoItem.enabled = NO;
    
    ZYHomeTopItem *categoryTopItem = [ZYHomeTopItem homeTopItem];
    [categoryTopItem addTarget:self action:@selector(didClickCategoryTopItem)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryTopItem];
    self.categoryItem = categoryItem;
    
    ZYHomeTopItem *districtTopItem = [ZYHomeTopItem homeTopItem];
    [districtTopItem addTarget:self action:@selector(didClickDistrictTopItem)];
    UIBarButtonItem *districtItem = [[UIBarButtonItem alloc] initWithCustomView:districtTopItem];
    self.districtItem = districtItem;
    
    ZYHomeTopItem *sortTopItem = [ZYHomeTopItem homeTopItem];
    [sortTopItem setTitle:@"排序"];
    [sortTopItem setIcon:@"icon_sort" highIcon:@"icon_sort_highlighted"];
    [sortTopItem addTarget:self action:@selector(didClickSortTopItem)];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortTopItem];
    self.sortItem = sortItem;
    
    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, districtItem, sortItem];
}

- (void)setupRightNar
{
    UIBarButtonItem *mapItem = [UIBarButtonItem barButtonItemWithTarget:nil action:nil normalImage:@"icon_map" highImage:@"icon_map_highlighted"];
    mapItem.customView.width = 65;
    
    UIBarButtonItem *searchItem = [UIBarButtonItem barButtonItemWithTarget:nil action:nil normalImage:@"icon_search" highImage:@"icon_search_highlighted"];
    searchItem.customView.width = 65;
    
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
}

- (void)setupNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityDidChange:) name:ZYCityDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortDidChange:) name:ZYSortDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regionDidChange:) name:ZYRegionDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(caregoryDidChange:) name:ZYCategoryDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark ----receiveNotification调用的方法

- (void)cityDidChange:(NSNotification *)notification
{
    NSString *cityName = notification.userInfo[ZYSelectedCityName];
    self.selectedCityName = cityName;
    ZYHomeTopItem *homeTopItem = (ZYHomeTopItem *)self.districtItem.customView;
    [homeTopItem setTitle:[NSString stringWithFormat:@"%@ - 全部",cityName]];
    [homeTopItem setSubTitle:nil];
    
    [self loadDeals];
}

- (void)sortDidChange:(NSNotification *)notification
{
    self.selectedSort = notification.userInfo[ZYSelectSort];
    
    ZYHomeTopItem *homeTopItem = (ZYHomeTopItem *)self.sortItem.customView;
    [homeTopItem setSubTitle:self.selectedSort.label];
    
    [self loadDeals];
}

- (void)regionDidChange:(NSNotification *)notification
{
    ZYRegion *region = notification.userInfo[ZYSelectRegion];
    NSString *subReginName = notification.userInfo[ZYSelectSubregionName];
    
    if (subReginName == nil || [region.name isEqualToString:@"全部"]) {
        self.selectedRegionName = subReginName;
    }
    else{
        self.selectedRegionName = subReginName;
    }
    
    if ([subReginName isEqualToString:@"全部"]) {
        self.selectedRegionName = nil;
    }
    
    ZYHomeTopItem *homeTopItem = (ZYHomeTopItem *)self.districtItem.customView;
    [homeTopItem setTitle:[NSString stringWithFormat:@"%@ - %@", self.selectedCityName, region.name]];
    [homeTopItem setSubTitle:subReginName];
    
    [self loadDeals];
}

- (void)caregoryDidChange:(NSNotification *)notification
{
    ZYCategory *category = notification.userInfo[ZYSelectCategory];
    NSString *subcategoryName = notification.userInfo[ZYSelectSubcategoryName];
    
    if (subcategoryName == nil || [subcategoryName isEqualToString:@"全部"]) { // 点击的数据没有子分类
        self.selectedCategoryName = category.name;
    } else {
        self.selectedCategoryName = subcategoryName;
    }
    if ([self.selectedCategoryName isEqualToString:@"全部分类"]) {
        self.selectedCategoryName = nil;
    }
    
    ZYHomeTopItem *topItem = (ZYHomeTopItem *)self.categoryItem.customView;
    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    [topItem setTitle:category.name];
    [topItem setSubTitle:subcategoryName];
    
    [self loadDeals];
}

#pragma mark ----与服务器进行交互
- (void)loadNewDeals
{
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.currentPage);
    // 城市
    params[@"city"] = self.selectedCityName;
    // 每页的条数
    params[@"limit"] = @10;
    // 分类(类别)
    if (self.selectedCategoryName) {
        params[@"category"] = self.selectedCategoryName;
    }
    // 区域
    if (self.selectedRegionName) {
        params[@"region"] = self.selectedRegionName;
    }
    // 排序
    if (self.selectedSort) {
        params[@"sort"] = @(self.selectedSort.value);
    }
    
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
    NSLog(@"%@",result);
    int total_count = [result[@"total_count"] intValue];
    
    NSArray *newDeals = [ZYDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    if (self.currentPage == 1) {
        [self.deals removeAllObjects];
    }
    
    [self.deals addObjectsFromArray:newDeals];
    
    [self.collectionView reloadData];
    
    [self.collectionView.footer endRefreshing];
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"请求失败--%@", error);
}

#pragma mark ----clickItem
- (void)didClickCategoryTopItem
{
    UIPopoverController *popVc = [[UIPopoverController alloc] initWithContentViewController:[[ZYCategoryViewController alloc] init]];
    
    [popVc presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)didClickDistrictTopItem
{
    ZYDistrictViewController *districtTopItem = [[ZYDistrictViewController alloc] init];
    UIPopoverController *popVc = [[UIPopoverController alloc] initWithContentViewController:districtTopItem];
    if (self.selectedCityName) {
        ZYCity *city = [[[ZYMetaTool cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@",self.selectedCityName]] lastObject];
        districtTopItem.regions = city.regions;
    }
    [popVc presentPopoverFromBarButtonItem:self.districtItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)didClickSortTopItem
{
    ZYSortViewController *sortVc = [[ZYSortViewController alloc] init];
    UIPopoverController *sortPopVc = [[UIPopoverController alloc] initWithContentViewController:sortVc];
    
    [sortPopVc presentPopoverFromBarButtonItem:self.sortItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark ----刷新方法

- (void)heaerRefresh
{
    [self.collectionView.header endRefreshing];
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
    [self viewWillTransitionToSize:CGSizeMake(self.collectionView.width, self.collectionView.height) withTransitionCoordinator:nil];
    self.collectionView.footer.hidden = (self.deals.count == 0);
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
