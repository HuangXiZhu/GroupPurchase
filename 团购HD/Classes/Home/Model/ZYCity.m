//
//  ZYCity.m
//  团购HD
//
//  Created by 王志盼 on 15/8/12.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ZYCity.h"
#import "MJExtension.h"
#import "ZYRegion.h"

@implementation ZYCity
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"regions" : [ZYRegion class]
             };
}
@end
