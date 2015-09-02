//
//  ZYDealTool.h
//  团购HD
//
//  Created by 王志盼 on 15/9/1.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZYDeal;

@interface ZYDealTool : NSObject
+ (void)addCollectionDeal:(ZYDeal *)deal;
+ (void)removeCollectionDeal:(ZYDeal *)deal;

+ (NSArray *)collectDeals:(int)page;
+ (int)collectDealsCount;

+ (BOOL)isCollected:(ZYDeal *)deal;
@end
