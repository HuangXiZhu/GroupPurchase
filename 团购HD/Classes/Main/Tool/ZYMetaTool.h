//
//  ZYMetaTool.h
//  团购HD
//
//  Created by 王志盼 on 15/8/17.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYMetaTool : NSObject
/**
 *  返回城市
 */
+ (NSArray *)cities;

/**
 *  返回所有的分类数据
 */
+ (NSArray *)categories;

/**
 *  返回所有的排序数据
 */
+ (NSArray *)sorts;
@end
