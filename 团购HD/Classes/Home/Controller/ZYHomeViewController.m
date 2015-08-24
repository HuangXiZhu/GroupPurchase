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

@end

@implementation ZYHomeViewController

static NSString * const reuseIdentifier = @"ZYHomeViewControllerCell";

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.backgroundColor = ZYGlobalBg;
    
    [self setupLeftNar];
    
    [self setupRightNar];
    
    [self setupNotification];
}


#pragma mark ----setup系列

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
    
    [self loadNewDeals];
}

- (void)sortDidChange:(NSNotification *)notification
{
    self.selectedSort = notification.userInfo[ZYSelectSort];
    
    ZYHomeTopItem *homeTopItem = (ZYHomeTopItem *)self.sortItem.customView;
    [homeTopItem setSubTitle:self.selectedSort.label];
    
    [self loadNewDeals];
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
    
    [self loadNewDeals];
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
    
    [self loadNewDeals];
}

#pragma mark ----与服务器进行交互
- (void)loadNewDeals
{
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
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
    [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    
    NSLog(@"请求参数:%@", params);
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"请求成功--%@", result);
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



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
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
