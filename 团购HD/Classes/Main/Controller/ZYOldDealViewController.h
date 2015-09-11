//
//  ZYOldDealViewController.h
//  团购HD
//
//  Created by 王志盼 on 15/9/6.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYDeal;

@interface ZYOldDealViewController : UICollectionViewController
/**
 *  这个方法交给子类去实现，从而得到不同子类的具体背景图片
 *
 */
- (NSString *)bgImageName;

/**
 *  这个方法交给子类去实现，从而得到不同子类数据库里的具体数据
 *
 */
- (NSArray *)arrayWithCurretnPage:(int)currentPage;

/**
 *  这个方法教给子类去调用，移除deals内所有数据，重新从数据库里加载
 */
- (void)removeDealsAllObjects;

/**
 *  让子类实现这个方法，返回数据库中还有多少条团购数据
 *
 */
- (int)countForDeals;

/**
 *  让子类实现这个方法，返回navigationBar的标题
 *
 */
- (NSString *)titleForNavBar;

/**
 *  让子类实现这个方法，删除掉自身数据库内拥有的deal
 *
 */
- (void)deletedSqliteDeal:(ZYDeal *)deal;
@end
