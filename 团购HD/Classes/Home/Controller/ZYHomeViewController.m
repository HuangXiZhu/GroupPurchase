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
#import "ZYDeal.h"
#import "MJExtension.h"
#import "ZYDealCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+AutoLayout.h"
#import "ZYSearchViewController.h"
#import "AwesomeMenu.h"
#import "ZYCollectViewController.h"
#import "ZYBrowseViewController.h"

@interface ZYHomeViewController () <AwesomeMenuDelegate>
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



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLeftNar];
    
    [self setupRightNar];
    
    [self setupAwesomeMenu];
    
    [self setupNotification];
    
    [self cityDidChange:nil];
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
    UIBarButtonItem *mapItem = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(didClickMapTopItem) normalImage:@"icon_map" highImage:@"icon_map_highlighted"];
    mapItem.customView.width = 65;
    
    UIBarButtonItem *searchItem = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(didClickSearchTopItem) normalImage:@"icon_search" highImage:@"icon_search_highlighted"];
    searchItem.customView.width = 65;
    
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
}

- (void)setupAwesomeMenu
{
    //initWithImage放背景图片，normal和highlighted状态下的背景图片
    //contentImage放具体要显示的图片
    AwesomeMenuItem *midItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:nil];
    
    AwesomeMenuItem *firstItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    AwesomeMenuItem *secoendItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_highlighted"]];
    AwesomeMenuItem *thirdItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_more_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_more_highlighted"]];
    AwesomeMenuItem *fourthItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    
    NSArray *items = @[firstItem, secoendItem, thirdItem, fourthItem];
    AwesomeMenu *awesome = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:midItem optionMenus:items];
    //开始点
    awesome.startPoint = CGPointMake(50, 150);
    //设置显示区域（也就是角度）
    awesome.menuWholeAngle = M_PI_2;
    
    awesome.delegate = self;
    //让中间按钮不旋转
    awesome.rotateAddButton = NO;
    awesome.alpha = 0.5;
    [self.view addSubview:awesome];
    
    [awesome autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [awesome autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    [awesome autoSetDimensionsToSize:CGSizeMake(200, 200)];
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
    if (notification == nil) {
        self.selectedCityName = @"广州";
    }
    ZYHomeTopItem *homeTopItem = (ZYHomeTopItem *)self.districtItem.customView;
    [homeTopItem setTitle:[NSString stringWithFormat:@"%@ - 全部",self.selectedCityName]];
    [homeTopItem setSubTitle:nil];
    
    [self.collectionView.header beginRefreshing];
}

- (void)sortDidChange:(NSNotification *)notification
{
    self.selectedSort = notification.userInfo[ZYSelectSort];
    
    ZYHomeTopItem *homeTopItem = (ZYHomeTopItem *)self.sortItem.customView;
    [homeTopItem setSubTitle:self.selectedSort.label];
    
    [self.collectionView.header beginRefreshing];
}

- (void)regionDidChange:(NSNotification *)notification
{
    ZYRegion *region = notification.userInfo[ZYSelectRegion];
    NSLog(@"++++++%@",region.name);
    NSString *subReginName = notification.userInfo[ZYSelectSubregionName];
    
    if (subReginName == nil || [region.name isEqualToString:@"全部"]) {
        self.selectedRegionName = nil;
    }
    else{
        self.selectedRegionName = subReginName;
    }
    
    if ([subReginName isEqualToString:@"全部"]) {
        self.selectedRegionName = nil;
    }
    
    ZYHomeTopItem *homeTopItem = (ZYHomeTopItem *)self.districtItem.customView;
    
    NSString *regionName = region.name;
    
    if (regionName == nil) {
        regionName = @"全部";
    }
    [homeTopItem setTitle:[NSString stringWithFormat:@"%@ - %@", self.selectedCityName, regionName]];
    [homeTopItem setSubTitle:subReginName];
    
    [self.collectionView.header beginRefreshing];
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
    
    [self.collectionView.header beginRefreshing];
}

#pragma mark ----与服务器进行交互
- (void)setParams:(NSMutableDictionary *)params
{
    // 城市
    params[@"city"] = self.selectedCityName;
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

- (void)didClickMapTopItem
{
    NSLog(@"-----didClickMapTopItem");
}

- (void)didClickSearchTopItem
{
    if (self.selectedCityName) {
        ZYSearchViewController *vc = [[ZYSearchViewController alloc] init];
        vc.cityName = self.selectedCityName;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        [MBProgressHUD showError:@"请您选择城市后再搜索..." toView:self.view];
    }
}

#pragma mark---- AwesomeMenuDelegate
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    
    [self awesomeMenuWillAnimateClose:menu];
    
    if (idx == 0) {
        ZYCollectViewController *vc = [[ZYCollectViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (idx == 1) {
        ZYBrowseViewController *vc = [[ZYBrowseViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu
{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    menu.alpha = 1.0;
}

- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu
{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    menu.alpha = 0.5;
}
@end
