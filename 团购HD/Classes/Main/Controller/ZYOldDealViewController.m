//
//  ZYOldDealViewController.m
//  团购HD
//
//  Created by 王志盼 on 15/9/6.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYOldDealViewController.h"
#import "ZYDeal.h"
#import "UIView+AutoLayout.h"
#import "ZYConst.h"
#import "MJRefresh.h"
#import "UIView+Extension.h"
#import "ZYDealCell.h"
#import "ZYDetailViewController.h"
#import "ZYDealTool.h"
#import "UIBarButtonItem+ZYExtension.h"

@interface ZYOldDealViewController ()
/** 当没有团购数据时，显示一张没有数据的背景 */
@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) NSMutableArray *deals;

@property (nonatomic, assign) int currentPage;

@property (nonatomic, strong) UIBarButtonItem *backItem;

@property (nonatomic, strong) UIBarButtonItem *selectedAllItem;

@property (nonatomic, strong) UIBarButtonItem *unselectedAllItem;

@property (nonatomic, strong) UIBarButtonItem *delectedItem;
@end

@implementation ZYOldDealViewController

static NSString * const reuseIdentifier = @"ZYDealViewControllerCell";

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        NSString *imageName = [self bgImageName];
        _backgroundImageView.image = [UIImage imageNamed:imageName];
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

#pragma mark ----barButtonItem的懒加载
- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(clickbackItem) normalImage:@"icon_back" highImage:@"icon_back_highlighted"];
    }
    return _backItem;
}

- (UIBarButtonItem *)selectedAllItem
{
    if (!_selectedAllItem) {
        _selectedAllItem = [[UIBarButtonItem alloc] initWithTitle:@"  全选  " style:UIBarButtonItemStyleDone target:self action:@selector(clickSelectedAllItem)];
    }
    return _selectedAllItem;
}

- (UIBarButtonItem *)unselectedAllItem
{
    if (!_unselectedAllItem) {
        _unselectedAllItem = [[UIBarButtonItem alloc] initWithTitle:@"  全不选  " style:UIBarButtonItemStyleDone target:self action:@selector(clickUnselectedAllItem)];
    }
    return _unselectedAllItem;
}

- (UIBarButtonItem *)delectedItem
{
    if (!_delectedItem) {
        _delectedItem = [[UIBarButtonItem alloc] initWithTitle:@"  删除  " style:UIBarButtonItemStyleDone target:self action:@selector(clickDelectedItem)];
    }
    return _delectedItem;
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
    
    [self setupNav];
    
    [self setupNavItem];
    
    [self setupCollection];
    
    [self loadMoreDeals];
}

#pragma mark ----setup系列
- (void)setupNav
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor] = [UIColor blackColor];
    
    
    textAttrs[UITextAttributeFont] = [UIFont boldSystemFontOfSize:20];//粗体，
    // UIOffsetZero是结构体, 只要包装成NSValue对象, 才能放进字典\数组中
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textAttrs];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(clickEditBarButton:)];
    
    self.navigationItem.leftBarButtonItems = @[self.backItem];
    
    self.navigationItem.title = [self titleForNavBar];
}

- (void)setupNavItem
{
    //通过设置这个属性，可是设置整个导航栏的UIBarButtonItem的属性
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    //设置普通状态下得文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    //文字颜色
    textAttrs[NSForegroundColorAttributeName] = ZYColor(47,188,173);
    //文字字体
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:18.0];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
}

- (void)setupCollection
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZYDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.backgroundColor = ZYGlobalBg;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    
}

#pragma mark ----与数据库进行交互
- (void)loadMoreDeals
{
    self.currentPage++;
    
    NSArray *tempArray = [self arrayWithCurretnPage:self.currentPage];
    
    [self.deals addObjectsFromArray:tempArray];
    
    [self.collectionView reloadData];
    
    [self.collectionView.footer endRefreshing];
}


#pragma mark ----刷新方法
- (void)footerRefresh
{
    [self loadMoreDeals];
}

#pragma mark ----click事件

- (void)clickbackItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickEditBarButton:(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:@"完成"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(clickEditBarButton:)];
        self.navigationItem.leftBarButtonItems = @[self.backItem];
    }
    else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(clickEditBarButton:)];
        self.navigationItem.leftBarButtonItems = self.navigationItem.leftBarButtonItems = @[self.backItem, self.selectedAllItem, self.unselectedAllItem, self.delectedItem];
    }
}

- (void)clickSelectedAllItem
{
    NSLog(@"----clickSelectedAllItem");
}

- (void)clickUnselectedAllItem
{
    NSLog(@"----clickUnselectedAllItem");
}

- (void)clickDelectedItem
{
    NSLog(@"----clickDelectedItem");
}


#pragma mark ----其他
- (void)removeDealsAllObjects
{
    [self.deals removeAllObjects];
    self.currentPage = 0;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //需要在请求发送就设置以此cell的布局
    [self viewWillTransitionToSize:CGSizeMake(self.collectionView.width, self.collectionView.height) withTransitionCoordinator:nil];
    
    self.backgroundImageView.hidden = (self.deals.count != 0);
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZYDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.deal = self.deals[indexPath.row];
    
    self.collectionView.footer.hidden = (self.deals.count == [self countForDeals]);
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZYDetailViewController *detailVc = [[ZYDetailViewController alloc] initWithNibName:@"ZYDetailViewController" bundle:nil];
    detailVc.deal = self.deals[indexPath.row];
    [self presentViewController:detailVc animated:YES completion:nil];
}

@end
