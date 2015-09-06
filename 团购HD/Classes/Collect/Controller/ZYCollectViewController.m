//
//  ZYCollectViewController.m
//  团购HD
//
//  Created by 王志盼 on 15/9/2.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYCollectViewController.h"
#import "ZYDeal.h"
#import "UIView+AutoLayout.h"
#import "ZYConst.h"
#import "MJRefresh.h"
#import "UIView+Extension.h"
#import "ZYDealCell.h"
#import "ZYDetailViewController.h"
#import "ZYDealTool.h"

@interface ZYCollectViewController ()
/** 当没有团购数据时，显示一张没有数据的背景 */
@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) NSMutableArray *deals;

@property (nonatomic, assign) int currentPage;
@end

@implementation ZYCollectViewController

static NSString * const reuseIdentifier = @"ZYCollectViewControllerCell";

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [UIImage imageNamed:@"icon_collects_empty"];
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
    
    [self setupNotification];
}

#pragma mark ----setup系列

- (void)setupCollection
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZYDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.backgroundColor = ZYGlobalBg;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}

- (void)setupNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectStateDidChange:) name:ZYCollectStateDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ----与数据库进行交互
- (void)loadMoreDeals
{
    self.currentPage++;
    
    [self.deals addObjectsFromArray:[ZYDealTool collectDeals:self.currentPage]];
    
    [self.collectionView reloadData];
    
    [self.collectionView.footer endRefreshing];
}


#pragma mark ----刷新方法
- (void)footerRefresh
{
    [self loadMoreDeals];
}


#pragma mark ----notification系列
- (void)collectStateDidChange:(NSNotification *)note
{
    [self.deals removeAllObjects];
    self.currentPage = 0;
    [self loadMoreDeals];
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
    
    self.collectionView.footer.hidden = (self.deals.count == [ZYDealTool collectDealsCount]);
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
