//
//  ZYMetaTool.m
//  团购HD
//
//  Created by 王志盼 on 15/8/17.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYMetaTool.h"
#import "MJExtension.h"
#import "ZYCity.h"
#import "ZYCategory.h"
#import "ZYSort.h"
#import "ZYDeal.h"
static NSArray *_cities;
static NSArray *_categories;
static NSArray *_sorts;
@implementation ZYMetaTool


/**
 *  返回城市
 */
+ (NSArray *)cities
{
    if (_cities == nil) {
        _cities = [ZYCity objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}

/**
 *  返回所有的分类数据
 */
+ (NSArray *)categories
{
    if (_categories == nil) {
        _categories = [ZYCategory objectArrayWithFilename:@"categories.plist"];
    }
    return _categories;
}

/**
 *  返回所有的排序数据
 */
+ (NSArray *)sorts
{
    if (_sorts == nil) {
        _sorts = [ZYSort objectArrayWithFilename:@"sorts.plist"];
    }
    return _sorts;
}

+ (ZYCategory *)categoryWithDeal:(ZYDeal *)deal
{
    NSArray *cs = [self categories];
    NSString *cname = [[deal.categories firstObject] substringToIndex:1];
    //    NSLog(@"----%@",cname);
    for (ZYCategory *c in cs) {
        if ([c.name containsString:cname]) return c;
        
        for (NSString *obj in c.subcategories) {
            if ([obj containsString:cname]) {
                return c;
            }
        }
    }
    return nil;
}
@end
