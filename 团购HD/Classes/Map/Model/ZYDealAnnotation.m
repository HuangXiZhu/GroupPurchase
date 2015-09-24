//
//  ZYDealAnnotation.m
//  团购HD
//
//  Created by 王志盼 on 15/9/23.
//  Copyright © 2015年 王志盼. All rights reserved.
//

#import "ZYDealAnnotation.h"

@implementation ZYDealAnnotation

/**
 *  这里需要重写这个方法，用来判断两个位置、标题一样的大头针
 *
 */
- (BOOL)isEqual:(ZYDealAnnotation *)object
{
    return [object.title isEqualToString:_title];
}

@end
