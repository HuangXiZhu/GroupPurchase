//
//  ZYSort.h
//  团购HD
//
//  Created by 王志盼 on 15/8/17.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYSort : NSObject
/** 排序名称 */
@property (nonatomic, copy) NSString *label;
/** 排序的值(将来发给服务器) */
@property (nonatomic, assign) int value;
@end
