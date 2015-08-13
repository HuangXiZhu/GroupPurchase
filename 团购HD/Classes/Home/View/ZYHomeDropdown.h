//
//  ZYHomeDropdown.h
//  团购HD
//
//  Created by 王志盼 on 15/8/11.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYCategory;

@interface ZYHomeDropdown : UIView
@property (nonatomic, strong) NSArray *categories;
+ (instancetype)homeDropdown;
@end
